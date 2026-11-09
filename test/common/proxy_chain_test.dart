import 'dart:convert';

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
      'psk': 'test',
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
    expect(proxies[4]['dialer-proxy'], 'My chain · 2 · exit');
    final groups = config['proxy-groups'] as List;
    expect(groups[0]['type'], 'smart');
    expect(groups[1]['proxies'], ['Smart', 'exit', 'My chain']);
    expect(groups.last['proxies'], ['My chain · 3 · last']);
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
      ProxyChain(id: 'one', name: 'Chain', hops: ['entry', 'Smart']),
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
