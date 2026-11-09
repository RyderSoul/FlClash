import 'dart:convert';

import 'package:fl_clash/models/models.dart';

typedef BindingSources = ({
  Map<String, dynamic> config,
  List<SubscriptionBinding> subscriptions,
  Map<int, Map<String, dynamic>> sources,
  List<RuleSetBinding> rules,
  Map<int, Map<String, dynamic>> ruleSources,
});

List<Map<String, dynamic>> _mappings(Object? value) => [
  for (final item in value as List? ?? const [])
    Map<String, dynamic>.from(item as Map),
];

Map<String, Map<String, dynamic>> _providers(Object? value) => {
  for (final entry in (value as Map? ?? const {}).entries)
    entry.key as String: Map<String, dynamic>.from(entry.value as Map),
};

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

String _namespacedFilter(
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

Map<String, dynamic> buildProfileBindings(
  BindingSources data, {
  Set<String> plannedPolicies = const {},
}) {
  if (!data.subscriptions.any((item) => item.enabled) &&
      !data.rules.any((item) => item.enabled)) {
    return data.config;
  }
  final config = jsonDecode(jsonEncode(data.config)) as Map<String, dynamic>;
  final proxies = _mappings(config['proxies']);
  final groups = _mappings(config['proxy-groups']);
  final providers = _providers(config['proxy-providers']);
  final originalProviders = providers.keys.toList();
  final names = {
    'DIRECT',
    'REJECT',
    'GLOBAL',
    'REJECT-DROP',
    'PASS',
    'COMPATIBLE',
    ...proxies.map((p) => p['name'] as String),
    ...groups.map((g) => g['name'] as String),
  };
  final injectedNodes = <String>[];
  final flattened = <String, Set<String>>{};
  final pending =
      <({String target, List<String> nodes, List<String> providers})>[];
  for (final binding in data.subscriptions.where((item) => item.enabled)) {
    final source = data.sources[binding.sourceId];
    if (source == null) {
      throw FormatException('Subscription source missing: ${binding.name}');
    }
    if (binding.name.trim().isEmpty || !names.add(binding.name)) {
      throw FormatException(
        'Subscription group name conflicts: ${binding.name}',
      );
    }
    final rawNodes = _mappings(source['proxies']);
    final rawGroups = _mappings(source['proxy-groups']);
    final rawProviders = _providers(source['proxy-providers']);
    final renamed = <String, String>{
      for (final node in [...rawNodes, ...rawGroups])
        node['name'] as String: '${binding.name} · ${node['name']}',
    };
    final providerNames = {
      for (final key in rawProviders.keys) key: 'flsmart-${binding.id}-$key',
    };
    final filter = binding.filter.isEmpty
        ? null
        : subscriptionNodeFilter(binding.filter);
    final members = <String>[];
    for (final node in rawNodes) {
      final original = node['name'] as String;
      final name = renamed[original]!;
      if (!names.add(name)) {
        throw FormatException('Subscription node name conflicts: $name');
      }
      final dialer = node['dialer-proxy'];
      proxies.add({
        ...node,
        'name': name,
        if (dialer is String) 'dialer-proxy': renamed[dialer] ?? dialer,
      });
      injectedNodes.add(name);
      if (filter == null || filter.hasMatch(original)) members.add(name);
    }
    final memberProviders = <String>[];
    for (final entry in rawProviders.entries) {
      final name = providerNames[entry.key]!;
      if (providers.containsKey(name)) {
        throw FormatException('Subscription provider name conflicts: $name');
      }
      final options = Map<String, dynamic>.from(
        entry.value['override'] as Map? ?? const {},
      );
      final dialer = options['dialer-proxy'];
      providers[name] = {
        ...entry.value,
        if (entry.value['proxy'] is String)
          'proxy': renamed[entry.value['proxy']] ?? entry.value['proxy'],
        if (entry.value['dialer-proxy'] is String)
          'dialer-proxy':
              renamed[entry.value['dialer-proxy']] ??
              entry.value['dialer-proxy'],
        if (entry.value['payload'] is List)
          'payload': [
            for (final node in _mappings(entry.value['payload']))
              {
                ...node,
                if (node['dialer-proxy'] is String)
                  'dialer-proxy':
                      renamed[node['dialer-proxy']] ?? node['dialer-proxy'],
              },
          ],
        'override': {
          ...options,
          'additional-prefix':
              '${binding.name} · ${options['additional-prefix'] ?? ''}',
          if (dialer is String) 'dialer-proxy': renamed[dialer] ?? dialer,
        },
      };
      if (binding.filter.isEmpty) {
        memberProviders.add(name);
      } else {
        if (entry.value['type'] == 'inline' &&
            !_mappings(
              entry.value['payload'],
            ).any((node) => filter!.hasMatch(node['name'] as String))) {
          continue;
        }
        final filteredName = '$name-members';
        if (providers.containsKey(filteredName)) {
          throw FormatException(
            'Subscription provider name conflicts: $filteredName',
          );
        }
        providers[filteredName] = {
          ...providers[name]!,
          'exclude-filter': [
            if (entry.value['exclude-filter'] case final String value
                when value.isNotEmpty)
              value,
            '^(?![\\s\\S]*(?:${binding.filter.replaceAll('`', r'\x60')}))[\\s\\S]*\$',
          ].join('`'),
        };
        memberProviders.add(filteredName);
      }
    }
    for (final group in rawGroups) {
      final name = renamed[group['name']]!;
      if (!names.add(name)) {
        throw FormatException('Subscription group name conflicts: $name');
      }
      final all = group['include-all'] == true;
      final sourceFilter = group['filter'];
      final staticFilters =
          (all || group['include-all-proxies'] == true) &&
              sourceFilter is String &&
              sourceFilter.isNotEmpty
          ? sourceFilter.split('`').map(subscriptionNodeFilter).toList()
          : <RegExp>[];
      groups.add({
        ...group,
        'name': name,
        'hidden': true,
        for (final key in ['filter', 'exclude-filter'])
          if (group[key] case final String value when value.isNotEmpty)
            key: _namespacedFilter(
              value,
              '${binding.name} · ',
              exclude: key == 'exclude-filter',
            ),
        if (group['default-selected'] is String)
          'default-selected':
              renamed[group['default-selected']] ?? group['default-selected'],
        if (group['empty-fallback'] is String)
          'empty-fallback':
              renamed[group['empty-fallback']] ?? group['empty-fallback'],
        if (group['use-position'] is Map)
          'use-position': {
            for (final entry in (group['use-position'] as Map).entries)
              providerNames[entry.key] ?? entry.key: entry.value,
          },
        'include-all': false,
        'include-all-proxies': false,
        'include-all-providers': false,
        'proxies': {
          for (final item in group['proxies'] as List? ?? const [])
            renamed[item] ?? item,
          if (all || group['include-all-proxies'] == true)
            for (final node in rawNodes)
              if (staticFilters.isEmpty ||
                  staticFilters.any(
                    (filter) => filter.hasMatch(node['name'] as String),
                  ))
                renamed[node['name']]!,
        }.toList(),
        'use': {
          for (final item in group['use'] as List? ?? const [])
            providerNames[item] ?? item,
          if (all || group['include-all-providers'] == true)
            ...providerNames.values,
        }.toList(),
      });
    }
    if (members.isEmpty && memberProviders.isEmpty) {
      throw FormatException(
        'Subscription has no matching nodes: ${binding.name}',
      );
    }
    groups.add({
      'name': binding.name,
      'type': binding.groupType.value,
      'proxies': members,
      'use': memberProviders,
      'url': 'https://www.gstatic.com/generate_204',
      'interval': 300,
    });
    for (final attachment in binding.attachments) {
      pending.add((
        target: attachment.target,
        nodes: attachment.mode == SubscriptionAttachMode.nodes
            ? members
            : [binding.name],
        providers: attachment.mode == SubscriptionAttachMode.nodes
            ? memberProviders
            : const [],
      ));
      if (attachment.mode == SubscriptionAttachMode.nodes) {
        flattened.putIfAbsent(attachment.target, () => {}).addAll(members);
      }
    }
  }
  final byName = {for (final group in groups) group['name'] as String: group};
  for (final group in groups.take(
    data.config['proxy-groups'] is List
        ? (data.config['proxy-groups'] as List).length
        : 0,
  )) {
    final all = group['include-all'] == true;
    if (all || group['include-all-providers'] == true) {
      group['include-all'] = false;
      group['include-all-providers'] = false;
      group['use'] = {
        ...group['use'] as List? ?? const [],
        ...originalProviders,
      }.toList();
      if (all) group['include-all-proxies'] = true;
    }
    if (group['include-all-proxies'] == true) {
      final excluded = injectedNodes.where(
        (name) => !(flattened[group['name']]?.contains(name) ?? false),
      );
      if (excluded.isNotEmpty) {
        final pattern = '^(?:${excluded.map(RegExp.escape).join('|')})\$'
            .replaceAll('`', r'\x60');
        final previous = group['exclude-filter'];
        group['exclude-filter'] = previous is String && previous.isNotEmpty
            ? '$previous`$pattern'
            : pattern;
      }
    }
  }
  for (final attachment in pending) {
    final target = byName[attachment.target];
    if (target == null || !attachableGroupTypes.contains(target['type'])) {
      throw FormatException(
        'Subscription target group missing or incompatible: ${attachment.target}',
      );
    }
    target['proxies'] = {
      ...target['proxies'] as List? ?? const [],
      ...attachment.nodes,
    }.toList();
    target['use'] = {
      ...target['use'] as List? ?? const [],
      ...attachment.providers,
    }.toList();
  }
  final ruleProviders = _providers(config['rule-providers']);
  final rules = <String>[];
  for (final binding in data.rules.where((item) => item.enabled)) {
    final source = data.ruleSources[binding.sourceId];
    if (source == null) {
      throw FormatException('Rule source missing: ${binding.sourceId}');
    }
    if ((!names.contains(binding.target) &&
            !plannedPolicies.contains(binding.target)) ||
        binding.target.contains(',')) {
      throw FormatException(
        'Rule target missing or invalid: ${binding.target}',
      );
    }
    final name = 'flsmart-rule-${binding.id}';
    if (ruleProviders.containsKey(name)) {
      throw FormatException('Rule source name conflicts: $name');
    }
    ruleProviders[name] = source;
    rules.add('RULE-SET,$name,${binding.target}');
  }
  config['proxies'] = proxies;
  config['proxy-groups'] = groups;
  config['proxy-providers'] = providers;
  config['rule-providers'] = ruleProviders;
  config['rules'] = [...rules, ...config['rules'] as List? ?? const []];
  validatePolicyReferences(config, allowedPolicies: plannedPolicies);
  return config;
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
  names.addAll(providerKeys.values);
  final graph = <String, List<String>>{
    for (final node in proxies)
      node['name'] as String: [
        if (node['dialer-proxy'] is String) node['dialer-proxy'] as String,
      ],
    for (final group in groups)
      group['name'] as String: [
        ...List<String>.from(group['proxies'] as List? ?? const []),
        for (final name in group['use'] as List? ?? const [])
          ?providerKeys[name],
      ],
    for (final entry in providers.entries)
      providerKeys[entry.key]!: [
        if (entry.value['dialer-proxy'] is String)
          entry.value['dialer-proxy'] as String,
        if (entry.value['override'] case final Map options)
          if (options['dialer-proxy'] is String)
            options['dialer-proxy'] as String,
        for (final node in _mappings(entry.value['payload']))
          if (node['dialer-proxy'] is String) node['dialer-proxy'] as String,
      ],
  };
  final visiting = <String>{};
  final visited = <String>{};
  void visit(String name) {
    if (visited.contains(name)) return;
    if (!visiting.add(name)) {
      throw FormatException('Policy reference cycle: $name');
    }
    for (final next in graph[name] ?? const <String>[]) {
      if (names.contains(next)) visit(next);
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
  for (final proxy in proxies) {
    final dialer = proxy['dialer-proxy'];
    if (dialer is String && !names.contains(dialer)) {
      throw FormatException('Policy reference missing: $dialer');
    }
  }
  for (final group in groups) {
    for (final member in group['proxies'] as List? ?? const []) {
      if (member is String && !names.contains(member)) {
        throw FormatException('Policy reference missing: $member');
      }
    }
  }
  for (final name in graph.keys) {
    visit(name);
  }
}
