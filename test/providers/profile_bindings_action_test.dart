import 'dart:async';
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
  late Directory root;
  late db.Database database;
  late ProviderContainer container;
  late _Bindings action;
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
    final core = _Core();
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
