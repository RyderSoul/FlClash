import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/widgets/profile_bindings.dart';
import 'package:fl_clash/views/profiles/bindings/manager.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/rendering.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;
  late Profile profile;
  late _Bindings bindings;

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
        child: TestApp(
          locale: const Locale('zh', 'CN'),
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          child: child,
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

  for (final (width, dark) in [(360.0, false), (400.0, true), (900.0, false)]) {
    testWidgets(
      'dashboard renders at $width in ${dark ? 'dark' : 'light'} mode',
      (tester) async {
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
                key.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
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
      },
    );
  }
}
