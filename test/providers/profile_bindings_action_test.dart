import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/database/database.dart' as db;
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/app_paths.dart';
import '../helpers/test_profiles.dart';
import '../helpers/test_database_providers.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _AppliedSetup extends SetupAction {
  int checks = 0;
  bool applied = true;

  @override
  void build() {}

  @override
  Future<bool> inputsApplied() async {
    checks++;
    return applied;
  }
}

class _Bindings extends ProfileBindingsAction {
  bool fail = false;
  Completer<void>? gate;

  @override
  Future<void> validate(Profile candidate, {List<Rule>? localRules}) async {
    await gate?.future;
    if (fail) throw const FormatException('invalid binding');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(
      const TestDelayParams(
        proxyName: 'node',
        testUrl: 'https://test',
        timeout: 1,
      ),
    );
  });
  late Directory root;
  late db.Database database;
  late ProviderContainer container;
  late _Bindings action;
  late _Core core;
  late Profile source;
  late Profile other;
  late Profile target;

  setUp(() async {
    root = Directory.systemTemp.createTempSync('flsmart-bindings-action');
    await useAppPaths(root);
    await AppLocalizations.load(const Locale('en'));
    database = db.Database(NativeDatabase.memory());
    db.database = database;
    source = Profile.normal(label: 'Source');
    other = Profile.normal(label: 'Unrelated');
    target = Profile.normal(label: 'Target').copyWith(
      overrides: ProfileOverrides(
        subscriptions: [
          SubscriptionBinding(id: 'one', sourceId: source.id, name: 'One'),
          SubscriptionBinding(id: 'two', sourceId: source.id, name: 'Two'),
          SubscriptionBinding(id: 'other', sourceId: other.id, name: 'Other'),
        ],
      ),
    );
    for (final profile in [source, other, target]) {
      await database.profiles.put(profile.toCompanion());
      final file = await profile.file;
      await file.parent.create(recursive: true);
      await file.writeAsString('proxies: []');
    }
    core = _Core();
    when(() => core.validateConfig(any())).thenAnswer((_) async => null);
    when(() => core.compileRuleSet(any(), url: any(named: 'url'))).thenAnswer(
      (_) async => (
        behavior: RuleProviderBehavior.classical,
        format: RuleProviderFormat.yaml,
      ),
    );
    action = _Bindings();
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(
          () => TestProfiles([source, other, target]),
        ),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        profileBindingsActionProvider.overrideWith(() => action),
        clashProvidersProvider.overrideWith(TestClashProviders.new),
        scriptsProvider.overrideWith(TestScripts.new),
      ],
    );
    container.listen(clashProvidersProvider, (_, _) {});
    container.listen(scriptsProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await database.close();
    await root.delete(recursive: true);
  });

  test(
    'chain checks use applied cumulative paths and reject inactive profiles',
    () async {
      const chain = ProxyChain(
        id: 'latency',
        name: 'US route',
        hops: ['Entry', 'Middle', 'Exit'],
      );
      final profile = target.copyWith(
        overrides: const ProfileOverrides(chains: [chain]),
      );
      const names = ['Entry', 'US route · 第2跳 · Middle', 'US route'];
      when(() => core.getProxies()).thenAnswer(
        (_) async => const ProxiesData(
          proxies: {'Entry': {}, 'US route · 第2跳 · Middle': {}, 'US route': {}},
          all: names,
        ),
      );
      when(() => core.testDelay(any())).thenAnswer((call) async {
        final params = call.positionalArguments.single as TestDelayParams;
        return Delay(name: params.proxyName, url: params.testUrl, value: 80);
      });
      var applied = true;
      final checks = ProviderContainer.test(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          coreStatusProvider.overrideWithBuild((_, _) => CoreStatus.connected),
          runTimeProvider.overrideWithBuild((_, _) => 1),
          bindingsAppliedProvider.overrideWith((_, _) async => applied),
          coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        ],
      );
      checks.listen(bindingsAppliedProvider(profile.id), (_, _) {});
      final action = checks.read(profileBindingsActionProvider.notifier);
      for (var index = 0; index < chain.hops.length; index++) {
        expect(
          (await action.testChainHop(profile.id, chain, index)).name,
          names[index],
        );
      }
      final params = verify(
        () => core.testDelay(captureAny()),
      ).captured.cast<TestDelayParams>();
      expect(params.map((item) => item.proxyName), names);
      expect(params.map((item) => item.testUrl).toSet(), hasLength(1));
      expect(params.every((item) => item.timeout > 0), true);
      applied = false;
      checks.invalidate(bindingsAppliedProvider(profile.id));
      await expectLater(
        action.testChainHop(profile.id, chain, 1),
        throwsA(isA<MessageException>()),
      );
      verifyNever(() => core.testDelay(any()));
    },
  );

  test(
    'applied status checks once after setup inputs finish loading',
    () async {
      var inputs = Completer<SetupState>();
      final setup = _AppliedSetup();
      final statusContainer = ProviderContainer.test(
        overrides: [
          currentProfileIdProvider.overrideWithBuild((_, _) => target.id),
          setupStateProvider.overrideWith((_, _) => inputs.future),
          setupActionProvider.overrideWith(() => setup),
        ],
      );
      final status = bindingsAppliedProvider(target.id);
      statusContainer.listen(status, (_, _) {});
      await statusContainer.pump();
      expect(setup.checks, 0);
      final state = SetupState(
        profileId: target.id,
        profileLastUpdateDate: null,
        profileType: ProfileType.file,
        extendType: ExtendType.standard,
        rules: [],
        proxyGroups: [],
        addedRules: [],
        script: null,
        overrides: const ProfileOverrides(),
      );
      inputs.complete(state);
      expect(await statusContainer.read(status.future), true);
      expect(setup.checks, 1);
      inputs = Completer<SetupState>();
      statusContainer.invalidate(setupStateProvider(target.id));
      await statusContainer.pump();
      expect(setup.checks, 1);
      inputs.complete(state);
      expect(await statusContainer.read(status.future), true);
      expect(setup.checks, 2);
      setup.applied = false;
      statusContainer.invalidate(status);
      expect(await statusContainer.read(status.future), false);
    },
  );

  test(
    'inventory reads fresh provider nodes and imported source groups',
    () async {
      container.read(profileBindingsActionProvider.notifier);
      var name = 'HK';
      when(
        () => core.readConfig(
          any(),
          providerCachePath: any(named: 'providerCachePath'),
          providerPrefix: any(named: 'providerPrefix'),
        ),
      ).thenAnswer(
        (_) async => {
          'proxies': [
            {'name': 'Static', 'type': 'socks5'},
          ],
          'x-flsmart-provider-nodes': [
            {'name': name, 'type': 'snell', 'provider-name': 'remote'},
          ],
          'proxy-groups': [
            {'name': 'Smart', 'type': 'smart'},
          ],
        },
      );
      final first = await action.inventory(target.id);
      expect(
        first.proxies.map((node) => node.name),
        containsAll(['Static', 'HK', 'One · HK', 'Two · HK']),
      );
      expect(
        first.proxyGroups.map((group) => group.name),
        containsAll(['Smart', 'One', 'One · Smart', 'Two · Smart']),
      );
      name = 'US';
      final second = await action.inventory(target.id);
      expect(second.proxies.map((node) => node.name), contains('US'));
      expect(second.proxies.map((node) => node.name), isNot(contains('HK')));
      container
          .read(profilesProvider.notifier)
          .updateProfile(
            target.id,
            (profile) => profile.copyWith(
              overrides: profile.overrides.copyWith(attachmentsEnabled: false),
            ),
          );
      final disabled = await action.inventory(target.id);
      expect(disabled.proxies.map((node) => node.name), ['Static', 'US']);
    },
  );

  test('inventory uses groups produced by the profile script', () async {
    container.read(profileBindingsActionProvider.notifier);
    final evaluator = scriptEvaluator;
    addTearDown(() => scriptEvaluator = evaluator);
    final script = await Script(
      id: 77,
      label: 'Inventory script',
      lastUpdateTime: DateTime(2026),
    ).save('const main = (config) => config;');
    await database.scripts.put(script.toCompanion());
    target = target.copyWith(
      extendType: ExtendType.script,
      scriptId: script.id,
      overrides: target.overrides.copyWith(
        subscriptions: [
          SubscriptionBinding(
            id: 'one',
            sourceId: source.id,
            name: 'One',
            attachments: const [GroupAttachment(target: '% Proxy')],
          ),
        ],
      ),
    );
    container
        .read(profilesProvider.notifier)
        .updateProfile(target.id, (_) => target);
    when(
      () => core.readConfig(
        any(),
        providerCachePath: any(named: 'providerCachePath'),
        providerPrefix: any(named: 'providerPrefix'),
      ),
    ).thenAnswer(
      (_) async => {
        'proxies': [
          {'name': 'node', 'type': 'socks5'},
        ],
        'proxy-groups': [
          {
            'name': 'Original',
            'type': 'select',
            'proxies': ['node'],
          },
        ],
      },
    );
    var evaluations = 0;
    scriptEvaluator = ({required String script, required String config}) async {
      evaluations++;
      return jsonEncode({
        ...jsonDecode(config) as Map<String, dynamic>,
        'proxy-groups': [
          {
            'name': '% Proxy',
            'type': 'select',
            'proxies': ['node'],
          },
        ],
      });
    };

    final inventory = await action.inventory(target.id);

    expect(
      inventory.proxyGroups.map((group) => group.name),
      contains('% Proxy'),
    );
    expect(
      inventory.proxyGroups.map((group) => group.name),
      isNot(contains('Original')),
    );
    expect(
      inventory.proxyGroups.map((group) => group.name),
      contains('One · Original'),
    );
    expect(evaluations, 1);

    container
        .read(profilesProvider.notifier)
        .updateProfile(
          target.id,
          (profile) => profile.copyWith(
            overrides: profile.overrides.copyWith(subscriptionEnabled: false),
          ),
        );
    final disabled = await action.inventory(target.id);
    expect(
      disabled.proxyGroups.map((group) => group.name),
      contains('Original'),
    );
    expect(
      disabled.proxyGroups.map((group) => group.name),
      isNot(contains('% Proxy')),
    );
    expect(evaluations, 1);
  });

  test(
    'independent copy clones only selected resources and reuses one clone per source',
    () async {
      await container
          .read(profileBindingsActionProvider.notifier)
          .saveIndependentCopy(
            target,
            subscriptionIds: {'one', 'two'},
            ruleIds: {},
            copyScript: false,
          );
      final profiles = container.read(profilesProvider);
      expect(profiles, hasLength(4));
      final bindings = profiles.getProfile(target.id)!.overrides.subscriptions;
      expect(bindings[0].sourceId, bindings[1].sourceId);
      expect(bindings[0].sourceId, isNot(source.id));
      expect(bindings[2].sourceId, other.id);
      final copy = profiles.getProfile(bindings[0].sourceId)!;
      expect(await (await copy.file).readAsString(), 'proxies: []');
      expect(profiles.getProfile(source.id), source);
    },
  );

  test(
    'failed copy removes newly created resources and retains target bindings',
    () async {
      action.fail = true;
      await expectLater(
        container
            .read(profileBindingsActionProvider.notifier)
            .saveIndependentCopy(
              target,
              subscriptionIds: {'one', 'two'},
              ruleIds: {},
              copyScript: false,
            ),
        throwsFormatException,
      );
      expect(container.read(profilesProvider), [source, other, target]);
      final files = await Directory(
        await appPath.profilesPath,
      ).list().where((entry) => entry is File).toList();
      expect(files, hasLength(3));
    },
  );

  test(
    'concurrent binding edits cannot be overwritten by an older validation',
    () async {
      action.gate = Completer<void>();
      final saving = container
          .read(profileBindingsActionProvider.notifier)
          .save(
            target.copyWith(
              overrides: target.overrides.copyWith(attachmentsEnabled: false),
            ),
          );
      container
          .read(profilesProvider.notifier)
          .updateProfile(
            target.id,
            (profile) => profile.copyWith(
              overrides: profile.overrides.copyWith(chainsEnabled: false),
            ),
          );
      action.gate!.complete();
      await expectLater(saving, throwsA(isA<MessageException>()));
      final saved = container.read(profileProvider(target.id))!;
      expect(saved.overrides.chainsEnabled, false);
      expect(saved.overrides.attachmentsEnabled, true);
    },
  );

  for (final fail in [false, true]) {
    test(
      'rule and script independent copies clean up on failure: $fail',
      () async {
        final rules = ClashProvider.create(label: 'Rules');
        final script = await Script.create(
          label: 'Script',
        ).save('function main(config) { return config; }');
        final rulesFile = File(await rules.path);
        await rulesFile.parent.create(recursive: true);
        await rulesFile.writeAsString('payload: [DOMAIN,example.com]');
        await container.read(clashProvidersProvider.future);
        await container.read(scriptsProvider.future);
        container.read(clashProvidersProvider.notifier).put(rules);
        container.read(scriptsProvider.notifier).put(script);
        final candidate = target.copyWith(
          scriptId: script.id,
          overrides: target.overrides.copyWith(
            ruleBindings: [
              RuleSetBinding(id: 'rules', sourceId: rules.id, target: 'DIRECT'),
            ],
          ),
        );
        action.fail = fail;
        final saving = container
            .read(profileBindingsActionProvider.notifier)
            .saveIndependentCopy(
              candidate,
              subscriptionIds: {},
              ruleIds: {'rules'},
              copyScript: true,
            );
        if (fail) {
          await expectLater(saving, throwsFormatException);
          expect(await container.read(clashProvidersProvider.future), [rules]);
          expect(await container.read(scriptsProvider.future), [script]);
          expect(container.read(profileProvider(target.id)), target);
          expect(
            await rulesFile.parent
                .list()
                .where((entry) => entry is File)
                .length,
            1,
          );
          expect(await File(await script.path).parent.list().length, 1);
        } else {
          await saving;
          final saved = container.read(profileProvider(target.id))!;
          expect(saved.scriptId, isNot(script.id));
          final copiedScript = (await container.read(
            scriptsProvider.future,
          )).get(saved.scriptId)!;
          expect(await copiedScript.content, await script.content);
          final copiedRules = (await container.read(
            clashProvidersProvider.future,
          )).singleWhere((item) => item.id != rules.id);
          expect(saved.overrides.ruleBindings.single.sourceId, copiedRules.id);
          expect(
            await File(await copiedRules.path).readAsString(),
            await rulesFile.readAsString(),
          );
        }
        expect(await rulesFile.exists(), true);
        expect(await File(await script.path).exists(), true);
      },
    );
  }

  test(
    'local rules copy maps targets and avoids duplicate rule content',
    () async {
      final rule = Rule.parse('DOMAIN,example.com,Old');
      await database.rulesDao.putRule(rule, profileId: source.id);
      final existing = Rule.parse('DOMAIN,kept.example,DIRECT');
      await database.rulesDao.putRule(existing, profileId: target.id);
      final bindings = container.read(profileBindingsActionProvider.notifier);
      final copied = await bindings.copyLocalRules(source.id, target.id, {
        'Old': 'New',
      });
      expect(copied.map((rule) => rule.rawValue), [
        'DOMAIN,kept.example,DIRECT',
        'DOMAIN,example.com,New',
      ]);
      expect(copied.last.id, isNot(rule.id));
      expect(
        (await bindings.localRules(source.id)).single.rawValue,
        'DOMAIN,example.com,Old',
      );
    },
  );
}
