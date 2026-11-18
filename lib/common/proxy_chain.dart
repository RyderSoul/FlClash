import 'dart:convert';

import 'package:fl_clash/models/proxy_chain.dart';

List<Map<String, dynamic>> _mappings(Object? value) => [
  for (final item in value as List? ?? const [])
    Map<String, dynamic>.from(item as Map),
];

Map<String, Map<String, dynamic>> _providers(Object? value) => {
  for (final entry in (value as Map? ?? const {}).entries)
    entry.key as String: Map<String, dynamic>.from(entry.value as Map),
};

final _prefixStart = RegExp(r'[\p{L}\p{N}]', unicode: true);
final _prefixPattern = RegExp(
  r'^(?:\p{Script=Han}{1,2}|(?:(?!\p{Script=Han})[\p{L}\p{N}])+)',
  unicode: true,
);

String bundlePrefixOf(String label) {
  final text = label.trim();
  final start = text.indexOf(_prefixStart);
  if (start < 0) return text;
  return _prefixPattern.firstMatch(text.substring(start))?.group(0) ?? text;
}

const attachableGroupTypes = {
  'select',
  'url-test',
  'fallback',
  'load-balance',
  'smart',
};

RegExp subscriptionNodeFilter(String pattern) {
  final flags = RegExp(r'^\(\?([ims]+)\)').firstMatch(pattern);
  final options = flags?.group(1) ?? '';
  return RegExp(
    flags == null ? pattern : pattern.substring(flags.end),
    caseSensitive: !options.contains('i'),
    multiLine: options.contains('m'),
    dotAll: options.contains('s'),
  );
}

String namespacedProxyFilter(
  String pattern,
  String prefix, {
  bool exclude = false,
}) {
  final escaped = RegExp.escape(prefix).replaceAll('`', r'\x60');
  return pattern
      .split('`')
      .map((part) {
        final value = StringBuffer();
        var inClass = false;
        for (var index = 0; index < part.length; index++) {
          final char = part[index];
          if (char == r'\' && index + 1 < part.length) {
            final next = part[++index];
            value.write(
              !inClass && next == 'A' ? '(?<=\\A$escaped)' : '\\$next',
            );
          } else if (char == '^' && !inClass) {
            value.write('(?:^|(?<=\\A$escaped))');
          } else {
            if (char == '[') inClass = true;
            if (char == ']') inClass = false;
            value.write(char);
          }
        }
        final prefixed = '\\A$escaped[\\s\\S]*?(?:$value)';
        return exclude
            ? '(?:$prefixed)|(?:\\A(?!$escaped)[\\s\\S]*?(?:$part))'
            : prefixed;
      })
      .join('`');
}

String proxyChainHopPrefix(ProxyChain chain, int index) =>
    '${chain.name} · 第${index + 1}跳 · ';

String proxyChainProbeName(
  ProxyChain chain,
  int index,
  Set<String> outboundNames, {
  Set<String> passthrough = const {'DIRECT', 'COMPATIBLE'},
}) {
  if (index == chain.hops.length - 1) return chain.name;
  if (index > 0 && passthrough.contains(chain.hops[index])) {
    return proxyChainProbeName(
      chain,
      index - 1,
      outboundNames,
      passthrough: passthrough,
    );
  }
  final generated = '${proxyChainHopPrefix(chain, index)}${chain.hops[index]}';
  if (index == 0) {
    return outboundNames.contains(generated) ? generated : chain.hops[index];
  }
  final selector = '$generated · 节点选择';
  return outboundNames.contains(selector) ? selector : generated;
}

void applyProxyChains(Map<String, dynamic> config, List<ProxyChain> chains) {
  final active = chains.where((chain) => chain.enabled).toList();
  if (active.isEmpty) return;
  final working = jsonDecode(jsonEncode(config)) as Map<String, dynamic>;
  final proxies = [
    for (final proxy in working['proxies'] as List? ?? const [])
      Map<String, dynamic>.from(proxy as Map),
  ];
  final groups = [
    for (final group in working['proxy-groups'] as List? ?? const [])
      Map<String, dynamic>.from(group as Map),
  ];
  final providers = {
    for (final entry
        in (working['proxy-providers'] as Map? ?? const {}).entries)
      entry.key as String: Map<String, dynamic>.from(entry.value as Map),
  };
  final originalProviders = providers.keys.toList();
  final nodes = {for (final proxy in proxies) proxy['name'] as String: proxy};
  final policies = {
    for (final group in groups)
      group['name'] as String: Map<String, dynamic>.from(group),
  };
  final provided = {
    for (final proxy
        in working['x-flsmart-provider-nodes'] as List? ?? const [])
      if (proxy is Map &&
          proxy['name'] is String &&
          proxy['provider-name'] is String)
        proxy['name'] as String: proxy['provider-name'] as String,
  };
  final names = {
    'DIRECT',
    'REJECT',
    'REJECT-DROP',
    'PASS',
    'COMPATIBLE',
    'GLOBAL',
    ...nodes.keys,
    ...policies.keys,
    ...provided.keys,
  };
  final generatedNodes = <String>[];
  final attachments = <({String chain, String target})>[];
  String reserve(String name) {
    if (!names.add(name)) {
      throw FormatException('Proxy chain generated name conflicts: $name');
    }
    return name;
  }

  for (final chain in active) {
    if (chain.name.trim().isEmpty || !names.add(chain.name)) {
      throw FormatException(
        'Proxy chain name is empty or already exists: ${chain.name}',
      );
    }
    if (chain.hops.length < 2 ||
        chain.hops.length > 8 ||
        chain.hops.toSet().length != chain.hops.length) {
      throw FormatException(
        'Proxy chain must contain 2–8 different hops: ${chain.name}',
      );
    }
    var previous = chain.hops.first;
    if (!nodes.containsKey(previous) && !policies.containsKey(previous)) {
      final source = provided[previous];
      if (source == null || !providers.containsKey(source)) {
        throw FormatException('Proxy chain entry no longer exists: $previous');
      }
      final name = reserve('${proxyChainHopPrefix(chain, 0)}$previous');
      groups.add({
        'name': name,
        'type': 'select',
        'use': [source],
        'filter': '\\A${RegExp.escape(previous).replaceAll('`', r'\x60')}\\z',
        'empty-fallback': 'REJECT',
        'hidden': true,
      });
      previous = name;
    }
    for (var index = 1; index < chain.hops.length; index++) {
      final prefix = proxyChainHopPrefix(chain, index);
      final cloned = <String, String>{};
      final clonedProviders = <String, String>{};
      final visiting = <String>{};
      String cloneProvider(String key) {
        final existing = clonedProviders[key];
        if (existing != null) return existing;
        final definition = providers[key];
        if (definition == null) {
          throw FormatException('Proxy chain provider is missing: $key');
        }
        final name = 'flsmart-chain-${chain.id}-$index-$key';
        if (providers.containsKey(name)) {
          throw FormatException('Proxy chain provider name conflicts: $name');
        }
        final options = Map<String, dynamic>.from(
          definition['override'] as Map? ?? const {},
        );
        providers[name] = {
          ...definition,
          'override': {
            ...options,
            'dialer-proxy': previous,
            'override-expr': [
              ...options['override-expr'] as List? ?? const [],
              '.name = ${jsonEncode(prefix)} + .name',
              '."dialer-proxy" = ${jsonEncode(previous)}',
            ],
          },
        };
        clonedProviders[key] = name;
        return name;
      }

      String cloneHop(String hop) {
        if (hop == 'DIRECT' ||
            hop == 'COMPATIBLE' ||
            nodes[hop]?['type'] == 'direct') {
          return previous;
        }
        if (visiting.contains(hop)) {
          throw FormatException('Proxy chain group creates a cycle: $hop');
        }
        final existing = cloned[hop];
        if (existing != null) return existing;
        final root =
            index == chain.hops.length - 1 &&
            hop == chain.hops[index] &&
            !nodes.containsKey(hop);
        final name = root
            ? chain.name
            : reserve(
                provided.containsKey(hop) && !nodes.containsKey(hop)
                    ? '$prefix$hop · 节点选择'
                    : '$prefix$hop',
              );
        cloned[hop] = name;
        final definition = nodes[hop];
        if (definition != null) {
          proxies.add({...definition, 'name': name, 'dialer-proxy': previous});
          generatedNodes.add(name);
          return name;
        }
        final group = policies[hop];
        if (group != null) {
          visiting.add(hop);
          final all = group['include-all'] == true;
          final memberNames = <String>{
            ...List<String>.from(group['proxies'] as List? ?? const []),
            if (all || group['include-all-proxies'] == true)
              for (final node in nodes.keys)
                if (group['filter'] is! String ||
                    (group['filter'] as String).isEmpty ||
                    (group['filter'] as String)
                        .split('`')
                        .map(subscriptionNodeFilter)
                        .any((filter) => filter.hasMatch(node)))
                  node,
          };
          final use = <String>{
            ...List<String>.from(group['use'] as List? ?? const []),
            if (all || group['include-all-providers'] == true)
              ...originalProviders,
          };
          final members = [
            for (final member in memberNames)
              if (member == 'REJECT' ||
                  member == 'REJECT-DROP' ||
                  member == 'PASS')
                member
              else
                cloneHop(member),
          ];
          groups.add({
            ...group,
            'name': name,
            'hidden': root ? chain.hidden : true,
            'proxies': members,
            'use': [for (final key in use) cloneProvider(key)],
            'include-all': false,
            'include-all-proxies': false,
            'include-all-providers': false,
            for (final key in ['filter', 'exclude-filter'])
              if (group[key] case final String value when value.isNotEmpty)
                key: namespacedProxyFilter(
                  value,
                  prefix,
                  exclude: key == 'exclude-filter',
                ),
            if (group['default-selected'] is String)
              'default-selected':
                  cloned[group['default-selected']] ??
                  group['default-selected'],
            if (group['empty-fallback'] is String &&
                nodes.containsKey(group['empty-fallback']))
              'empty-fallback': cloneHop(group['empty-fallback'] as String)
            else
              'empty-fallback': 'REJECT',
            if (group['use-position'] is Map)
              'use-position': {
                for (final entry in (group['use-position'] as Map).entries)
                  clonedProviders[entry.key] ?? entry.key: entry.value,
              },
          });
          visiting.remove(hop);
          return name;
        }
        final source = provided[hop];
        if (source == null) {
          throw FormatException('Proxy chain hop is missing: $hop');
        }
        groups.add({
          'name': name,
          'type': 'select',
          'use': [cloneProvider(source)],
          'filter':
              '\\A${RegExp.escape('$prefix$hop').replaceAll('`', r'\x60')}\\z',
          'empty-fallback': 'REJECT',
          'hidden': root ? chain.hidden : true,
        });
        return name;
      }

      previous = cloneHop(chain.hops[index]);
    }
    if (previous != chain.name) {
      groups.add({
        'name': chain.name,
        'type': 'select',
        'proxies': [previous],
        'hidden': chain.hidden,
      });
    }
    for (final target in chain.targets) {
      attachments.add((chain: chain.name, target: target));
    }
  }
  for (final attachment in attachments) {
    final group = groups
        .where((group) => group['name'] == attachment.target)
        .firstOrNull;
    if (group == null || !attachableGroupTypes.contains(group['type'])) {
      throw FormatException(
        'Proxy chain target missing or incompatible: ${attachment.target}',
      );
    }
    group['proxies'] = {
      ...group['proxies'] as List? ?? const [],
      attachment.chain,
    }.toList();
  }
  final generatedFilter =
      '^(?:${generatedNodes.map(RegExp.escape).join('|')})\$'.replaceAll(
        '`',
        r'\x60',
      );
  for (final group in groups) {
    final all = group['include-all'] == true;
    if (all || group['include-all-providers'] == true) {
      group['use'] = {
        ...group['use'] as List? ?? const [],
        ...originalProviders,
      }.toList();
      group['include-all'] = false;
      group['include-all-providers'] = false;
      if (all) group['include-all-proxies'] = true;
    }
    if (generatedNodes.isNotEmpty && group['include-all-proxies'] == true) {
      final exclude = group['exclude-filter'];
      group['exclude-filter'] = exclude is String && exclude.isNotEmpty
          ? '$exclude`$generatedFilter'
          : generatedFilter;
    }
  }
  working['proxies'] = proxies;
  working['proxy-groups'] = groups;
  working['proxy-providers'] = providers;
  validatePolicyReferences(working);
  config.addAll(working);
}

void validatePolicyReferences(
  Map<String, dynamic> config, {
  Set<String> allowedPolicies = const {},
}) {
  final proxies = _mappings(config['proxies']);
  final groups = _mappings(config['proxy-groups']);
  final providers = _providers(config['proxy-providers']);
  final names = {
    'DIRECT',
    'REJECT',
    'REJECT-DROP',
    'PASS',
    'COMPATIBLE',
    'GLOBAL',
    ...allowedPolicies,
    ...proxies.map((p) => p['name'] as String),
    ...groups.map((g) => g['name'] as String),
  };
  final providerKeys = {
    for (final name in providers.keys) name: '@provider:$name',
  };
  List<String> providerDialers(Map<String, dynamic> provider) {
    final override = (provider['override'] as Map?)?['dialer-proxy'];
    if (override is String) {
      return [if (override.isNotEmpty) override];
    }
    final dialer = provider['dialer-proxy'];
    if (dialer is String && dialer.isNotEmpty) return [dialer];
    return [
      for (final node in _mappings(provider['payload']))
        if (node['dialer-proxy'] case final String value when value.isNotEmpty)
          value,
    ];
  }

  names.addAll(providerKeys.values);
  final graph = <String, List<String>>{
    for (final node in proxies)
      node['name'] as String: [
        if (node['dialer-proxy'] case final String value when value.isNotEmpty)
          value,
      ],
    for (final group in groups)
      group['name'] as String: [
        ...List<String>.from(group['proxies'] as List? ?? const []),
        for (final name in group['use'] as List? ?? const [])
          ?providerKeys[name],
      ],
    for (final entry in providers.entries)
      providerKeys[entry.key]!: providerDialers(entry.value),
  };
  final visiting = <String>{};
  final visited = <String>{};
  void visit(String name) {
    if (visited.contains(name)) return;
    if (!visiting.add(name)) {
      throw FormatException('Policy reference cycle: $name');
    }
    for (final next in graph[name] ?? const <String>[]) {
      if (!names.contains(next)) {
        throw FormatException('Policy reference missing: $next');
      }
      visit(next);
    }
    visiting.remove(name);
    visited.add(name);
  }

  for (final group in groups) {
    for (final name in group['use'] as List? ?? const []) {
      if (!providers.containsKey(name)) {
        throw FormatException('Proxy provider missing: $name');
      }
    }
  }
  for (final name in graph.keys) {
    visit(name);
  }
}
