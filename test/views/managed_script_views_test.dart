import 'dart:convert';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/desktop/model.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/profiles/extend/extend.dart';
import 'package:fl_clash/views/profiles/managed_options.dart';
import 'package:fl_clash/views/profiles/script_options.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

class _FakeExtendCore extends CoreHandlerInterface {
  @override
  Future<CoreLifecycleResult> start() async => const CoreLifecycleResult(
    revision: 1,
    outcome: CoreLifecycleOutcome.applied,
  );

  @override
  Future<CoreLifecycleResult> restart() => start();

  @override
  Future<CoreLifecycleResult> stop() => start();

  @override
  Future<CoreLifecycleResult> close() => start();

  @override
  Future<Object?> invokeMethod({
    required CoreMethod method,
    Object? arguments,
    Duration? timeout,
  }) async {
    return jsonEncode({'proxies': const [], 'proxy-groups': const []});
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final originalEvaluator = scriptEvaluator;

  setUpAll(() async {
    PackageInfo.setMockInitialValues(
      appName: 'FlClash',
      packageName: 'com.follow.clash',
      version: '0.9.11',
      buildNumber: '1',
      buildSignature: '',
    );
    globalState.packageInfo = await PackageInfo.fromPlatform();
    await AppLocalizations.load(const Locale('en'));
  });

  tearDown(() {
    scriptEvaluator = originalEvaluator;
  });

  ProviderContainer containerFor(
    WidgetTester tester, {
    List<Profile> profiles = const [],
    ManagedProps managed = const ManagedProps(),
  }) {
    const size = Size(1100, 1200);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles(profiles)),
        currentProfileIdProvider.overrideWithBuild((_, _) => null),
        managedSettingProvider.overrideWithBuild((_, _) => managed),
        coreHandlerProvider.overrideWithValue(
          CoreController.scoped(_FakeExtendCore()),
        ),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).update((_) => size);
    return container;
  }

  testWidgets('ScriptOptionsView toggles Compatible_With_Bettbox options', (
    tester,
  ) async {
    scriptEvaluator =
        ({required String script, required String config}) async =>
            json.encode({
              'compatible': true,
              'options': {'OpenAI': true, 'AdBlock': false},
              'icons': <String, String>{},
              'policyGroupOptions': ['OpenAI'],
            });
    final container = containerFor(tester);
    Map<String, bool> latest = {};

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          child: HostScaffold(
            body: ScriptOptionsView(
              title: 'Demo',
              loadScript: () async => 'const Compatible_With_Bettbox = {};',
              initialValues: const {},
              onChanged: (next) => latest = next,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('OpenAI'), findsOneWidget);
    expect(find.text('AdBlock'), findsOneWidget);

    await tester.tap(find.text('OpenAI'));
    await tester.pumpAndSettle();
    expect(latest['OpenAI'], isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ScriptOptionsView reports incompatible scripts', (tester) async {
    scriptEvaluator =
        ({required String script, required String config}) async =>
            json.encode({
              'compatible': false,
              'options': <String, bool>{},
              'icons': <String, String>{},
              'policyGroupOptions': <String>[],
            });
    final container = containerFor(tester);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          child: HostScaffold(
            body: ScriptOptionsView(
              title: 'Plain',
              loadScript: () async => 'function main(c) { return c; }',
              initialValues: const {},
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(currentAppLocalizations.scriptOptionsIncompatibleDesc),
      findsOneWidget,
    );
  });

  testWidgets('ManagedOptionsView toggles smartAutoGroups setting', (
    tester,
  ) async {
    final container = containerFor(tester);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: ManagedOptionsView())),
      ),
    );
    for (var i = 0; i < 60; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 50)),
      );
      await tester.pump();
      if (find.text(currentAppLocalizations.none).evaluate().isEmpty) {
        break;
      }
    }
    await tester.pumpAndSettle();

    expect(find.text(currentAppLocalizations.smartAutoGroups), findsOneWidget);
    expect(container.read(managedSettingProvider).smartAutoGroups, isFalse);

    await tester.tap(find.text(currentAppLocalizations.smartAutoGroups));
    await tester.pumpAndSettle();

    expect(container.read(managedSettingProvider).smartAutoGroups, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('ExtendView allows switching profile to managed mode', (
    tester,
  ) async {
    final profile = Profile.normal(label: 'Main').copyWith(id: 5);
    final container = containerFor(tester, profiles: [profile]);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(
          child: HostScaffold(body: ExtendView(profileId: 5)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(currentAppLocalizations.managedMode), findsOneWidget);
    await tester.tap(find.text(currentAppLocalizations.managedMode));
    await tester.pumpAndSettle();

    expect(container.read(profileProvider(5))?.extendType, ExtendType.managed);
    expect(tester.takeException(), isNull);
  });
}
