import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/widgets/profile_bindings.dart';
import 'package:fl_clash/views/profiles/bindings/manager.dart';
import 'package:fl_clash/views/profiles/bindings/copy.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';
import '../helpers/test_database_providers.dart';

class _Bindings extends ProfileBindingsAction {
  bool fail = false;

  @override
  Future<void> validate(Profile candidate, {List<Rule>? localRules}) async {
    if (fail) throw StateError('Invalid reference');
  }
}

class _Setup extends SetupAction {
  @override
  Future<bool> applyProfile({
    bool silence = false,
    bool force = false,
    Future<void> Function()? preloadInvoke,
  }) async => true;
}

class _CopyBindings extends _Bindings {
  Profile? saved;

  @override
  Future<ClashConfig> inventory(int profileId) async => const ClashConfig(
    proxyGroups: [ProxyGroup(id: 1, name: 'New', type: GroupType.Smart)],
    proxies: [
      Proxy(name: 'entry', type: 'ss'),
      Proxy(name: 'exit', type: 'ss'),
    ],
  );

  @override
  Future<List<Rule>> localRules(int profileId) async => [];

  @override
  Future<List<Rule>> copyLocalRules(
    int sourceId,
    int targetId,
    Map<String, String> mapping,
  ) async => [];

  @override
  Future<void> save(Profile candidate, {List<Rule>? localRules}) async {
    await validate(candidate, localRules: localRules);
    saved = candidate;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late Profile profile;
  late _Bindings bindings;
  final surfaceKey = GlobalKey();
  final previewFont = Platform.environment['FLSMART_PREVIEW_FONT'];

  setUpAll(() async {
    if (previewFont == null) return;
    final data = await File(previewFont).readAsBytes();
    await (FontLoader(
      'BindingPreview',
    )..addFont(Future.value(ByteData.sublistView(data)))).load();
  });

  setUp(() {
    final source = Profile.normal(label: 'Shared subscription');
    profile = Profile.normal(label: 'My profile').copyWith(
      overrides: ProfileOverrides(
        subscriptions: [
          SubscriptionBinding(
            id: 'sub',
            sourceId: source.id,
            name: 'Extra nodes',
          ),
        ],
        ruleBindings: const [
          RuleSetBinding(id: 'rules', sourceId: 3, target: 'DIRECT'),
        ],
      ),
    );
    bindings = _Bindings();
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile, source])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
        profileBindingsActionProvider.overrideWith(() => bindings),
        setupActionProvider.overrideWith(_Setup.new),
        bindingsAppliedProvider.overrideWith((_, _) async => false),
        scriptsProvider.overrideWith(TestScripts.new),
        clashProvidersProvider.overrideWith(TestClashProviders.new),
      ],
    );
    globalState.container = container;
  });

  tearDown(() => container.dispose());

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    double width = 400,
    bool dark = false,
  }) async {
    tester.view.physicalSize = Size(width, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    container.read(viewSizeProvider.notifier).value = Size(width, 1000);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: RepaintBoundary(
          key: surfaceKey,
          child: TestApp(
            locale: const Locale('zh', 'CN'),
            theme: ThemeData(
              brightness: Brightness.light,
              fontFamily: previewFont == null ? null : 'BindingPreview',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: previewFont == null ? null : 'BindingPreview',
            ),
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
            child: child,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'manager shows missing resources and keeps bindings when toggled',
    (tester) async {
      await pump(tester, ProfileBindingsView(profileId: profile.id));
      expect(find.text('Extra nodes'), findsOneWidget);
      expect(find.textContaining('资源不存在'), findsOneWidget);
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();
      final saved = container.read(profileProvider(profile.id))!;
      expect(saved.overrides.attachmentsEnabled, false);
      expect(saved.overrides.subscriptions, profile.overrides.subscriptions);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('failed save displays error and releases the busy state', (
    tester,
  ) async {
    bindings.fail = true;
    await pump(tester, ProfileBindingsView(profileId: profile.id));
    await tester.tap(find.byType(Switch).first);
    await tester.pumpAndSettle();
    expect(find.textContaining('Invalid reference'), findsOneWidget);
    expect(
      container.read(profileProvider(profile.id))!.overrides.attachmentsEnabled,
      true,
    );
    expect(
      tester.widget<Switch>(find.byType(Switch).first).onChanged,
      isNotNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'copy requires mapping and preserves subscription modes and chain targets',
    (tester) async {
      final source = profile.copyWith(
        matchTarget: 'Old',
        overrides: profile.overrides.copyWith(
          replaceRules: true,
          subscriptions: [
            profile.overrides.subscriptions.single.copyWith(
              attachments: const [
                GroupAttachment(
                  target: 'Old',
                  mode: SubscriptionAttachMode.group,
                ),
              ],
            ),
          ],
          ruleBindings: const [
            RuleSetBinding(id: 'r', sourceId: 3, target: 'Old'),
          ],
          chains: const [
            ProxyChain(
              id: 'c',
              name: 'Chain',
              hops: ['entry', 'exit'],
              targetGroups: ['Old'],
            ),
          ],
        ),
      );
      final target = Profile.normal(label: 'Target');
      final action = _CopyBindings();
      container.dispose();
      container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([source, target])),
          profileBindingsActionProvider.overrideWith(() => action),
        ],
      );
      globalState.container = container;
      await pump(
        tester,
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              PageRouteBuilder<void>(
                pageBuilder: (_, _, _) =>
                    CopyBindingsView(profileId: source.id),
              ),
            ),
            child: const Text('Open copy'),
          ),
        ),
      );
      await tester.tap(find.text('Open copy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('目标配置'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Target').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('保存'));
      await tester.pumpAndSettle();
      expect(action.saved, isNull);
      expect(find.textContaining('请选择目标配置'), findsOneWidget);
      await tester.ensureVisible(find.text('Old'));
      await tester.tap(find.text('Old'));
      await tester.pumpAndSettle();
      final sheet = tester.widget<SelectionSheet<String>>(
        find.byType(SelectionSheet<String>),
      );
      expect(
        sheet.sections.expand((section) => section.items),
        contains('New'),
      );
      await tester.tap(find.text('New').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('保存'));
      await tester.pumpAndSettle();
      expect(action.saved?.id, target.id);
      expect(action.saved?.matchTarget, 'New');
      expect(action.saved?.overrides.replaceRules, true);
      expect(
        action.saved?.overrides.subscriptions.single.attachments.single,
        const GroupAttachment(
          target: 'New',
          mode: SubscriptionAttachMode.group,
        ),
      );
      expect(action.saved?.overrides.ruleBindings.single.target, 'New');
      expect(action.saved?.overrides.chains.single.targets, {'New'});
      expect(container.read(profileProvider(source.id)), source);
      expect(tester.takeException(), isNull);
    },
  );

  for (final (width, dark) in [(360.0, false), (400.0, true), (900.0, false)]) {
    testWidgets('dashboard renders at $width in ${dark ? 'dark' : 'light'} mode', (
      tester,
    ) async {
      final key = GlobalKey();
      await pump(
        tester,
        HostScaffold(
          body: SingleChildScrollView(
            child: RepaintBoundary(
              key: key,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: ProfileBindingsCard(),
              ),
            ),
          ),
        ),
        width: width,
        dark: dark,
      );
      expect(find.text('配置管理'), findsOneWidget);
      expect(find.byType(Switch), findsNWidgets(4));
      expect(tester.takeException(), isNull);
      final output = Platform.environment['NODE_TRAFFIC_PREVIEW_DIR'];
      if (output != null) {
        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 2);
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          await Directory(output).create(recursive: true);
          await File(
            '$output/profile-bindings-${width.toInt()}-${dark ? 'dark' : 'light'}.png',
          ).writeAsBytes(data!.buffer.asUint8List());
        });
      }
      await tester.tap(find.text('配置管理'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileBindingsView), findsOneWidget);
      expect(tester.takeException(), isNull);
      if (output != null) {
        await tester.runAsync(() async {
          final boundary =
              surfaceKey.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 2);
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          await File(
            '$output/binding-manager-${width.toInt()}-${dark ? 'dark' : 'light'}.png',
          ).writeAsBytes(data!.buffer.asUint8List());
        });
      }
    });
  }
}
