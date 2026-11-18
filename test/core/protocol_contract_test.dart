import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/constant.dart';
import 'package:fl_clash/core/event.dart';
import 'package:fl_clash/core/desktop/model.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingCoreHandler extends CoreHandlerInterface {
  final Map<CoreMethod, Object?> calls = {};

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
    calls[method] = arguments;
    return switch (method) {
      CoreMethod.coreInitialized => true,
      CoreMethod.trafficCurrent ||
      CoreMethod.trafficTotal => {'up': 12, 'down': 34},
      CoreMethod.trafficNodes => [
        {'name': 'Tokyo', 'provider': 'subscription', 'up': 12, 'down': 34},
      ],
      CoreMethod.proxyTestDelay => {
        'name': 'DIRECT',
        'url': 'https://example.com',
        'value': 42,
      },
      CoreMethod.connectionList => {
        'connections': [
          {
            'id': 'connection-1',
            'metadata': {'network': 'tcp'},
            'upload': 0,
            'download': 0,
            'start': '2024-01-01',
            'chains': ['DIRECT'],
            'rule': 'DIRECT',
            'rulePayload': '',
          },
        ],
      },
      CoreMethod.providerList => [
        {
          'name': 'provider-1',
          'type': 'Proxy',
          'count': 1,
          'vehicle-type': 'HTTP',
          'update-at': '2024-01-01T00:00:00.000Z',
        },
      ],
      CoreMethod.providerGet => {
        'name': 'provider-1',
        'type': 'Proxy',
        'count': 1,
        'vehicle-type': 'HTTP',
        'update-at': '2024-01-01T00:00:00.000Z',
      },
      CoreMethod.configRead => {
        'mode': 'rule',
        'rule': ['MATCH,DIRECT'],
      },
      CoreMethod.profileOutbounds => {
        'proxies': [
          {'name': 'a', 'type': 'ss'},
        ],
        'proxy-groups': <Object>[],
      },
      CoreMethod.proxyDefinition
          when arguments is Map && arguments['name'] == 'a' =>
        {
          'name': 'a',
          'type': 'ss',
          'plugin-opts': {'mode': 'websocket'},
        },
      CoreMethod.profileBuild => '/home/responses/1.yaml',
      CoreMethod.profileBase => {
        'config': {'mode': 'rule', 'rule': null},
        'digest': 'abc',
        'match-rules': ['MATCH,DIRECT'],
        'proxies': 2,
        'proxy-groups': 1,
        'rules': 3,
      },
      CoreMethod.coreMemory => {
        'rss': 2048,
        'heap-inuse': 1024,
        'heap-idle': 256,
        'stack-inuse': 64,
        'runtime-other': 32,
      },
      CoreMethod.proxySelect => {'message': '', 'changed': true},
      CoreMethod.ruleSetCompile => {'behavior': 'ipcidr', 'format': 'text'},
      CoreMethod.ruleSetDump => '/home/responses/2.yaml',
      CoreMethod.configDecrypt => 'mode: rule',
      CoreMethod.connectionCount => 3,
      CoreMethod.proxyValidate || CoreMethod.filterValidate => [
        {'index': 1, 'message': 'missing closing )'},
      ],
      CoreMethod.mitmValidate => {
        'url-rewrite': [
          {'index': 1, 'message': 'unknown type "x"'},
        ],
      },
      CoreMethod.mitmCertificate => {
        'pem': '-----BEGIN CERTIFICATE-----',
        'fingerprint': 'AB:CD',
        'subject': 'FlClash CA 0000ABCD',
        'not-before': '2026-10-20T00:00:00Z',
        'not-after': '2036-10-22T00:00:00Z',
      },
      CoreMethod.mitmIssueCertificate => '-----BEGIN CERTIFICATE-----',
      CoreMethod.mitmExchanges => {
        'capturing': true,
        'since': '2026-10-28T00:00:00Z',
        'exchanges': [
          {
            'id': 7,
            'start': '2026-10-28T00:00:01Z',
            'pending': true,
            'duration': 12,
            'method': 'GET',
            'url': 'https://a.test/x',
            'status': 0,
            'request-size': 0,
            'response-size': 0,
          },
        ],
      },
      CoreMethod.routeWatch => {'core-epoch': 1, 'route-version': 0},
      CoreMethod.routeCheck => {
        'core-epoch': 1,
        'route-version': 3,
        'held': [true, false],
      },
      CoreMethod.profileMerge => {
        'proxies': 4,
        'duplicates': 1,
        'groups': 2,
        'providers': <Object>[],
      },
      CoreMethod.toolboxSpeedTestStart || CoreMethod.toolboxSpeedTestProbe => {
        'provider': 'cloudflare',
        'protocol': 'h1',
        'fallback': false,
        'exit-ip': '1.2.3.4',
        'streams': 8,
        'duration': 10,
        'phase': 'done',
        'progress': 1.0,
        'speed': 1000000.0,
        'direct': true,
        'latency': 12.5,
        'jitter': 1.2,
        'download': 50000000.0,
        'upload': 25000000.0,
        'download-latency': 20.0,
        'upload-latency': 25.0,
        'rpm': 120,
        'bytes': 1024,
        'error': '',
      },
      CoreMethod.toolboxSpeedTestServers => [
        {
          'host': 'speed.example.com:8080',
          'name': 'Tokyo',
          'cc': 'JP',
          'sponsor': 'Example ISP',
          'latency': 14.0,
        },
      ],
      CoreMethod.toolboxSpeedTestCancel ||
      CoreMethod.toolboxMrsCancel ||
      CoreMethod.toolboxStunCancel ||
      CoreMethod.toolboxPingCancel => true,
      CoreMethod.toolboxRouteTrace => {
        'target': 'example.com',
        'host': 'example.com',
        'network': 'tcp',
        'port': 443,
        'mode': 'rule',
        'total': 2,
        'checked': 1,
        'steps': [
          {
            'index': 0,
            'type': 'DomainSuffix',
            'payload': 'example.com',
            'adapter': 'Proxy',
            'matched': true,
          },
        ],
        'matched': {
          'index': 0,
          'type': 'DomainSuffix',
          'payload': 'example.com',
          'adapter': 'Proxy',
          'matched': true,
        },
        'chains': [
          {'name': 'Proxy', 'type': 'Selector'},
        ],
        'support-udp': true,
        'match-time': 0.5,
        'error': '',
      },
      CoreMethod.toolboxDnsQuery => {
        'domain': 'example.com',
        'type': 'A',
        'mode': 'follow',
        'rcode': 'NOERROR',
        'answers': [
          {
            'name': 'example.com',
            'type': 'A',
            'ttl': 60,
            'data': '93.184.216.34',
          },
        ],
        'elapsed': 8.2,
        'route': 'normal',
        'error': '',
      },
      CoreMethod.toolboxMrsPrepare => {
        'version': 'cached',
        'geosite': 3,
        'geoip': 2,
        'extracted': false,
        'elapsed': 4.1,
        'error': '',
      },
      CoreMethod.toolboxMrsLookup => {
        'target': 'example.com',
        'host': 'example.com',
        'ips': ['93.184.216.34'],
        'matches': [
          {
            'kind': 'geosite',
            'name': 'example',
            'file': 'ruleset/example.mrs',
            'count': 10,
            'via': 'example.com',
            'referenced': true,
          },
        ],
        'elapsed': 2.0,
        'error': '',
      },
      CoreMethod.toolboxMrsDump => '+.example.com\n',
      CoreMethod.toolboxStunStart => {
        'phase': 'done',
        'progress': 1.0,
        'server': 'stun.cloudflare.com:3478',
        'nat-type': 'full-cone',
        'mapping': 'independent',
        'filtering': 'independent',
        'rfc5780': true,
        'external-ip': '198.51.100.2',
        'external-port': 51820,
        'local-ip': '192.168.1.2',
        'local-port': 51820,
        'port-preserved': 1,
        'latency': 22.0,
        'jitter': 1.5,
        'packet-loss': 0.0,
        'error': '',
      },
      CoreMethod.toolboxPingStart => {
        'session': 1,
        'phase': 'done',
        'target': '1.1.1.1',
        'address': '1.1.1.1',
        'protocol': 'icmp',
        'count': 2,
        'interval': 1000,
        'sent': 2,
        'elapsed': 1.0,
        'replies': [
          {'seq': 1, 'status': 'ok', 'rtt': 10.5, 'ttl': 57, 'bytes': 32},
        ],
        'error': '',
      },
      CoreMethod.toolboxAgeKeygen => {
        'public-key': 'age1public',
        'secret-key': 'AGE-SECRET-KEY-1SECRET',
      },
      CoreMethod.toolboxAgeCrypt => {'data': 'cipher', 'error': ''},
      _ => null,
    };
  }
}

class _FailingConfigCoreHandler extends _RecordingCoreHandler {
  @override
  Future<Object?> invokeMethod({
    required CoreMethod method,
    Object? arguments,
    Duration? timeout,
  }) async {
    if (method == CoreMethod.configRead) {
      throw const CoreMethodException(
        code: 'core_error',
        message: 'config not found',
        details: {'path': '/missing.yaml'},
      );
    }
    return super.invokeMethod(
      method: method,
      arguments: arguments,
      timeout: timeout,
    );
  }
}

class _EmptyConfigCoreHandler extends _RecordingCoreHandler {
  @override
  Future<Object?> invokeMethod({
    required CoreMethod method,
    Object? arguments,
    Duration? timeout,
  }) async {
    if (method == CoreMethod.configRead) {
      return null;
    }
    return super.invokeMethod(
      method: method,
      arguments: arguments,
      timeout: timeout,
    );
  }
}

void main() {
  test('method call keeps structured arguments', () async {
    final fixture =
        json.decode(
              await File('test/fixtures/core_protocol.json').readAsString(),
            )
            as Map<String, dynamic>;
    final call = CoreMethodCall.fromJson(
      Map<String, Object?>.from(fixture['methodCall'] as Map),
    );

    expect(call.method, CoreMethod.configUpdate);
    expect(call.arguments, isA<Map<String, dynamic>>());
    expect((call.arguments as Map)['mixed-port'], 7890);
    expect(call.toJson(), containsPair('arguments', call.arguments));
    expect(call.toJson(), isNot(contains('data')));
  });

  test('the Dart and Go method tables name the same methods', () async {
    final protocol = await File('core/protocol.go').readAsString();
    final goNames = {
      for (final match in RegExp(
        r'^\s*\w+Method\s+CoreMethod\s*=\s*"([^"]+)"',
        multiLine: true,
      ).allMatches(protocol))
        match.group(1)!,
    };

    expect(goNames, isNotEmpty);
    expect({for (final method in CoreMethod.values) method.wireName}, goNames);
  });

  test(
    'decodes node traffic from the core without an HTTP controller',
    () async {
      final handler = _RecordingCoreHandler();
      final nodes = await handler.getNodeTraffic();
      expect(nodes.single.name, 'Tokyo');
      expect(nodes.single.provider, 'subscription');
      expect(nodes.single.total, 46);
      expect(handler.calls, contains(CoreMethod.trafficNodes));
    },
  );

  test('core interface sends structured request parameters', () async {
    final handler = _RecordingCoreHandler();

    await handler.init(const InitParams(homeDir: '/tmp/flclash', version: 35));
    await handler.setupConfig(
      const SetupParams(
        selectedMap: {'GLOBAL': 'DIRECT'},
        options: CoreOptions(testUrl: 'test'),
      ),
    );
    final switched = await handler.changeProxy(
      const ChangeProxyParams(groupName: 'GLOBAL', proxyName: 'DIRECT'),
    );
    expect(switched, const ChangeProxyResult(changed: true));
    final route = await handler.watchRoute(true);
    expect(route, const RouteSnapshot(coreEpoch: 1));
    final check = await handler.checkRoutes(
      const CheckRoutesParams(
        routes: [
          [RouteHit(host: 'example.com:443', proxy: 'DIRECT', exit: 'x')],
          [],
        ],
      ),
    );
    expect(
      check,
      const RouteCheck(coreEpoch: 1, routeVersion: 3, held: [true, false]),
    );
    await handler.sideLoadExternalProvider(providerName: 'provider', data: 'x');
    await handler.testDelay(
      const TestDelayParams(
        proxyName: 'DIRECT',
        testUrl: 'https://example.com',
        timeout: 8000,
      ),
    );
    await handler.clearEffect(42);
    await handler.getTraffic(true);
    await handler.closeConnection('connection-1');
    await handler.updateGeoData('GeoIp');

    for (final method in CoreMethod.values) {
      if (handler.calls[method] case final Object arguments) {
        expect(arguments, isA<Map>(), reason: method.wireName);
      }
    }
    expect(handler.calls[CoreMethod.coreInit], {
      'home-dir': '/tmp/flclash',
      'version': 35,
    });
    expect(json.decode(json.encode(handler.calls[CoreMethod.configSetup])), {
      'selected-map': {'GLOBAL': 'DIRECT'},
      'options': {
        'test-url': 'test',
        'skip-cert-verify': false,
        'delay-test-timeout': defaultDelayTestTimeout,
        'mitm-capture': false,
      },
    });
    expect(handler.calls[CoreMethod.routeWatch], {'watch': true});
    expect(json.decode(json.encode(handler.calls[CoreMethod.routeCheck])), {
      'routes': [
        [
          {'host': 'example.com:443', 'proxy': 'DIRECT', 'exit': 'x'},
        ],
        <Object?>[],
      ],
    });
    expect(handler.calls[CoreMethod.providerSideLoad], {
      'name': 'provider',
      'data': 'x',
    });
    expect(handler.calls[CoreMethod.proxyTestDelay], {
      'proxy-name': 'DIRECT',
      'test-url': 'https://example.com',
      'timeout': 8000,
    });
    expect(handler.calls[CoreMethod.profileClearEffect], {'profile-id': 42});
    expect(handler.calls[CoreMethod.trafficCurrent], {'only-proxy': true});
    expect(handler.calls[CoreMethod.connectionClose], {'id': 'connection-1'});
    expect(handler.calls[CoreMethod.geoUpdate], {'type': 'GeoIp'});
  });

  test('a list validation reads only the entries the Core refuses', () async {
    final handler = _RecordingCoreHandler();

    final filters = await handler.validateFilters(['hk`jp', '(hk']);
    final proxies = await handler.validateProxies([
      {'name': 'a'},
      {'name': 'b'},
    ]);

    expect(handler.calls[CoreMethod.filterValidate], {
      'filters': ['hk`jp', '(hk'],
    });
    expect(filters, {1: 'missing closing )'});
    expect(proxies, {1: 'missing closing )'});
  });

  test('validateMitm sends the section and reads issues by list', () async {
    final handler = _RecordingCoreHandler();
    const rules = MitmRules(urlRewrite: ['^a _ reject', '^b c x']);

    final issues = await handler.validateMitm(rules);

    expect(handler.calls[CoreMethod.mitmValidate], rules.toJson());
    expect(issues, {
      MitmList.urlRewrite: {1: 'unknown type "x"'},
    });
  });

  test('captured requests are listed by connection and read by id', () async {
    final handler = _RecordingCoreHandler();

    final list = await handler.getMitmExchanges('connection-1');
    final cleared = await handler.getMitmExchange(7);

    expect(handler.calls[CoreMethod.mitmExchanges], {'id': 'connection-1'});
    expect(handler.calls[CoreMethod.mitmExchange], {'id': 7});
    expect(list.capturing, isTrue);
    expect(list.since, DateTime.utc(2026, 10, 28));
    expect(list.exchanges.single.pending, isTrue);
    expect(cleared, isNull);
  });

  test('the MITM certificate is read, and a missing answer fails', () async {
    final handler = _RecordingCoreHandler();

    final certificate = await handler.getMitmCertificate();

    expect(certificate?.subject, 'FlClash CA 0000ABCD');
    expect(certificate?.notAfter, DateTime.utc(2036, 10, 22));
    await expectLater(
      handler.generateMitmCertificate(),
      throwsA(
        isA<CoreMethodException>().having(
          (error) => error.code,
          'code',
          'empty_result',
        ),
      ),
    );
  });

  test('a check leaf is signed for the host it names', () async {
    final handler = _RecordingCoreHandler();

    final pem = await handler.issueMitmCertificate('check.invalid');

    expect(pem, '-----BEGIN CERTIFICATE-----');
    expect(handler.calls[CoreMethod.mitmIssueCertificate], {
      'host': 'check.invalid',
    });
  });

  test('a command answers nothing and a query answers its result', () async {
    final handler = _RecordingCoreHandler();

    await handler.forceGc();
    await handler.closeConnections();

    expect(await handler.isInit, isTrue);
    expect(await handler.validateConfig('/config.yaml'), isNull);
    expect(handler.calls[CoreMethod.configValidate], {'path': '/config.yaml'});
  });

  test('dumpRuleSet sends the rule set path', () async {
    final handler = _RecordingCoreHandler();

    expect(await handler.dumpRuleSet('/rules.mrs'), '/home/responses/2.yaml');

    expect(handler.calls[CoreMethod.ruleSetDump], {'path': '/rules.mrs'});
  });

  test('decryptConfig sends the path and the age key', () async {
    final handler = _RecordingCoreHandler();

    await handler.decryptConfig('/profile.yaml', 'AGE-SECRET-KEY-1A');

    expect(handler.calls[CoreMethod.configDecrypt], {
      'path': '/profile.yaml',
      'age-secret-key': 'AGE-SECRET-KEY-1A',
    });
  });

  test(
    'compileRuleSet names a cached file and reads what the Core found',
    () async {
      final handler = _RecordingCoreHandler();

      final info = await handler.compileRuleSet(
        'abc',
        url: 'https://example.com/r.list',
      );

      expect(handler.calls[CoreMethod.ruleSetCompile], {
        'name': 'abc',
        'url': 'https://example.com/r.list',
      });
      expect(info, (
        behavior: RuleProviderBehavior.ipcidr,
        format: RuleProviderFormat.text,
      ));
    },
  );

  test('event contract accepts batches and legacy single events', () async {
    final fixture =
        json.decode(
              await File('test/fixtures/core_protocol.json').readAsString(),
            )
            as Map<String, dynamic>;
    final call = CoreMethodCall.fromJson(
      Map<String, Object?>.from(fixture['eventCall'] as Map),
    );

    final events = coreEventsFromData(call.arguments);
    expect(events, hasLength(2));
    expect(events.first.type, CoreEventType.loaded);
    expect(events.last.type, CoreEventType.delay);

    final legacy = coreEventsFromData({'type': 'loaded', 'data': 'provider-b'});
    expect(legacy.single.data, 'provider-b');
  });

  test('event contract decodes the dns query the Core sends', () {
    final events = coreEventsFromData([
      {
        'type': 'dns',
        'data': {
          'domain': 'www.example.com',
          'type': 'A',
          'initiator': 'app',
          'answers': ['93.184.216.34'],
          'rcode': 'NOERROR',
          'delay': 0,
          'time': '2026-09-18T12:30:01.123456789+08:00',
        },
      },
      {
        'type': 'dns',
        'data': {
          'domain': 'missing.test',
          'type': 'AAAA',
          'initiator': 'unknown-initiator',
          'upstream': 'tls://1.1.1.1:853',
          'cached': true,
          'answers': <String>[],
          'error': 'i/o timeout',
          'delay': 5000,
          'time': '2026-09-18T04:30:02Z',
        },
      },
    ]);

    expect(events.map((event) => event.type), [
      CoreEventType.dns,
      CoreEventType.dns,
    ]);
    final queries = [
      for (final event in events)
        DnsQuery.fromJson(Map<String, Object?>.from(event.data as Map)),
    ];
    expect(queries.first.initiator, DnsQueryInitiator.app);
    expect(queries.first.upstream, isEmpty);
    expect(queries.first.cached, isFalse);
    expect(queries.first.answers, ['93.184.216.34']);
    expect(
      queries.first.time.toUtc(),
      DateTime.utc(2026, 9, 18, 4, 30, 1, 123, 456),
    );
    expect(queries.first.isFailed, isFalse);
    expect(queries.last.initiator, isNull);
    expect(queries.last.upstream, 'tls://1.1.1.1:853');
    expect(queries.last.cached, isTrue);
    expect(queries.last.rcode, isEmpty);
    expect(queries.last.isFailed, isTrue);
  });

  test('event contract skips malformed entries without dropping the batch', () {
    final events = coreEventsFromData([
      {'type': 'loaded', 'data': 'provider-a'},
      {'type': 'invalid-event', 'data': null},
      {'type': 'loaded', 'data': 'provider-b'},
    ]);

    expect(events.map((event) => event.data), ['provider-a', 'provider-b']);
  });

  test('core interface converts structured method results', () async {
    final handler = _RecordingCoreHandler();

    expect(await handler.getTraffic(false), const Traffic(up: 12, down: 34));
    expect(
      await handler.getTotalTraffic(false),
      const Traffic(up: 12, down: 34),
    );
    expect(
      await handler.testDelay(
        const TestDelayParams(
          proxyName: 'DIRECT',
          testUrl: 'https://example.com',
          timeout: 8000,
        ),
      ),
      const Delay(name: 'DIRECT', url: 'https://example.com', value: 42),
    );
    expect((await handler.getConnections()).single.id, 'connection-1');
    expect(await handler.getConnectionCount(), 3);
    expect((await handler.getExternalProviders()).single.name, 'provider-1');
    expect(
      (await handler.getExternalProvider('provider-1'))?.name,
      'provider-1',
    );
    expect(await handler.readConfig('/config.yaml'), {
      'mode': 'rule',
      'rule': ['MATCH,DIRECT'],
    });
    final memory = await handler.getMemoryStats();
    expect(memory.rss, 2048);
    expect(memory.runtimeTotal, 1024 + 256 + 64 + 32);
  });

  test('getProfileBase sends the path and reads what the Core kept', () async {
    final handler = _RecordingCoreHandler();

    final base = await handler.getProfileBase('/profiles/1.yaml');

    expect(handler.calls[CoreMethod.profileBase], {'path': '/profiles/1.yaml'});
    expect(
      base,
      const ProfileBase(
        config: {'mode': 'rule', 'rule': null},
        digest: 'abc',
        matchRules: ['MATCH,DIRECT'],
        proxies: 2,
        proxyGroups: 1,
        rules: 3,
      ),
    );
  });

  test('the outbounds and the built profile cross as plain JSON', () async {
    final handler = _RecordingCoreHandler();
    const base = SetupBase(path: '/profiles/1.yaml', overlay: 'mode: rule');

    final outbounds = await handler.getProfileOutbounds('/profiles/1.yaml');
    final built = await handler.buildProfile(base);

    expect(handler.calls[CoreMethod.profileOutbounds], {
      'path': '/profiles/1.yaml',
    });
    expect(outbounds['proxies'], [
      {'name': 'a', 'type': 'ss'},
    ]);
    expect(handler.calls[CoreMethod.profileBuild], base.toJson());
    expect(built, '/home/responses/1.yaml');
  });

  test('a proxy definition crosses as a nested mapping or null', () async {
    final handler = _RecordingCoreHandler();

    final definition = await handler.getProxyDefinition('a');
    final missing = await handler.getProxyDefinition('from-provider');

    expect(handler.calls[CoreMethod.proxyDefinition], {
      'name': 'from-provider',
    });
    expect(definition, {
      'name': 'a',
      'type': 'ss',
      'plugin-opts': {'mode': 'websocket'},
    });
    expect(missing, isNull);
  });

  test('setupConfig names a base only when the Core applies one', () async {
    final handler = _RecordingCoreHandler();
    const params = SetupParams(
      selectedMap: {},
      options: CoreOptions(testUrl: 'test'),
    );
    Object? sent() =>
        json.decode(json.encode(handler.calls[CoreMethod.configSetup]));

    await handler.setupConfig(params);
    expect(sent(), isNot(contains('base')));

    await handler.setupConfig(
      params.copyWith(
        base: const SetupBase(path: '/profiles/1.yaml', overlay: 'mode: rule'),
      ),
    );
    expect((sent()! as Map)['base'], {
      'path': '/profiles/1.yaml',
      'overlay': 'mode: rule',
    });
  });

  test('readConfig preserves structured core errors', () async {
    final handler = _FailingConfigCoreHandler();

    await expectLater(
      handler.readConfig('/missing.yaml'),
      throwsA(
        isA<CoreMethodException>()
            .having((error) => error.code, 'code', 'core_error')
            .having((error) => error.details, 'details', {
              'path': '/missing.yaml',
            }),
      ),
    );
  });

  test('readConfig rejects empty transport results', () async {
    final handler = _EmptyConfigCoreHandler();

    await expectLater(
      handler.readConfig('/config.yaml'),
      throwsA(
        isA<CoreMethodException>().having(
          (error) => error.code,
          'code',
          'empty_result',
        ),
      ),
    );
  });

  test('method response separates result and structured errors', () async {
    final fixture =
        json.decode(
              await File('test/fixtures/core_protocol.json').readAsString(),
            )
            as Map<String, dynamic>;
    final success = CoreMethodResponse.fromJson(
      Map<String, Object?>.from(fixture['successResponse'] as Map),
    );
    final structured = CoreMethodResponse.fromJson(
      Map<String, Object?>.from(fixture['structuredResponse'] as Map),
    );
    final failure = CoreMethodResponse.fromJson(
      Map<String, Object?>.from(fixture['errorResponse'] as Map),
    );
    final spilled = CoreMethodResponse.fromJson(
      Map<String, Object?>.from(fixture['spilledResponse'] as Map),
    );

    expect(success.unwrap<Object?>(), isNull);
    expect(success.toJson(), containsPair('result', null));
    expect(structured.result, isA<Map>());
    expect(structured.result, isNot(isA<String>()));
    expect(structured.unwrap<Map<String, dynamic>>()?['up'], 12);
    expect(
      () => failure.unwrap<Object?>(),
      throwsA(
        isA<CoreMethodException>()
            .having((error) => error.code, 'code', 'core_error')
            .having((error) => error.message, 'message', 'config not found'),
      ),
    );
    expect(failure.toJson(), contains('error'));
    expect(failure.toJson(), isNot(contains('code')));
    expect(failure.file, isNull);
    expect(failure.toJson(), isNot(contains('file')));
    expect(spilled.file, '/home/responses/1234.json');
    expect(spilled.toJson(), containsPair('file', '/home/responses/1234.json'));
  });

  test('profileMerge and all toolbox RPCs send structured arguments', () async {
    final handler = _RecordingCoreHandler();

    final report = await handler.mergeProfiles(
      const MergeProfilesParams(
        output: '/tmp/out.yaml',
        members: [
          MergeMemberParams(prefix: 'A', path: '/tmp/a.yaml'),
          MergeMemberParams(prefix: 'B', path: '/tmp/b.yaml'),
        ],
      ),
    );
    expect(report.proxies, 4);
    expect(report.duplicates, 1);

    final speed = await handler.startSpeedTest(const SpeedTestParams());
    expect(speed.download, 50000000.0);
    await handler.probeSpeedTest(const SpeedTestParams());
    final servers = await handler.getSpeedTestServers(
      const SpeedTestServersParams(search: 'Tokyo'),
    );
    expect(servers.single.name, 'Tokyo');
    expect(await handler.cancelSpeedTest(), isTrue);

    final trace = await handler.routeTrace(
      const RouteTraceParams(target: 'example.com'),
    );
    expect(trace.matched?.adapter, 'Proxy');

    final dnsRes = await handler.queryDns(
      const DnsQueryParams(domain: 'example.com'),
    );
    expect(dnsRes.answers.single.data, '93.184.216.34');

    final prep = await handler.prepareMrs();
    expect(prep.geosite, 3);
    final lookup = await handler.lookupMrs(
      const MrsLookupParams(target: 'example.com'),
    );
    expect(lookup.matches.single.referenced, isTrue);
    expect(await handler.dumpMrs('ruleset/example.mrs'), '+.example.com\n');
    expect(await handler.cancelMrsLookup(), isTrue);

    final stun = await handler.startStunTest(const StunTestParams());
    expect(stun.natType, 'full-cone');
    expect(stun.rfc5780, isTrue);
    expect(await handler.cancelStunTest(), isTrue);

    final ping = await handler.startLocalPing(
      const LocalPingParams(target: '1.1.1.1'),
    );
    expect(ping.replies.single.status, 'ok');
    expect(await handler.cancelLocalPing(), isTrue);

    final pair = await handler.generateAgeKeyPair(hybrid: true);
    expect(pair.publicKey, 'age1public');
    expect(handler.calls[CoreMethod.toolboxAgeKeygen], {'hybrid': true});

    final crypt = await handler.cryptAge(
      const AgeCryptParams(
        mode: 'encrypt',
        data: 'hello',
        keys: ['age1public'],
      ),
    );
    expect(crypt.data, 'cipher');

    for (final method in CoreMethod.values) {
      if (handler.calls[method] case final Object arguments) {
        expect(arguments, isA<Map>(), reason: method.wireName);
      }
    }
  });

  test('dispatches speedTest, stunTest and localPing core events', () async {
    SpeedTestState? gotSpeed;
    StunTestState? gotStun;
    LocalPingState? gotPing;
    final listener = _ToolboxEventListener(
      onSpeed: (value) => gotSpeed = value,
      onStun: (value) => gotStun = value,
      onPing: (value) => gotPing = value,
    );
    coreEventManager.addListener(listener);
    addTearDown(() => coreEventManager.removeListener(listener));

    coreEventManager.sendEvent(
      const CoreEvent(
        type: CoreEventType.speedTest,
        data: {'phase': 'download', 'download': 1234.0},
      ),
    );
    coreEventManager.sendEvent(
      const CoreEvent(
        type: CoreEventType.stunTest,
        data: {'phase': 'done', 'nat-type': 'open', 'rfc5780': true},
      ),
    );
    coreEventManager.sendEvent(
      const CoreEvent(
        type: CoreEventType.localPing,
        data: {
          'phase': 'running',
          'reply': {'seq': 1, 'status': 'ok', 'rtt': 5.0},
        },
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(gotSpeed?.phase, 'download');
    expect(gotStun?.natType, 'open');
    expect(gotStun?.rfc5780, isTrue);
    expect(gotPing?.reply?.seq, 1);
  });
}

class _ToolboxEventListener with CoreEventListener {
  _ToolboxEventListener({
    required this.onSpeed,
    required this.onStun,
    required this.onPing,
  });

  final void Function(SpeedTestState) onSpeed;
  final void Function(StunTestState) onStun;
  final void Function(LocalPingState) onPing;

  @override
  void onSpeedTest(SpeedTestState state) => onSpeed(state);

  @override
  void onStunTest(StunTestState state) => onStun(state);

  @override
  void onLocalPing(LocalPingState state) => onPing(state);
}
