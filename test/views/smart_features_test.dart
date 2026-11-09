import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/profiles/extend/chains.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/glyph_finders.dart';
import '../helpers/app_paths.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

void main() {
  testWidgets('Smart nodes show all Chinese usage states without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final profile = Profile.normal().copyWith(
      currentGroupName: 'Smart',
      unfoldSet: {'Smart'},
    );
    const group = Group(
      name: 'Smart',
      type: GroupType.Smart,
      hidden: false,
      all: [
        Proxy(name: '节点 A', type: 'ss', usageRank: 'MostUsed'),
        Proxy(name: '节点 B', type: 'ss', usageRank: 'OccasionalUsed'),
        Proxy(name: '节点 C', type: 'ss', usageRank: 'RarelyUsed'),
        Proxy(name: '节点 D', type: 'ss', usageRank: 'Pending'),
      ],
    );
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
        groupsProvider.overrideWithValue([group]),
        proxiesStyleSettingProvider.overrideWithBuild(
          (_, _) => const ProxiesStyleProps(type: ProxiesType.list),
        ),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    final preview = GlobalKey();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(
          locale: const Locale('zh', 'CN'),
          child: RepaintBoundary(key: preview, child: const ProxiesView()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (final label in ['经常使用', '偶尔使用', '很少使用', '统计中']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
    final output = Platform.environment['NODE_TRAFFIC_PREVIEW_DIR'];
    if (output != null) {
      final boundary =
          preview.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      await tester.runAsync(() async {
        await Directory(output).create(recursive: true);
        await File(
          '$output/smart-usage.png',
        ).writeAsBytes(bytes!.buffer.asUint8List());
      });
      image.dispose();
    }
  });

  testWidgets('chain switch retains hops and invalid edits show an error', (
    tester,
  ) async {
    final root = await Directory.systemTemp.createTemp('flsmart-chain-test');
    await useAppPaths(root);
    addTearDown(() => root.delete(recursive: true));
    final core = _Core();
    final profile = Profile.normal().copyWith(
      overrides: const ProfileOverrides(
        chains: [
          ProxyChain(id: 'one', name: 'Chain', hops: ['entry', 'exit']),
        ],
      ),
    );
    when(() => core.readConfig(any())).thenAnswer(
      (_) async => <String, dynamic>{
        'proxies': [
          {'name': 'entry', 'type': 'socks5'},
          {'name': 'exit', 'type': 'snell'},
        ],
      },
    );
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        clashConfigProvider(profile.id).overrideWith(
          (_) async => const ClashConfig(
            proxies: [
              Proxy(name: 'entry', type: 'socks5'),
              Proxy(name: 'exit', type: 'snell'),
            ],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    globalState.container = container;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TestApp(child: ProxyChainsView(profileId: profile.id)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    final chain = container
        .read(profilesProvider)
        .single
        .overrides
        .chains
        .single;
    expect(chain.enabled, false);
    expect(chain.hops, ['entry', 'exit']);
    await tester.tap(find.byGlyph(AppGlyphs.addCircle));
    await tester.pumpAndSettle();
    await tester.tap(find.byGlyph(AppGlyphs.check));
    await tester.pumpAndSettle();
    expect(find.textContaining('Proxy chain name'), findsOneWidget);
    expect(
      container.read(profilesProvider).single.overrides.chains,
      hasLength(1),
    );
    expect(tester.takeException(), isNull);
  });
}
