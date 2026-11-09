import 'dart:convert';
import 'dart:io';

import 'package:fl_clash/common/proxy_chain.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _config() => {
  'proxies': [
    {
      'name': 'entry',
      'type': 'socks5',
      'server': 'entry.example',
      'port': 1080,
    },
    {
      'name': 'exit',
      'type': 'snell',
      'server': 'exit.example',
      'port': 443,
      'version': 6,
      'psk': 'test-password-for-snell',
    },
    {'name': 'last', 'type': 'http', 'server': 'last.example', 'port': 8080},
  ],
  'proxy-groups': [
    {
      'name': 'Smart',
      'type': 'smart',
      'proxies': ['entry'],
    },
    {
      'name': 'Select',
      'type': 'select',
      'proxies': ['Smart', 'exit'],
    },
  ],
};

void main() {
  test(
    'probe names resolve entry providers, intermediate paths and the full chain',
    () {
      const chain = ProxyChain(
        id: 'one',
        name: 'Route',
        hops: ['HK', 'US', 'JP'],
      );
      expect(proxyChainProbeName(chain, 0, {}), 'HK');
      expect(
        proxyChainProbeName(chain, 0, {'Route · 第1跳 · HK'}),
        'Route · 第1跳 · HK',
      );
      expect(proxyChainProbeName(chain, 1, {}), 'Route · 第2跳 · US');
      expect(
        proxyChainProbeName(chain, 1, {'Route · 第2跳 · US · 节点选择'}),
        'Route · 第2跳 · US · 节点选择',
      );
      expect(proxyChainProbeName(chain, 2, {}), 'Route');
      expect(
        proxyChainProbeName(
          chain.copyWith(hops: ['HK', 'DIRECT', 'JP']),
          1,
          {},
        ),
        'HK',
      );
    },
  );
  test('builds entry to exit with isolated copies and keeps Smart live', () {
    final config = _config();
    applyProxyChains(config, const [
      ProxyChain(
        id: 'one',
        name: 'My chain',
        hops: ['Smart', 'exit', 'last'],
        targetGroup: 'Select',
        hidden: true,
      ),
    ]);
    final proxies = config['proxies'] as List;
    expect(proxies, hasLength(5));
    expect(proxies[1].containsKey('dialer-proxy'), isFalse);
    expect(proxies[3]['dialer-proxy'], 'Smart');
    expect(proxies[3]['version'], 6);
    expect(proxies[4]['dialer-proxy'], 'My chain · 第2跳 · exit');
    final groups = config['proxy-groups'] as List;
    expect(groups[0]['type'], 'smart');
    expect(groups[1]['proxies'], ['Smart', 'exit', 'My chain']);
    expect(groups.last['proxies'], ['My chain · 第3跳 · last']);
    expect(groups.last['hidden'], true);
  });

  test('disabled chains add no definitions', () {
    final config = _config();
    applyProxyChains(config, const [
      ProxyChain(id: 'one', name: '', enabled: false),
    ]);
    expect(config, _config());
  });

  test('rejects unsafe chains atomically', () {
    for (final chain in const [
      ProxyChain(id: 'one', name: 'Select', hops: ['entry', 'exit']),
      ProxyChain(id: 'one', name: 'Chain', hops: ['entry']),
      ProxyChain(id: 'one', name: 'Chain', hops: ['entry', 'entry']),
      ProxyChain(id: 'one', name: 'Chain', hops: ['entry', 'gone']),
      ProxyChain(
        id: 'one',
        name: 'Chain',
        hops: ['Select', 'exit'],
        targetGroup: 'Select',
      ),
    ]) {
      final config = _config();
      expect(() => applyProxyChains(config, [chain]), throwsFormatException);
      expect(config, _config());
    }
  });

  test('supports group hops without changing the source groups or nodes', () {
    final config = _config();
    applyProxyChains(config, const [
      ProxyChain(id: 'groups', name: 'Groups', hops: ['Smart', 'Select']),
    ]);
    final groups = config['proxy-groups'] as List;
    final generated = groups.singleWhere((group) => group['name'] == 'Groups');
    expect(groups[1], (_config()['proxy-groups'] as List)[1]);
    expect(generated['proxies'], [
      'Groups · 第2跳 · Smart',
      'Groups · 第2跳 · exit',
    ]);
    expect(generated['hidden'], false);
    expect(
      groups.singleWhere(
        (group) => group['name'] == 'Groups · 第2跳 · Smart',
      )['hidden'],
      true,
    );
    expect(
      groups.where(
        (group) =>
            (group['name'] as String).startsWith('Groups') &&
            group['hidden'] != true,
      ),
      hasLength(1),
    );
    expect(
      (config['proxies'] as List).skip(3).map((node) => node['dialer-proxy']),
      everyElement('Smart'),
    );
  });

  test('keeps existing node dialers to groups and rejects actual loops', () {
    final config = _config();
    (config['proxies'] as List)[1]['dialer-proxy'] = 'Smart';
    applyProxyChains(config, const [
      ProxyChain(id: 'one', name: 'Chain', hops: ['entry', 'exit']),
    ]);
    expect((config['proxies'] as List)[1]['dialer-proxy'], 'Smart');
    expect((config['proxies'] as List).last['dialer-proxy'], 'entry');

    final cyclic = _config();
    (cyclic['proxies'] as List)[1]['dialer-proxy'] = 'Select';
    final before = jsonEncode(cyclic);
    expect(
      () => applyProxyChains(cyclic, const [
        ProxyChain(id: 'one', name: 'Chain', hops: ['entry', 'exit']),
      ]),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('cycle'),
        ),
      ),
    );
    expect(jsonEncode(cyclic), before);
  });

  test(
    'provider nodes stay dynamic and group copies keep their filters',
    () async {
      final config = _config()
        ..['proxy-providers'] = {
          'remote': {
            'type': 'inline',
            'payload': [
              {
                'name': 'HK',
                'type': 'socks5',
                'server': '127.0.0.1',
                'port': 1081,
              },
              {
                'name': 'US',
                'type': 'socks5',
                'server': '127.0.0.1',
                'port': 1082,
              },
            ],
            'override': {'additional-prefix': 'Sub · ', 'udp': true},
          },
        }
        ..['x-flsmart-provider-nodes'] = [
          {'name': 'Sub · HK', 'type': 'socks5', 'provider-name': 'remote'},
          {'name': 'Sub · US', 'type': 'socks5', 'provider-name': 'remote'},
        ];
      (config['proxy-groups'] as List).add({
        'name': 'Exit',
        'type': 'select',
        'use': ['remote'],
        'filter': '^Sub · HK',
      });
      final originalProvider = jsonEncode(config['proxy-providers']);
      applyProxyChains(config, const [
        ProxyChain(
          id: 'provider',
          name: 'Provider chain',
          hops: ['Sub · HK', 'Exit'],
        ),
        ProxyChain(id: 'node', name: 'Node chain', hops: ['entry', 'Sub · HK']),
        ProxyChain(
          id: 'groups',
          name: 'Group chain',
          hops: ['Smart', 'Select'],
        ),
      ]);
      final providers = config['proxy-providers'] as Map;
      expect(jsonEncode({'remote': providers['remote']}), originalProvider);
      expect(
        providers['flsmart-chain-provider-1-remote']['override']['dialer-proxy'],
        'Provider chain · 第1跳 · Sub · HK',
      );
      final groups = config['proxy-groups'] as List;
      final copiedGroup = groups.singleWhere(
        (group) => group['name'] == 'Provider chain',
      );
      expect(copiedGroup['use'], ['flsmart-chain-provider-1-remote']);
      expect(copiedGroup['filter'], contains('Provider chain'));
      expect(copiedGroup['hidden'], false);
      expect(
        groups.singleWhere(
          (group) => group['name'] == 'Provider chain · 第1跳 · Sub · HK',
        )['hidden'],
        true,
      );
      expect(
        groups.any(
          (group) => group['name'] == 'Node chain · 第2跳 · Sub · HK · 节点选择',
        ),
        false,
      );
      expect(
        groups.singleWhere((group) => group['name'] == 'Node chain')['use'],
        ['flsmart-chain-node-1-remote'],
      );
      final fixture = Platform.environment['FLSMART_CHAIN_FIXTURE'];
      if (fixture != null) {
        await File(fixture).writeAsString(
          jsonEncode({
            'config': config,
            'groups': {
              'Provider chain · 第1跳 · Sub · HK': ['Sub · HK'],
              'Provider chain': ['Provider chain · 第2跳 · Sub · HK'],
              'Node chain': ['Node chain · 第2跳 · Sub · HK'],
              'Group chain · 第2跳 · Smart': ['Group chain · 第2跳 · entry'],
              'Group chain': [
                'Group chain · 第2跳 · Smart',
                'Group chain · 第2跳 · exit',
              ],
            },
            'dialers': {
              'flsmart-chain-provider-1-remote':
                  'Provider chain · 第1跳 · Sub · HK',
              'flsmart-chain-node-1-remote': 'entry',
            },
          }),
        );
      }
    },
  );

  test('rejects provider cycles without modifying the original config', () {
    final config = _config()
      ..['proxy-providers'] = {
        'remote': {
          'type': 'inline',
          'payload': [],
          'override': {'dialer-proxy': 'Chain'},
        },
      };
    (config['proxy-groups'] as List)[0]['use'] = ['remote'];
    final original = jsonEncode(config);
    expect(
      () => applyProxyChains(config, const [
        ProxyChain(id: 'cycle', name: 'Chain', hops: ['Smart', 'exit']),
      ]),
      throwsFormatException,
    );
    expect(jsonEncode(config), original);
  });

  test('independent switches preserve legacy behavior and saved values', () {
    final original = Profile.normal();
    expect(original.rulesOverrideEnabled, true);
    expect(original.subscriptionOverrideEnabled, false);
    final scripted = original.copyWith(extendType: ExtendType.script);
    expect(scripted.rulesOverrideEnabled, false);
    expect(scripted.subscriptionOverrideEnabled, true);
    final both = scripted.copyWith(
      overrides: const ProfileOverrides(
        rulesEnabled: true,
        subscriptionEnabled: true,
      ),
    );
    expect(both.rulesOverrideEnabled && both.subscriptionOverrideEnabled, true);
    final restored = Profile.fromJson(
      jsonDecode(jsonEncode(both.toJson())) as Map<String, dynamic>,
    );
    expect(
      restored.rulesOverrideEnabled && restored.subscriptionOverrideEnabled,
      true,
    );
  });
}
