import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'keeps ranking scoped to the Smart group and leaves source untouched',
    () async {
      final proxies = <String, dynamic>{
        'Smart': {
          'name': 'Smart',
          'type': 'Smart',
          'all': ['a', 'b', 'c', 'd'],
          'usageRanks': {
            'a': 'MostUsed',
            'b': 'OccasionalUsed',
            'c': 'RarelyUsed',
          },
        },
        'Other': {
          'name': 'Other',
          'type': 'Selector',
          'all': ['a'],
        },
        for (final name in ['a', 'b', 'c', 'd'])
          name: {'name': name, 'type': 'ss'},
      };
      final groups = await buildGroups(
        ComputeGroupsState(
          proxiesData: ProxiesData(all: ['Smart', 'Other'], proxies: proxies),
          sortType: ProxiesSortType.none,
          delayMap: {},
          selectedMap: {},
          defaultTestUrl: '',
        ),
      );
      expect(groups.first.all.map((node) => node.usageRank), [
        'MostUsed',
        'OccasionalUsed',
        'RarelyUsed',
        'Pending',
      ]);
      expect(groups.last.all.single.usageRank, null);
      expect(proxies['a'].containsKey('usageRank'), false);
    },
  );

  test(
    'replaces original rules only while the rule override is enabled',
    () async {
      for (final replace in [false, true]) {
        final profile = await makeRealProfileTask(
          MakeRealProfileState(
            profilesPath: '/profiles',
            profileId: 1,
            rawConfig: {
              'rules': ['MATCH,DIRECT'],
            },
            realPatchConfig: const PatchClashConfig(),
            overrides: ProfileOverrides(replaceRules: replace),
            appendSystemDns: false,
            proxyGroups: [],
            rules: [],
            addedRules: [Rule.parse('DOMAIN,example.com,REJECT')],
            defaultUA: 'test',
          ),
        );
        final config = loadPlainYaml(profile.yaml) as Map;
        expect(config['rules'], [
          'DOMAIN,example.com,REJECT',
          if (!replace) 'MATCH,DIRECT',
        ]);
      }
    },
  );
}
