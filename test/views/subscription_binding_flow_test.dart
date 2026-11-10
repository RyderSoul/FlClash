import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/database/database.dart' as db;
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/profiles/bindings/manager.dart';
import 'package:fl_clash/views/profiles/bindings/forms.dart';
import 'package:fl_clash/views/profiles/extend/chains.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yaml/yaml.dart';

import '../helpers/app_paths.dart';
import '../helpers/preferences.dart';
import '../helpers/test_app.dart';
import '../plugins/code_forge/support.dart' show initEditorNative;

class _Core extends Mock implements CoreHandlerInterface {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory root;
  late db.Database database;
  late ProviderContainer container;
  late Profile target;
  late Profile source;
  late _Core core;
  late List<Map> validated;
  late List<Map> applied;
  String? validationError;

  setUpAll(() async {
    registerFallbackValue(
      const SetupParams(
        selectedMap: {},
        options: CoreOptions(testUrl: ''),
      ),
    );
    await initEditorNative();
  });

  setUp(() async {
    root = await Directory.systemTemp.createTemp('flsmart-subscription-flow');
    await useAppPaths(root);
    await mockPreferences();
    database = db.Database(NativeDatabase.memory());
    db.database = database;
    source = Profile.normal(label: 'Extra source');
    target = Profile.normal(label: 'Main profile');
    validated = [];
    applied = [];
    validationError = null;
    globalState.lastConfigMd5 = null;
    globalState.packageInfo = PackageInfo(
      appName: 'flsmart',
      packageName: 'com.rydersoul.flclash',
      version: '0.9.10',
      buildNumber: '0',
    );
    core = _Core();
    when(
      () => core.readConfig(
        any(),
        providerCachePath: any(named: 'providerCachePath'),
        providerPrefix: any(named: 'providerPrefix'),
      ),
    ).thenAnswer((call) async {
      final isSource =
          call.positionalArguments.single ==
          await appPath.getProfilePath(source.id.toString());
      return {
        'proxies': [
          {
            'name': isSource ? 'Extra node' : 'Base node',
            'type': 'socks5',
            'server': '127.0.0.1',
            'port': 1080,
          },
          if (!isSource)
            {
              'name': 'Exit node',
              'type': 'socks5',
              'server': '127.0.0.1',
              'port': 1081,
            },
        ],
        'proxy-groups': [
          {
            'name': 'Original',
            'type': 'select',
            'proxies': [isSource ? 'Extra node' : 'Base node'],
            'interval': '300',
          },
        ],
        'rule': ['MATCH,Original'],
      };
    });
    when(() => core.validateConfig(any())).thenAnswer((call) async {
      final config =
          loadYaml(
                await File(
                  call.positionalArguments.single as String,
                ).readAsString(),
              )
              as Map;
      validated.add(config);
      final executable = Platform.environment['FLSMART_BINDINGS_CORE_TEST'];
      if (executable != null && validationError == null) {
        final fixture = File('${root.path}/validation.json');
        await fixture.writeAsString(
          jsonEncode({'config': config, 'groups': {}, 'home': root.path}),
        );
        final result = await Process.run(
          executable,
          [r'-test.run=^TestCompiledProfileBindings$'],
          environment: {'FLSMART_BINDING_FIXTURE': fixture.path},
        );
        expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
      }
      return validationError;
    });
    when(() => core.setupConfig(any())).thenAnswer((_) async {
      applied.add(
        loadYaml(await File(await appPath.configFilePath).readAsString())
            as Map,
      );
    });
    when(() => core.getExternalProviders()).thenAnswer((_) async => []);
    when(() => core.getProxies()).thenAnswer(
      (_) async => const ProxiesData(
        proxies: {
          'Original': {
            'name': 'Original',
            'type': 'Selector',
            'all': ['Base node'],
          },
          'Base node': {'name': 'Base node', 'type': 'Socks5'},
        },
        all: ['Original', 'Base node'],
      ),
    );
    container = ProviderContainer(
      overrides: [
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        currentProfileIdProvider.overrideWithBuild((_, _) => target.id),
        safeModeProvider.overrideWithValue(true),
      ],
    );
    globalState.container = container;
  });

  tearDown(() async {
    container.dispose();
    await database.close();
    await root.delete(recursive: true);
    globalState.lastConfigMd5 = null;
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 100; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 25)),
      );
      await tester.pump(const Duration(milliseconds: 100));
      if (i >= 7 && !tester.binding.hasScheduledFrame) break;
    }
    await tester.pumpAndSettle();
  }

  Future<void> open(WidgetTester tester, {required bool script}) async {
    await tester.runAsync(() async {
      if (script) {
        final saved =
            await Script(
              id: 77,
              label: 'Real JS',
              lastUpdateTime: DateTime(2026),
            ).save('''
function main(config) {
  config['proxy-groups'] = [{
    name: '% Proxy', type: 'select', proxies: ['Base node'],
    interval: '300', timeout: '5000', 'max-failed-times': '5'
  }];
  config.rules = ['MATCH,% Proxy'];
  return config;
}
''');
        await database.scripts.put(saved.toCompanion());
        target = target.copyWith(
          extendType: ExtendType.script,
          scriptId: saved.id,
          overrides: target.overrides.copyWith(rulesEnabled: true),
        );
      }
      for (final profile in [source, target]) {
        await database.profiles.put(profile.toCompanion());
        final file = await profile.file;
        await file.parent.create(recursive: true);
        await file.writeAsString('proxies: []');
      }
    });
    container.read(profilesProvider);
    tester.view.physicalSize = const Size(430, 1100);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    container.read(viewSizeProvider.notifier).value = const Size(430, 1100);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          locale: const Locale('en'),
          child: ProfileBindingsView(profileId: target.id),
        ),
      ),
    );
    await settle(tester);
    await tester.tap(find.text('Add').first);
    await settle(tester);
    expect(find.byType(FormPage), findsOneWidget);
    await tester.tap(find.text('Source'));
    await settle(tester);
    await tester.tap(find.text('Extra source').last);
    await settle(tester);
  }

  Future<void> attach(WidgetTester tester, String group, String mode) async {
    final scroll = find
        .descendant(
          of: find.byType(FormPage),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(find.text(group), 200, scrollable: scroll);
    await tester.tap(find.text(group));
    await settle(tester);
    await tester.tap(find.text(mode).last);
    await settle(tester);
  }

  for (final script in [false, true]) {
    for (final mode in ['Expand nodes', 'Reference group']) {
      testWidgets('add, persist and apply subscription: JS=$script, $mode', (
        tester,
      ) async {
        await open(tester, script: script);
        final group = script ? '% Proxy' : 'Original';
        await attach(tester, group, mode);
        await tester.runAsync(() => tester.tap(find.byTooltip('Save')));
        await settle(tester);
        expect(find.byType(FormPage), findsNothing);
        final saved = await tester.runAsync(
          () => database.profilesDao.query().get(),
        );
        final binding = saved!
            .getProfile(target.id)!
            .overrides
            .subscriptions
            .single;
        expect(binding.sourceId, source.id);
        expect(binding.attachments.single.target, group);
        expect(
          binding.attachments.single.mode,
          mode == 'Expand nodes'
              ? SubscriptionAttachMode.nodes
              : SubscriptionAttachMode.group,
        );
        final expected = [
          'Base node',
          mode == 'Expand nodes' ? 'Extra source · Extra node' : 'Extra source',
        ];
        List members(Map config) =>
            (config['proxy-groups'] as List).cast<Map>().firstWhere(
                  (item) => item['name'] == group,
                )['proxies']
                as List;
        expect(members(validated.last), expected);
        if (script) {
          await tester.runAsync(() => tester.tap(find.byType(Switch).first));
          await settle(tester);
          expect(
            container
                .read(profileProvider(target.id))!
                .overrides
                .attachmentsEnabled,
            false,
          );
          expect(members(validated.last), ['Base node']);
          await tester.runAsync(() => tester.tap(find.byType(Switch).first));
          await settle(tester);
          expect(
            container
                .read(profileProvider(target.id))!
                .overrides
                .attachmentsEnabled,
            true,
          );
          expect(members(validated.last), expected);
        }
        await tester.runAsync(() => tester.tap(find.byTooltip('Apply now')));
        await settle(tester);
        expect(applied, hasLength(1));
        expect(members(applied.single), expected);
        if (script) {
          final policy = (applied.single['proxy-groups'] as List)
              .cast<Map>()
              .firstWhere((item) => item['name'] == group);
          expect(policy['interval'], '300');
          expect(policy['timeout'], '5000');
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('a rejected subscription is not persisted and can be corrected', (
    tester,
  ) async {
    await open(tester, script: true);
    await attach(tester, '% Proxy', 'Expand nodes');
    validationError = 'Rejected subscription fixture';
    await tester.runAsync(() => tester.tap(find.byTooltip('Save')));
    await settle(tester);
    expect(
      find.textContaining('Rejected subscription fixture'),
      findsOneWidget,
    );
    expect(
      container.read(profileProvider(target.id))!.overrides.subscriptions,
      isEmpty,
    );
    final saved = await tester.runAsync(
      () => database.profilesDao.query().get(),
    );
    expect(saved!.getProfile(target.id)!.overrides.subscriptions, isEmpty);
    expect(applied, isEmpty);
    validationError = null;
    await tester.runAsync(() => tester.tap(find.byTooltip('Save')));
    await settle(tester);
    expect(find.byType(FormPage), findsNothing);
    expect(
      container.read(profileProvider(target.id))!.overrides.subscriptions,
      hasLength(1),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('cancelling a subscription leaves the profile unchanged', (
    tester,
  ) async {
    await open(tester, script: true);
    await attach(tester, '% Proxy', 'Reference group');
    globalState.navigatorKey.currentState!.pop();
    await settle(tester);
    expect(
      container.read(profileProvider(target.id))!.overrides.subscriptions,
      isEmpty,
    );
    expect(validated, isEmpty);
    expect(applied, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'routing override selects a real JS policy, persists and applies',
    (tester) async {
      await open(tester, script: true);
      globalState.navigatorKey.currentState!.pop();
      await settle(tester);
      final rules = ClashProvider.create(label: 'Local rules');
      await tester.runAsync(() async {
        await database.clashProviders.put(rules.toCompanion());
        await File(
          await rules.path,
        ).safeWriteAsBytes(utf8.encode('payload:\n  - DOMAIN,example.com\n'));
      });
      await settle(tester);
      unawaited(
        editRuleBinding(
          tester.element(find.byType(ProfileBindingsView)),
          target.id,
        ),
      );
      await settle(tester);
      await tester.tap(find.text('Source'));
      await settle(tester);
      await tester.tap(find.text('Local rules').last);
      await settle(tester);
      await tester.tap(find.text('Split strategy'));
      await settle(tester);
      expect(find.text('% Proxy'), findsOneWidget);
      await tester.tap(find.text('% Proxy'));
      await settle(tester);
      await tester.runAsync(() => tester.tap(find.byTooltip('Save')));
      await settle(tester);
      expect(
        tester
            .widgetList<ErrorBanner>(find.byType(ErrorBanner))
            .map((item) => item.message)
            .whereType<String>(),
        isEmpty,
      );
      expect(find.byType(FormPage), findsNothing);
      final rows = await tester.runAsync(
        () => database.profilesDao.query().get(),
      );
      expect(
        rows!.getProfile(target.id)!.overrides.ruleBindings.single.target,
        '% Proxy',
      );
      await tester.runAsync(() => tester.tap(find.byTooltip('Apply now')));
      await settle(tester);
      final binding = rows
          .getProfile(target.id)!
          .overrides
          .ruleBindings
          .single;
      expect(
        applied.single['rules'],
        contains('RULE-SET,flsmart-rule-${binding.id},% Proxy'),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'chain selects a JS group and original node, then saves through the real validator',
    (tester) async {
      await open(tester, script: true);
      globalState.navigatorKey.currentState!.pop();
      await settle(tester);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            locale: const Locale('en'),
            child: ProxyChainsView(profileId: target.id),
          ),
        ),
      );
      await settle(tester);
      await tester.runAsync(
        () => tester.tap(find.byTooltip('Add proxy chain')),
      );
      await settle(tester);
      await tester.enterText(find.byType(EditableText).first, 'Route');
      FocusManager.instance.primaryFocus?.unfocus();
      await settle(tester);
      for (final hop in ['% Proxy', 'Exit node']) {
        final scroll = find
            .descendant(
              of: find.byType(FormPage),
              matching: find.byType(Scrollable),
            )
            .first;
        await tester.scrollUntilVisible(
          find.byType(MoreActionButton),
          200,
          scrollable: scroll,
        );
        await tester.runAsync(() => tester.tap(find.byType(MoreActionButton)));
        await settle(tester);
        expect(find.text(hop), findsOneWidget);
        await tester.tap(find.text(hop));
        await settle(tester);
      }
      await tester.runAsync(() => tester.tap(find.byTooltip('Save')));
      await settle(tester);
      expect(
        tester
            .widgetList<ErrorBanner>(find.byType(ErrorBanner))
            .map((item) => item.message)
            .whereType<String>(),
        isEmpty,
      );
      expect(find.byType(FormPage), findsNothing);
      final rows = await tester.runAsync(
        () => database.profilesDao.query().get(),
      );
      final chain = rows!.getProfile(target.id)!.overrides.chains.single;
      expect(chain.name, 'Route');
      expect(chain.hops, ['% Proxy', 'Exit node']);
      expect(validated, hasLength(2));
      expect(tester.takeException(), isNull);
    },
  );
}
