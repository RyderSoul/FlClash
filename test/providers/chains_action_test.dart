import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/controller.dart';
import 'package:fl_clash/core/interface.dart';
import 'package:fl_clash/database/database.dart' as db;
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/l10n/l10n.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/app_paths.dart';
import '../helpers/test_database_providers.dart';
import '../helpers/test_profiles.dart';

class _Core extends Mock implements CoreHandlerInterface {}

class _AppliedSetup extends SetupAction {
  int checks = 0;
  bool applied = true;

  @override
  void build() {}

  @override
  Future<bool> inputsApplied() async {
    checks++;
    return applied;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() {
    registerFallbackValue(
      const TestDelayParams(
        proxyName: 'node',
        testUrl: 'https://test',
        timeout: 1,
      ),
    );
  });

  late Directory root;
  late db.Database database;
  late ProviderContainer container;
  late _Core core;
  late Profile target;

  setUp(() async {
    root = Directory.systemTemp.createTempSync('flsmart-chains-action');
    await useAppPaths(root);
    await AppLocalizations.load(const Locale('en'));
    database = db.Database(NativeDatabase.memory());
    db.database = database;
    target = Profile.normal(label: 'Target');
    await database.profiles.put(target.toCompanion());
    final file = await target.file;
    await file.parent.create(recursive: true);
    await file.writeAsString('proxies: []');

    core = _Core();
    when(() => core.validateConfig(any())).thenAnswer((_) async => null);
    container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([target])),
        coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        clashProvidersProvider.overrideWith(TestClashProviders.new),
        scriptsProvider.overrideWith(TestScripts.new),
      ],
    );
    container.listen(clashProvidersProvider, (_, _) {});
    container.listen(scriptsProvider, (_, _) {});
  });

  tearDown(() async {
    container.dispose();
    await database.close();
    await root.delete(recursive: true);
  });

  test(
    'chain checks use applied cumulative paths and reject inactive profiles',
    () async {
      const chain = ProxyChain(
        id: 'latency',
        name: 'US route',
        hops: ['Entry', 'Middle', 'Exit'],
      );
      final profile = target.copyWith(
        overrides: const ProfileOverrides(chains: [chain]),
      );
      const names = ['Entry', 'US route · 第2跳 · Middle', 'US route'];
      when(() => core.getProxies()).thenAnswer(
        (_) async => const ProxiesData(
          proxies: {'Entry': {}, 'US route · 第2跳 · Middle': {}, 'US route': {}},
          all: names,
        ),
      );
      when(() => core.testDelay(any())).thenAnswer((call) async {
        final params = call.positionalArguments.single as TestDelayParams;
        return Delay(name: params.proxyName, url: params.testUrl, value: 80);
      });
      var applied = true;
      final checks = ProviderContainer.test(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
          currentProfileIdProvider.overrideWithBuild((_, _) => profile.id),
          coreStatusProvider.overrideWithBuild((_, _) => CoreStatus.connected),
          runTimeProvider.overrideWithBuild((_, _) => 1),
          profileInputsAppliedProvider.overrideWith((_, _) async => applied),
          coreHandlerProvider.overrideWithValue(CoreController.scoped(core)),
        ],
      );
      checks.listen(profileInputsAppliedProvider(profile.id), (_, _) {});
      final action = checks.read(chainActionProvider.notifier);
      for (var index = 0; index < chain.hops.length; index++) {
        expect(
          (await action.testChainHop(profile.id, chain, index)).name,
          names[index],
        );
      }
      final params = verify(
        () => core.testDelay(captureAny()),
      ).captured.cast<TestDelayParams>();
      expect(params.map((item) => item.proxyName), names);
      expect(params.map((item) => item.testUrl).toSet(), hasLength(1));
      expect(params.every((item) => item.timeout > 0), true);
      applied = false;
      checks.invalidate(profileInputsAppliedProvider(profile.id));
      await expectLater(
        action.testChainHop(profile.id, chain, 1),
        throwsA(isA<MessageException>()),
      );
      verifyNever(() => core.testDelay(any()));
    },
  );

  test(
    'applied status checks once after setup inputs finish loading',
    () async {
      var inputs = Completer<SetupState>();
      final setup = _AppliedSetup();
      final statusContainer = ProviderContainer.test(
        overrides: [
          currentProfileIdProvider.overrideWithBuild((_, _) => target.id),
          setupStateProvider.overrideWith((_, _) => inputs.future),
          setupActionProvider.overrideWith(() => setup),
        ],
      );
      final status = profileInputsAppliedProvider(target.id);
      statusContainer.listen(status, (_, _) {});
      await statusContainer.pump();
      expect(setup.checks, 0);
      final state = SetupState(
        profileId: target.id,
        profileLastUpdateDate: null,
        profileType: ProfileType.file,
        extendType: ExtendType.standard,
        rules: [],
        proxyGroups: [],
        addedRules: [],
        script: null,
        overrides: const ProfileOverrides(),
      );
      inputs.complete(state);
      expect(await statusContainer.read(status.future), true);
      expect(setup.checks, 1);
      inputs = Completer<SetupState>();
      statusContainer.invalidate(setupStateProvider(target.id));
      await statusContainer.pump();
      expect(setup.checks, 1);
      inputs.complete(state);
      expect(await statusContainer.read(status.future), true);
      expect(setup.checks, 2);
      setup.applied = false;
      statusContainer.invalidate(status);
      expect(await statusContainer.read(status.future), false);
    },
  );

  test('inventory reads fresh provider nodes and profile groups', () async {
    when(
      () => core.readConfig(
        any(),
        providerCachePath: any(named: 'providerCachePath'),
        providerPrefix: any(named: 'providerPrefix'),
      ),
    ).thenAnswer(
      (_) async => {
        'proxies': [
          {'name': 'Static', 'type': 'socks5'},
        ],
        'x-flsmart-provider-nodes': [
          {'name': 'HK', 'type': 'snell', 'provider-name': 'remote'},
        ],
        'proxy-groups': [
          {'name': 'Smart', 'type': 'smart'},
        ],
      },
    );
    final config = await container
        .read(chainActionProvider.notifier)
        .inventory(target.id);
    expect(config.proxies.map((proxy) => proxy.name), ['Static', 'HK']);
    expect(config.proxyGroups.map((group) => group.name), ['Smart']);
  });
}
