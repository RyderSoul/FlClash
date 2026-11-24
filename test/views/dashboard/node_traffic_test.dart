import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/widgets/node_traffic.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prism_ui/prism_ui.dart';

import '../../helpers/host_scaffold.dart';
import '../../helpers/test_app.dart';

const _samples = [
  NodeTraffic(name: 'Tokyo · Smart 01', up: 1024, down: 3072),
  NodeTraffic(name: 'Singapore · Smart 02', up: 512, down: 1536),
  NodeTraffic(name: 'Hong Kong · Smart 03', up: 256, down: 768),
  NodeTraffic(name: 'Los Angeles · Smart 04', up: 128, down: 384),
  NodeTraffic(name: 'London · Smart 05', up: 64, down: 192),
  NodeTraffic(name: 'Frankfurt · Smart 06', up: 64, down: 192),
];

void _seedTraffic(NodeTrafficBook book, List<NodeTraffic> items) {
  book.clear();
  var id = 1;
  book.applyConnections(
    ConnectionsChanged(
      ConnectionDelta(
        opened: [
          for (final item in items)
            ConnectionInfo(
              id: id++,
              start: 1000,
              network: 'tcp',
              sourceIp: '127.0.0.1',
              sourcePort: 10000 + id,
              destinationPort: 443,
              inboundType: 'tun',
              chains: [item.name],
              providerChains: item.provider.isEmpty
                  ? const []
                  : [item.provider],
              rule: 'MATCH',
              upload: item.up,
              download: item.down,
            ),
        ],
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProviderContainer container;

  setUpAll(() async {
    final loader = FontLoader('JetBrainsMono')
      ..addFont(rootBundle.load('assets/fonts/JetBrainsMono-Regular.ttf'));
    await loader.load();
  });

  setUp(() {
    container = ProviderContainer();
    _seedTraffic(container.read(nodeTrafficBookProvider), _samples);
    globalState.container = container;
  });

  tearDown(() => container.dispose());

  Future<void> pumpCard(
    WidgetTester tester, {
    double width = 400,
    double height = 1000,
    Brightness brightness = Brightness.light,
  }) async {
    tester.view.physicalSize = Size(width, height);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    container.read(viewSizeProvider.notifier).value = Size(width, height);
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
          child: const HostScaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: NodeTrafficCard(),
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
    expect(container.read(connectionBookProvider).demand.wanted, isTrue);
    expect(tester.takeException(), isNull);
    await teardownCard(tester);
    expect(container.read(connectionBookProvider).demand.wanted, isFalse);
  });

  testWidgets('opens the full ranking and resumes after closing it', (
    tester,
  ) async {
    await pumpCard(tester, height: 1800);
    await tester.tap(find.text('View all'));
    await tester.pumpAndSettle();
    expect(find.text(_samples[5].name), findsOneWidget);
    expect(container.read(connectionBookProvider).demand.wanted, isTrue);

    globalState.navigatorKey.currentState!.pop();
    await tester.pumpAndSettle();
    expect(find.text(_samples[5].name), findsNothing);
    expect(container.read(connectionBookProvider).demand.wanted, isTrue);

    _seedTraffic(container.read(nodeTrafficBookProvider), const [
      NodeTraffic(name: 'Osaka · Smart 07', up: 2048, down: 6144),
    ]);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(find.text('Osaka · Smart 07'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await teardownCard(tester);
  });

  testWidgets('shows empty state and updates when proxy traffic arrives', (
    tester,
  ) async {
    container.read(nodeTrafficBookProvider).clear();
    await pumpCard(tester);
    expect(find.textContaining('No proxy traffic yet.'), findsOneWidget);

    _seedTraffic(container.read(nodeTrafficBookProvider), _samples);
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    expect(find.text(_samples[0].name), findsOneWidget);
    await teardownCard(tester);
  });

  testWidgets('stops UI polling while the app is in the background', (
    tester,
  ) async {
    await pumpCard(tester);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    _seedTraffic(container.read(nodeTrafficBookProvider), const [
      NodeTraffic(name: 'Seoul · Smart 08', up: 1024, down: 1024),
    ]);
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('Seoul · Smart 08'), findsNothing);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    await tester.pump();
    expect(find.text('Seoul · Smart 08'), findsOneWidget);
    await teardownCard(tester);
  });

  testWidgets('fits narrow layouts with long names and enlarged text', (
    tester,
  ) async {
    _seedTraffic(container.read(nodeTrafficBookProvider), const [
      NodeTraffic(
        name:
            'A very long subscription node name that does not fit on one line',
        up: 1 << 30,
        down: 5 << 30,
      ),
    ]);
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
      await teardownCard(tester);
    });
  }
}
