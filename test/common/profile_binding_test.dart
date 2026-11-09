import 'dart:convert';

import 'package:fl_clash/common/profile_binding.dart';
import 'package:fl_clash/common/proxy_chain.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _base() => {
  'proxies': [
    {'name': 'original', 'type': 'socks5'},
  ],
  'proxy-groups': [
    {
      'name': 'Smart',
      'type': 'smart',
      'proxies': ['original'],
    },
    {
      'name': 'Select',
      'type': 'select',
      'proxies': ['Smart'],
    },
  ],
  'rules': ['MATCH,Select'],
};

Map<String, dynamic> _source() => {
  'proxies': [
    {'name': 'HK', 'type': 'socks5'},
    {'name': 'JP', 'type': 'snell', 'dialer-proxy': 'Entry'},
  ],
  'proxy-groups': [
    {
      'name': 'Entry',
      'type': 'select',
      'proxies': ['HK'],
    },
  ],
  'dns': {'enable': false},
  'rules': ['MATCH,REJECT'],
};

Map<String, dynamic> _build({
  Map<String, dynamic>? base,
  Map<String, dynamic>? source,
  List<SubscriptionBinding> subscriptions = const [],
  List<RuleSetBinding> rules = const [],
  Set<String> planned = const {},
}) => buildProfileBindings((
  config: base ?? _base(),
  subscriptions: subscriptions,
  sources: {2: source ?? _source()},
  rules: rules,
  ruleSources: {
    3: {
      'type': 'inline',
      'behavior': 'domain',
      'payload': ['example.com'],
    },
  },
), plannedPolicies: planned);

void main() {
  test(
    'one subscription can flatten into Smart and expose a sub-group in Select',
    () {
      final base = _base();
      final source = _source();
      final before = jsonEncode([base, source]);
      final result = _build(
        base: base,
        source: source,
        subscriptions: const [
          SubscriptionBinding(
            id: 's',
            sourceId: 2,
            name: 'Extra',
            attachments: [
              GroupAttachment(target: 'Smart'),
              GroupAttachment(
                target: 'Select',
                mode: SubscriptionAttachMode.group,
              ),
            ],
          ),
        ],
      );
      final groups = result['proxy-groups'] as List;
      expect(groups[0]['proxies'], ['original', 'Extra · HK', 'Extra · JP']);
      expect(groups[1]['proxies'], ['Smart', 'Extra']);
      expect((result['proxies'] as List).last['dialer-proxy'], 'Extra · Entry');
      expect(result['rules'], ['MATCH,Select']);
      expect(result.containsKey('dns'), false);
      expect(jsonEncode([base, source]), before);
    },
  );

  test('filters raw nodes before adding the source prefix', () {
    final result = _build(
      subscriptions: const [
        SubscriptionBinding(id: 's', sourceId: 2, name: 'Extra', filter: '^HK'),
      ],
    );
    expect((result['proxy-groups'] as List).last['proxies'], ['Extra · HK']);
    expect((result['proxies'] as List).length, 3);
  });

  test(
    'provider flattening retains source filters and adds the binding filter',
    () {
      final source = _source()
        ..['proxy-providers'] = {
          'remote': {
            'type': 'http',
            'url': 'https://example.com/sub',
            'filter': 'HK|JP',
            'exclude-filter': 'expired',
            'proxy': 'Entry',
          },
        };
      final result = _build(
        source: source,
        subscriptions: const [
          SubscriptionBinding(
            id: 's',
            sourceId: 2,
            name: 'Extra',
            filter: '^HK',
            attachments: [GroupAttachment(target: 'Smart')],
          ),
        ],
      );
      final provider =
          (result['proxy-providers'] as Map)['flsmart-s-remote-members'] as Map;
      expect(provider['filter'], 'HK|JP');
      expect(provider['exclude-filter'], startsWith('expired`'));
      expect(provider['exclude-filter'], contains('^HK'));
      expect(provider['proxy'], 'Extra · Entry');
      expect(provider['override']['additional-prefix'], 'Extra · ');
      expect((result['proxy-groups'] as List).first['use'], [
        'flsmart-s-remote',
      ]);
    },
  );

  test(
    'original include-all groups do not absorb unrelated attached nodes',
    () {
      final base = _base();
      (base['proxy-groups'] as List).first['include-all'] = true;
      final result = _build(
        base: base,
        subscriptions: const [
          SubscriptionBinding(id: 's', sourceId: 2, name: 'Extra'),
        ],
      );
      final smart = (result['proxy-groups'] as List).first as Map;
      expect(smart['include-all'], false);
      expect(smart['exclude-filter'], contains('Extra'));
      expect(smart['use'], isEmpty);
    },
  );

  test('rule sources can target a chain generated in the next stage', () {
    final result = _build(
      rules: const [RuleSetBinding(id: 'r', sourceId: 3, target: 'Chain')],
      planned: {'Chain'},
    );
    result['proxies'] = [
      ...result['proxies'] as List,
      {'name': 'exit', 'type': 'socks5'},
    ];
    applyProxyChains(result, const [
      ProxyChain(
        id: 'c',
        name: 'Chain',
        hops: ['original', 'exit'],
        targetGroups: ['Smart', 'Select'],
      ),
    ]);
    validatePolicyReferences(result);
    expect((result['rules'] as List).first, 'RULE-SET,flsmart-rule-r,Chain');
    expect((result['proxy-groups'] as List)[0]['proxies'], contains('Chain'));
    expect((result['proxy-groups'] as List)[1]['proxies'], contains('Chain'));
  });

  test(
    'missing, conflicting and cyclic bindings fail without mutating inputs',
    () {
      for (final binding in const [
        SubscriptionBinding(id: 's', sourceId: 99, name: 'Extra'),
        SubscriptionBinding(id: 's', sourceId: 2, name: 'Smart'),
        SubscriptionBinding(
          id: 's',
          sourceId: 2,
          name: 'Extra',
          filter: 'gone',
        ),
        SubscriptionBinding(
          id: 's',
          sourceId: 2,
          name: 'Extra',
          attachments: [GroupAttachment(target: 'gone')],
        ),
        SubscriptionBinding(
          id: 's',
          sourceId: 2,
          name: 'Extra',
          attachments: [
            GroupAttachment(
              target: 'Extra',
              mode: SubscriptionAttachMode.group,
            ),
          ],
        ),
      ]) {
        final base = _base();
        expect(
          () => _build(base: base, subscriptions: [binding]),
          throwsFormatException,
        );
        expect(base, _base());
      }
    },
  );

  test(
    'disabled bindings need no resources and serialization retains modes',
    () {
      const overrides = ProfileOverrides(
        subscriptions: [
          SubscriptionBinding(
            id: 's',
            sourceId: 99,
            name: 'Extra',
            enabled: false,
            groupType: GroupType.Smart,
            attachments: [
              GroupAttachment(
                target: 'Smart',
                mode: SubscriptionAttachMode.group,
              ),
            ],
          ),
        ],
        chains: [
          ProxyChain(id: 'c', name: 'Chain', targetGroups: ['Smart', 'Select']),
        ],
      );
      expect(_build(subscriptions: overrides.subscriptions), _base());
      final copy = ProfileOverrides.fromJson(
        jsonDecode(jsonEncode(overrides.toJson())) as Map<String, dynamic>,
      );
      expect(copy, overrides);
      expect(copy.chains.single.targets, {'Smart', 'Select'});
    },
  );

  test('a provider elsewhere cannot conceal an invalid explicit reference', () {
    final base = _base()
      ..['proxy-providers'] = {
        'unrelated': {'type': 'inline', 'payload': []},
      };
    (base['proxy-groups'] as List).first['proxies'] = ['gone'];
    expect(() => validatePolicyReferences(base), throwsFormatException);
  });
}
