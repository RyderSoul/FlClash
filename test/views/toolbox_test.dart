import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/desktop/model.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/views/dashboard/layout.dart';
import 'package:fl_clash/views/dashboard/widgets/toolbox.dart';
import 'package:fl_clash/views/toolbox/toolbox.dart';
import 'package:fl_clash/views/tools.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/host_scaffold.dart';
import '../helpers/test_app.dart';

class _FakeToolboxCore extends CoreHandlerInterface {
  final invoked = <CoreMethod>[];

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
    invoked.add(method);
    return switch (method) {
      CoreMethod.toolboxSpeedTestProbe || CoreMethod.toolboxSpeedTestStart => {
        'provider': 'cloudflare',
        'protocol': 'h1',
        'phase': 'done',
        'progress': 1.0,
        'download': 120000000.0,
        'upload': 40000000.0,
        'latency': 18.0,
        'jitter': 1.5,
        'rpm': 210,
        'exit-ip': '203.0.113.5',
        'outbound': {
          'chains': ['Proxy', 'HK-01'],
        },
        'server': {'colo': 'HKG', 'city': 'Hong Kong', 'country': 'HK'},
        'error': '',
      },
      CoreMethod.toolboxSpeedTestServers => [
        {'host': 'hkg.example.com:8080', 'name': 'HK', 'sponsor': 'ISP'},
      ],
      CoreMethod.toolboxSpeedTestCancel ||
      CoreMethod.toolboxMrsCancel ||
      CoreMethod.toolboxStunCancel ||
      CoreMethod.toolboxPingCancel => true,
      CoreMethod.toolboxRouteTrace => {
        'target': 'www.google.com',
        'mode': 'rule',
        'total': 4,
        'checked': 2,
        'support-udp': true,
        'match-time': 0.8,
        'matched': {
          'index': 1,
          'type': 'DomainSuffix',
          'payload': 'google.com',
          'adapter': 'Proxy',
          'matched': true,
        },
        'chains': [
          {'name': 'Proxy', 'type': 'Selector'},
          {'name': 'HK-01', 'type': 'Shadowsocks'},
        ],
        'steps': [
          {
            'index': 0,
            'type': 'DomainSuffix',
            'payload': 'cn',
            'adapter': 'DIRECT',
          },
          {
            'index': 1,
            'type': 'DomainSuffix',
            'payload': 'google.com',
            'adapter': 'Proxy',
            'matched': true,
          },
        ],
        'error': '',
      },
      CoreMethod.toolboxDnsQuery => {
        'domain': 'www.google.com',
        'type': 'A',
        'mode': 'follow',
        'rcode': 'NOERROR',
        'elapsed': 12.0,
        'route': 'fake-ip',
        'fake-ip-range': '198.18.0.1/16',
        'answers': [
          {
            'name': 'www.google.com',
            'type': 'A',
            'ttl': 1,
            'data': '198.18.0.5',
          },
        ],
        'error': '',
      },
      CoreMethod.toolboxMrsPrepare => {
        'version': 'cached',
        'geosite': 4,
        'geoip': 2,
        'error': '',
      },
      CoreMethod.toolboxMrsLookup => {
        'target': 'www.google.com',
        'host': 'www.google.com',
        'ips': ['142.250.1.1'],
        'matches': [
          {
            'kind': 'geosite',
            'name': 'google',
            'file': 'ruleset/google.mrs',
            'count': 80,
            'via': 'www.google.com',
            'referenced': true,
          },
        ],
        'error': '',
      },
      CoreMethod.toolboxMrsDump => '+.google.com\n',
      CoreMethod.toolboxStunStart => {
        'phase': 'done',
        'progress': 1.0,
        'server': 'stun.cloudflare.com:3478',
        'nat-type': 'full-cone',
        'mapping': 'independent',
        'filtering': 'independent',
        'rfc5780': true,
        'external-ip': '198.51.100.8',
        'external-port': 40000,
        'local-ip': '10.0.0.2',
        'local-port': 40000,
        'port-preserved': 1,
        'latency': 19.0,
        'jitter': 2.0,
        'packet-loss': 0.0,
        'error': '',
      },
      CoreMethod.toolboxPingStart => {
        'phase': 'done',
        'target': '1.1.1.1',
        'sent': 2,
        'replies': [
          {'seq': 1, 'status': 'ok', 'rtt': 11.2, 'ttl': 57, 'bytes': 32},
        ],
        'error': '',
      },
      CoreMethod.toolboxAgeKeygen => {
        'public-key': 'age1testpub',
        'secret-key': 'AGE-SECRET-KEY-1TESTSEC',
      },
      CoreMethod.toolboxAgeCrypt => {
        'data': '-----BEGIN AGE ENCRYPTED FILE-----',
        'error': '',
      },
      _ => null,
    };
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await AppLocalizations.load(const Locale('en'));
  });

  (ProviderContainer, _FakeToolboxCore) setupContainer(WidgetTester tester) {
    const size = Size(1000, 1200);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final fake = _FakeToolboxCore();
    final container = ProviderContainer(
      overrides: [
        coreHandlerProvider.overrideWithValue(CoreController.scoped(fake)),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    container.read(viewSizeProvider.notifier).update((_) => size);
    return (container, fake);
  }

  testWidgets('ToolboxCard and ToolsView expose ToolboxView', (tester) async {
    final (container, _) = setupContainer(tester);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(
          child: HostScaffold(
            body: DashboardDensityScope(
              density: DashboardDensity.standard,
              scale: 1,
              child: ToolboxCard(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(currentAppLocalizations.toolbox), findsOneWidget);
    expect(find.text(currentAppLocalizations.speedTest), findsOneWidget);
    await tester.tap(find.text(currentAppLocalizations.toolbox));
    await tester.pumpAndSettle();
    expect(find.byType(ToolboxView), findsOneWidget);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: ToolsView())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(currentAppLocalizations.toolbox), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('SpeedTestView runs speed test and renders throughput', (
    tester,
  ) async {
    final (container, fake) = setupContainer(tester);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: SpeedTestView())),
      ),
    );
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxSpeedTestProbe));

    await tester.tap(find.text(currentAppLocalizations.start));
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxSpeedTestStart));
    expect(find.text('120.00 Mbps'), findsOneWidget);
    expect(find.text('203.0.113.5'), findsOneWidget);
  });

  testWidgets('RouteTraceView and DnsLookupView display core answers', (
    tester,
  ) async {
    final (container, fake) = setupContainer(tester);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: RouteTraceView())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(currentAppLocalizations.run));
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxRouteTrace));
    expect(find.text('Proxy -> HK-01'), findsOneWidget);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: DnsLookupView())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(currentAppLocalizations.run));
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxDnsQuery));
    expect(find.text('198.18.0.5'), findsOneWidget);
  });

  testWidgets('MrsLookupView searches and opens dump view', (tester) async {
    final (container, fake) = setupContainer(tester);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: MrsLookupView())),
      ),
    );
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxMrsPrepare));
    await tester.tap(find.text(currentAppLocalizations.run));
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxMrsLookup));
    expect(find.text('google'), findsOneWidget);
    await tester.tap(find.text('google'));
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxMrsDump));
    expect(tester.takeException(), isNull);
  });

  testWidgets('NatTestView, LocalPingView and AgeToolView work', (
    tester,
  ) async {
    final (container, fake) = setupContainer(tester);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: NatTestView())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(currentAppLocalizations.start));
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxStunStart));
    expect(find.text('198.51.100.8:40000'), findsOneWidget);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: LocalPingView())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(currentAppLocalizations.start));
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxPingStart));
    expect(find.text('11.2 ms'), findsAtLeast(1));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const TestApp(child: HostScaffold(body: AgeToolView())),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(TonalButton, currentAppLocalizations.ageKeygen),
    );
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxAgeKeygen));
    expect(find.text('age1testpub'), findsAtLeast(1));
    await tester.tap(find.text(currentAppLocalizations.ageEncrypt).last);
    await tester.pumpAndSettle();
    expect(fake.invoked, contains(CoreMethod.toolboxAgeCrypt));
    expect(tester.takeException(), isNull);
  });
}
