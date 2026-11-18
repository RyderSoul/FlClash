import 'package:fl_clash/common/managed_script.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('mirrorUrl rewrites GitHub raw and blob URLs through jsdelivr', () {
    expect(
      mirrorUrl(
        'https://raw.githubusercontent.com/appshubcc/Bettbox/main/assets/scripts/managed.js',
      ),
      'https://cdn.jsdelivr.net/gh/appshubcc/Bettbox@main/assets/scripts/managed.js',
    );
    expect(
      mirrorUrl('https://fastly.jsdelivr.net/gh/a/b@main/file.txt'),
      'https://cdn.jsdelivr.net/gh/a/b@main/file.txt',
    );
    expect(
      mirrorUrl('https://example.com/a.yaml'),
      'https://example.com/a.yaml',
    );
  });

  test('routeIconUrl and matchRouteIcon resolve SVG icons cleanly', () {
    expect(
      routeIconUrl('YouTube.svg'),
      'https://cdn.jsdelivr.net/gh/appshubcc/Qure_Style_SVG@main/icon/svg/common/YouTube.svg',
    );
    expect(
      routeIconUrl('flag/Hong_Kong.svg'),
      'https://cdn.jsdelivr.net/gh/appshubcc/Qure_Style_SVG@main/icon/svg/flag/Hong_Kong.svg',
    );
    final idx = routeIconIndex([
      'common/YouTube.svg',
      'common/Google.svg',
      'common/Telegram.svg',
    ]);
    expect(matchRouteIcon('youtube-!cn@ads', idx), 'common/YouTube.svg');
    expect(matchRouteIcon('category-google-api', idx), 'common/Google.svg');
  });

  test('orderManagedGroups honors custom anchor and saved sort order', () {
    final ordered = orderManagedGroups(
      presets: const ['Proxy', 'AdBlock', 'Final'],
      customs: const ['AI', 'Dev'],
      regions: const ['HK', 'JP'],
      saved: const ['AI', 'Proxy', 'JP'],
    );
    expect(ordered, ['AI', 'Dev', 'AdBlock', 'Final', 'HK', 'Proxy', 'JP']);
  });

  test('CustomRuleSet parses urls and guesses behavior and format', () {
    final domain = CustomRuleSet.parse(
      'domain:https://example.com/rules/google.mrs',
    );
    expect(domain?.ip, isFalse);
    expect(domain?.format, 'mrs');
    expect(domain?.name, 'google');
    expect(
      CustomRuleSet.guessBehavior('https://example.com/geoip/cn.yaml'),
      CustomRuleSet.ipcidr,
    );
    expect(CustomRuleSet.isValidUrl('https://example.com/list.txt'), isTrue);
    expect(CustomRuleSet.isValidUrl('ftp://example.com/list'), isFalse);
  });

  test(
    'ManagedScript.prepare injects custom routes, regions and options',
    () async {
      final prepared = await ManagedScript.prepare(
        const ManagedProps(
          regions: ['HK'],
          customRegions: [CustomRegion(name: 'CustomHK', regex: 'HK')],
          routes: [
            CustomRoute(
              id: 'r1',
              name: 'MyAI',
              sets: ['domain:https://example.com/ai.mrs'],
            ),
          ],
          order: ['MyAI', 'HK'],
          options: {'OpenAI': false},
        ),
        bundled: true,
      );

      expect(prepared.customOptions, {'OpenAI': false});
      expect(prepared.content, contains('const bettboxRoutes ='));
      expect(prepared.content, contains('const bettboxRegions = ["HK"];'));
      expect(prepared.content, contains('const bettboxCustomRegions ='));
      expect(prepared.content, contains('const bettboxOrder = ["MyAI","HK"];'));
      expect(prepared.content, contains('Compatible_With_Bettbox'));
    },
  );

  test('ManagedScript.applySmartAutoGroups converts url-test to smart', () {
    final updated = ManagedScript.applySmartAutoGroups({
      'proxy-groups': [
        {
          'name': 'HK Auto',
          'type': 'url-test',
          'tolerance': 50,
          'proxies': ['HK-1'],
        },
        {
          'name': 'Manual',
          'type': 'select',
          'proxies': ['HK Auto'],
        },
      ],
    });

    final groups = updated['proxy-groups'] as List;
    expect(groups[0], {
      'name': 'HK Auto',
      'type': 'smart',
      'proxies': ['HK-1'],
      'uselightgbm': false,
      'collectdata': false,
    });
    expect(groups[1], {
      'name': 'Manual',
      'type': 'select',
      'proxies': ['HK Auto'],
    });
  });

  test(
    'RouteCatalogIndex resolves icons and ManagedScript versions compare',
    () {
      const catalog = RouteCatalog(
        icons: ['common/YouTube.svg', 'flag/Hong_Kong.svg'],
        regions: [RouteRegion(name: '香港', icon: 'flag/Hong_Kong.svg')],
        services: [
          RouteService(
            name: 'YouTube',
            icon: 'common/YouTube.svg',
            sets: ['geosite:youtube'],
          ),
        ],
      );
      final idx = RouteCatalogIndex(catalog);
      expect(
        idx.iconOf(
          const CustomRoute(id: 'r2', name: 'YT', sets: ['geosite:youtube']),
        ),
        'common/YouTube.svg',
      );
      expect(
        ManagedScript.compareVersions('20260501', '20260401'),
        greaterThan(0),
      );
      expect(
        ManagedScript.parseVersion('// @version 20260501\nfunction main() {}'),
        '20260501',
      );
    },
  );
}
