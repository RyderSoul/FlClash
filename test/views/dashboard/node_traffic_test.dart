import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/widgets/node_traffic.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:prism_ui/prism_ui.dart';

import '../../helpers/host_scaffold.dart';
import '../../helpers/test_app.dart';

class _MockCore extends Mock implements CoreHandlerInterface {}

const _samples = [
  NodeTraffic(name: 'Tokyo · Smart 01', up: 1024, down: 3072),
  NodeTraffic(name: 'Singapore · Smart 02', up: 512, down: 1536),
  NodeTraffic(name: 'Hong Kong · Smart 03', up: 256, down: 768),
  NodeTraffic(name: 'Los Angeles · Smart 04', up: 128, down: 384),
  NodeTraffic(name: 'London · Smart 05', up: 64, down: 192),
  NodeTraffic(name: 'Frankfurt · Smart 06', up: 64, down: 192),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late _MockCore core;
  late ProviderContainer container;
  final previewKey = GlobalKey();

  setUpAll(() async {
    final loader = FontLoader('JetBrainsMono')
      ..addFont(rootBundle.load('assets/fonts/JetBrainsMono-Regular.ttf'));
    await loader.load();
  });

  setUp(() {
    core = _MockCore();
    when(() => core.getNodeTraffic()).thenAnswer((_) async => _samples);
    container = ProviderContainer(
      overrides: [
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        coreStatusProvider.overrideWithBuild((_, _) => CoreStatus.connected),
      ],
    );
    globalState.container = container;
  });

  tearDown(() => container.dispose());

  Future<void> pumpCard(
    WidgetTester tester, {
    double width = 400,
    Brightness brightness = Brightness.light,
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
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: 'JetBrainsMono',
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'JetBrainsMono',
          ),
          themeMode: brightness == Brightness.dark
              ? ThemeMode.dark
              : ThemeMode.light,
          child: HostScaffold(
            body: SingleChildScrollView(
              child: RepaintBoundary(
                key: previewKey,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: NodeTrafficCard(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  Future<void> teardownCard(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 2));
  }

  testWidgets('shows session totals and the four largest nodes', (
    tester,
  ) async {
    await pumpCard(tester);
    expect(find.text('Node traffic'), findsOneWidget);
    expect(find.text('This session'), findsOneWidget);
    expect(find.text('50.0%'), findsOneWidget);
    expect(find.text(_samples[0].name), findsOneWidget);
    expect(find.text(_samples[3].name), findsOneWidget);
    expect(find.text(_samples[4].name), findsNothing);
    expect(find.text('View all'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await teardownCard(tester);
  });

  testWidgets('opens the full ranking and resumes after closing it', (
    tester,
  ) async {
    await pumpCard(tester);
    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();
    expect(find.text(_samples[5].name), findsOneWidget);
    globalState.navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text(_samples[5].name), findsNothing);
    await tester.pump(const Duration(seconds: 3));
    verify(() => core.getNodeTraffic()).called(greaterThan(1));
    expect(tester.takeException(), isNull);
    await teardownCard(tester);
  });

  testWidgets('shows empty and failed reads and recovers automatically', (
    tester,
  ) async {
    when(() => core.getNodeTraffic()).thenAnswer((_) async => []);
    await pumpCard(tester);
    expect(find.textContaining('No proxy traffic yet.'), findsOneWidget);
    when(() => core.getNodeTraffic()).thenThrow(StateError('unavailable'));
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(
      find.text('Unable to refresh. Retrying automatically.'),
      findsOneWidget,
    );
    when(() => core.getNodeTraffic()).thenAnswer((_) async => _samples);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(find.text(_samples[0].name), findsOneWidget);
    expect(
      find.text('Unable to refresh. Retrying automatically.'),
      findsNothing,
    );
    await teardownCard(tester);
  });

  testWidgets('stops UI polling while the app is in the background', (
    tester,
  ) async {
    await pumpCard(tester);
    clearInteractions(core);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(seconds: 10));
    verifyNever(() => core.getNodeTraffic());
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    verify(() => core.getNodeTraffic()).called(1);
    await teardownCard(tester);
  });

  testWidgets('fits narrow layouts with long names and enlarged text', (
    tester,
  ) async {
    when(() => core.getNodeTraffic()).thenAnswer(
      (_) async => [
        const NodeTraffic(
          name:
              'A very long subscription node name that does not fit on one line',
          up: 1 << 30,
          down: 5 << 30,
        ),
      ],
    );
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpCard(tester, width: 320);
    expect(tester.takeException(), isNull);
    await teardownCard(tester);
  });

  for (final brightness in Brightness.values) {
    testWidgets('renders the ${brightness.name} traffic panel', (tester) async {
      await pumpCard(tester, brightness: brightness);
      expect(tester.takeException(), isNull);
      final directory = Platform.environment['NODE_TRAFFIC_PREVIEW_DIR'];
      if (directory != null) {
        final boundary =
            previewKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          await Directory(directory).create(recursive: true);
          await File(
            '$directory/node-traffic-${brightness.name}.png',
          ).writeAsBytes(png!.buffer.asUint8List());
        });
      }
      await teardownCard(tester);
    });
  }
}
