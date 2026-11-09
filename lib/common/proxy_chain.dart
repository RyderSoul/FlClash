import 'package:fl_clash/models/proxy_chain.dart';

import 'profile_binding.dart';

void applyProxyChains(Map<String, dynamic> config, List<ProxyChain> chains) {
  final active = chains.where((chain) => chain.enabled).toList();
  if (active.isEmpty) return;
  final proxies = [
    for (final proxy in config['proxies'] as List? ?? const [])
      Map<String, dynamic>.from(proxy as Map),
  ];
  final groups = [
    for (final group in config['proxy-groups'] as List? ?? const [])
      Map<String, dynamic>.from(group as Map),
  ];
  final nodes = {for (final proxy in proxies) proxy['name'] as String: proxy};
  final policies = {for (final group in groups) group['name'] as String: group};
  final names = {'DIRECT', 'REJECT', 'GLOBAL', ...nodes.keys, ...policies.keys};
  final edges = <String, List<String>>{
    for (final proxy in proxies)
      proxy['name'] as String: [
        if (proxy['dialer-proxy'] is String) proxy['dialer-proxy'] as String,
      ],
    for (final group in groups)
      group['name'] as String: List<String>.from(
        group['proxies'] as List? ?? const [],
      ),
  };
  final roots = <String>[];
  final generatedNames = <String>[];
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
      throw FormatException('Proxy chain entry no longer exists: $previous');
    }
    for (var i = 1; i < chain.hops.length; i++) {
      final hop = chain.hops[i];
      final definition = nodes[hop];
      if (definition == null) {
        throw FormatException('Proxy chain hop must be a concrete node: $hop');
      }
      final name = '${chain.name} · ${i + 1} · $hop';
      if (!names.add(name)) {
        throw FormatException('Proxy chain generated name conflicts: $name');
      }
      generatedNames.add(name);
      proxies.add({...definition, 'name': name, 'dialer-proxy': previous});
      edges[name] = [previous];
      previous = name;
    }
    groups.add({
      'name': chain.name,
      'type': 'select',
      'proxies': [previous],
      'hidden': chain.hidden,
    });
    edges[chain.name] = [previous];
    roots.add(chain.name);
    for (final target in chain.targets) {
      final group = policies[target];
      if (group == null || !attachableGroupTypes.contains(group['type'])) {
        throw FormatException(
          'Proxy chain target missing or incompatible: $target',
        );
      }
      group['proxies'] = {
        ...group['proxies'] as List? ?? const [],
        chain.name,
      }.toList();
      edges[target] = [...edges[target] ?? const [], chain.name];
    }
  }
  final visiting = <String>{};
  final visited = <String>{};
  void visit(String name) {
    if (visited.contains(name)) return;
    if (!visiting.add(name)) {
      throw FormatException('Proxy chain creates a cycle: $name');
    }
    for (final next in edges[name] ?? const <String>[]) {
      visit(next);
    }
    visiting.remove(name);
    visited.add(name);
  }

  for (final name in roots) {
    visit(name);
  }
  final generatedFilter =
      '^(?:${generatedNames.map(RegExp.escape).join('|')})\$'.replaceAll(
        '`',
        r'\x60',
      );
  for (final group in groups) {
    if (group['include-all'] == true || group['include-all-proxies'] == true) {
      final exclude = group['exclude-filter'];
      group['exclude-filter'] = exclude is String && exclude.isNotEmpty
          ? '$exclude`$generatedFilter'
          : generatedFilter;
    }
  }
  config['proxies'] = proxies;
  config['proxy-groups'] = groups;
}
