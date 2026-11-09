import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:fl_clash/common/proxy_chain.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/profiles/extend/chains.dart';
import 'package:fl_clash/views/proxies/proxies.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/glyph_finders.dart';
import '../helpers/app_paths.dart';
import '../helpers/test_app.dart';
import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _ChainBindings extends ProfileBindingsAction {
  @override
  Future<ClashConfig> inventory(int profileId) =>
      ref.read(clashConfigProvider(profileId).future);

  @override
  Future<void> validate(Profile candidate, {List<Rule>? localRules}) async {
    final config = await ref.read(coreHandlerProvider).readConfig(candidate.id);
    applyProxyChains(config, candidate.overrides.chains);
  }
}

class _LatencyBindings extends _ChainBindings {
  final checks = <int>[];
  Completer<Delay>? pending;
  bool fail = false;

  @override
  Future<Delay> testChainHop(int profileId, ProxyChain chain, int index) async {
    checks.add(index);
    if (fail) throw StateError('probe unavailable');
    if (pending != null) return pending!.future;
    return Delay(
      name: chain.name,
      url: 'https://check',
      value: index == 0 ? 45 : -1,
    );
  }
}

void main() {
  final previewFont = Platform.environment['FLSMART_PREVIEW_FONT'];
  setUpAll(() async {
    if (previewFont == null) return;
    final bytes = await File(previewFont).readAsBytes();
    await (FontLoader(
      'ChainPreview',
    )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
  });
  testWidgets(
    'chain panel shows per-hop results, failures and clears stale checks',
    (tester) async {
      tester.view.physicalSize = const Size(400, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final profile = Profile.normal(label: 'Production').copyWith(
        overrides: const ProfileOverrides(
          chains: [
            ProxyChain(
              id: 'latency',
              name: 'US route',
              hops: ['HK entry', 'US exit'],
            ),
          ],
        ),
      );
      final action = _LatencyBindings();
      final preview = GlobalKey();
      final container = ProviderContainer.test(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          coreStatusProvider.overrideWithBuild((_, _) => CoreStatus.connected),
          runTimeProvider.overrideWithBuild((_, _) => 1),
          bindingsAppliedProvider.overrideWith((_, _) async => true),
          profileBindingsActionProvider.overrideWith(() => action),
        ],
      );
      globalState.container = container;
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: TestApp(
            locale: const Locale('zh', 'CN'),
            theme: ThemeData(
              fontFamily: previewFont == null ? null : 'ChainPreview',
            ),
            child: RepaintBoundary(
              key: preview,
              child: ProxyChainsView(profileId: profile.id),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('第1跳'), findsOneWidget);
      expect(find.text('第2跳'), findsOneWidget);
      await tester.tap(find.text('检测链路'));
      await tester.pumpAndSettle();
      expect(action.checks, [0, 1]);
      expect(find.text('45 ms'), findsOneWidget);
      expect(find.text('超时'), findsOneWidget);
      expect(find.text('整条链路: 超时'), findsOneWidget);
      final output = Platform.environment['FLSMART_CHAIN_PREVIEW'];
      if (output != null) {
        final boundary =
            preview.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          image.dispose();
          await File(output).parent.create(recursive: true);
          await File(output).writeAsBytes(bytes!.buffer.asUint8List());
        });
      }
      action.fail = true;
      await tester.tap(find.text('检测链路'));
      await tester.pumpAndSettle();
      expect(find.textContaining('probe unavailable'), findsOneWidget);
      expect(find.text('错误'), findsNWidgets(2));
      action.fail = false;
      action.pending = Completer<Delay>();
      await tester.tap(find.text('检测链路'));
      await tester.pump();
      container.read(currentProfileIdProvider.notifier).value = null;
      await tester.pump();
      action.pending!.complete(
        const Delay(name: 'old', url: 'https://check', value: 99),
      );
      await tester.pumpAndSettle();
      expect(find.text('99 ms'), findsNothing);
      expect(find.text('请先应用并启动当前配置，再检测链路。'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
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
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        await Directory(output).create(recursive: true);
        await File(
          '$output/smart-usage.png',
        ).writeAsBytes(bytes!.buffer.asUint8List());
      });
    }
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets('chain switch retains hops and invalid edits show an error', (
    tester,
  ) async {
    final root = Directory.systemTemp.createTempSync('flsmart-chain-test');
    await useAppPaths(root);
    addTearDown(() => root.deleteSync(recursive: true));
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
        'proxy-groups': [
          {
            'name': 'Smart',
            'type': 'smart',
            'proxies': ['entry'],
          },
          {
            'name': 'Select',
            'type': 'select',
            'proxies': ['entry'],
          },
        ],
      },
    );
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
        profileBindingsActionProvider.overrideWith(_ChainBindings.new),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        clashConfigProvider(profile.id).overrideWith(
          (_) async => const ClashConfig(
            proxies: [
              Proxy(name: 'entry', type: 'socks5'),
              Proxy(name: 'exit', type: 'snell'),
            ],
            proxyGroups: [
              ProxyGroup(id: 1, name: 'Smart', type: GroupType.Smart),
              ProxyGroup(id: 2, name: 'Select', type: GroupType.Selector),
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
    await tester.enterText(find.byType(EditableText).first, 'Multi-target');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle();
    final formScroll = find.descendant(
      of: find.byType(FormPage),
      matching: find.byWidgetPredicate(
        (widget) =>
            widget is Scrollable && widget.axisDirection == AxisDirection.down,
      ),
    );
    for (final hop in ['entry', 'Select']) {
      await tester.scrollUntilVisible(
        find.byType(MoreActionButton),
        200,
        scrollable: formScroll,
      );
      await tester.pumpAndSettle();
      await Scrollable.ensureVisible(
        tester.element(find.byType(MoreActionButton)),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(MoreActionButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text(hop).last);
      await tester.pumpAndSettle();
    }
    for (final target in ['Smart', 'Select']) {
      await tester.scrollUntilVisible(
        find.text('Add to policy groups'),
        -200,
        scrollable: formScroll,
      );
      await tester.pumpAndSettle();
      await Scrollable.ensureVisible(
        tester.element(find.text('Add to policy groups')),
        alignment: 0.5,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to policy groups'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(target).last);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();
    final saved = container.read(profilesProvider).single.overrides.chains.last;
    expect(saved.name, 'Multi-target');
    expect(saved.hops, ['entry', 'Select']);
    expect(saved.targets, {'Smart', 'Select'});
    expect(tester.takeException(), isNull);
  });
}
