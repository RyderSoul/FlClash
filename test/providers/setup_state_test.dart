import 'package:drift/native.dart';
import 'package:fl_clash/database/database.dart' as db;
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/database.dart';
import 'package:fl_clash/providers/state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_profiles.dart';

void main() {
  late db.Database testDatabase;

  setUp(() {
    testDatabase = db.Database(NativeDatabase.memory());
    db.database = testDatabase;
  });

  tearDown(() async {
    await testDatabase.close();
  });

  for (final withRuleBinding in [false, true]) {
    test(
      'a script setup disposed during its query resolves with rule binding: $withRuleBinding',
      () async {
        const subscription = Profile(
          id: 2,
          label: 'Sub',
          type: ProfileType.url,
          autoUpdateDuration: Duration.zero,
        );
        final ruleSet = ClashProvider.create(label: 'Rules');
        final script = Script(
          id: 5,
          label: 'Script',
          lastUpdateTime: DateTime(2026),
        );
        final profile = Profile(
          id: 1,
          autoUpdateDuration: Duration.zero,
          extendType: ExtendType.script,
          scriptId: script.id,
          overrides: ProfileOverrides(
            rulesEnabled: true,
            chains: const [
              ProxyChain(id: 'chain', name: 'Chain', hops: ['Front', 'Exit']),
            ],
            subscriptions: const [
              SubscriptionBinding(id: 'sub', sourceId: 2, name: 'Sub'),
            ],
            ruleBindings: withRuleBinding
                ? [
                    RuleSetBinding(
                      id: 'rules',
                      sourceId: ruleSet.id,
                      target: 'DIRECT',
                    ),
                  ]
                : const [],
          ),
        );
        await testDatabase.scripts.put(script.toCompanion());
        await testDatabase.clashProviders.put(ruleSet.toCompanion());
        final container = ProviderContainer(
          overrides: [
            profilesProvider.overrideWith(
              () => TestProfiles([profile, subscription]),
            ),
          ],
        );
        container.listen(clashProvidersProvider, (_, _) {});
        await container.read(clashProvidersProvider.future);

        final loading = container.read(setupStateProvider(profile.id).future);
        container.dispose();
        final state = await loading;

        expect(state.script, script);
        expect(state.bindingProfiles, [subscription]);
        expect(state.clashProviders, withRuleBinding ? [ruleSet] : isEmpty);
        expect(state.overrides.chains, profile.overrides.chains);
      },
    );
  }

  test(
    'an attached subscription setup disposed during its query resolves',
    () async {
      const subscription = Profile(
        id: 2,
        label: 'Sub',
        type: ProfileType.url,
        autoUpdateDuration: Duration.zero,
      );
      const profile = Profile(
        id: 1,
        autoUpdateDuration: Duration.zero,
        overrides: ProfileOverrides(
          subscriptions: [
            SubscriptionBinding(id: 'sub', sourceId: 2, name: 'Sub'),
          ],
        ),
      );
      final container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(
            () => TestProfiles([profile, subscription]),
          ),
        ],
      );

      final loading = container.read(setupStateProvider(profile.id).future);
      container.dispose();
      final state = await loading;

      expect(state.script, isNull);
      expect(state.bindingProfiles, [subscription]);
      expect(state.overrides.subscriptions, profile.overrides.subscriptions);
    },
  );

  for (final feature in ['script', 'rules', 'chain']) {
    test('a $feature-only setup disposed during its query resolves', () async {
      final script = Script(
        id: 5,
        label: 'Script',
        lastUpdateTime: DateTime(2026),
      );
      final ruleSet = ClashProvider.create(label: 'Rules');
      final profile = Profile(
        id: 1,
        autoUpdateDuration: Duration.zero,
        extendType: feature == 'script'
            ? ExtendType.script
            : ExtendType.standard,
        scriptId: feature == 'script' ? script.id : null,
        overrides: ProfileOverrides(
          ruleBindings: feature == 'rules'
              ? [
                  RuleSetBinding(
                    id: 'rules',
                    sourceId: ruleSet.id,
                    target: 'DIRECT',
                  ),
                ]
              : const [],
          chains: feature == 'chain'
              ? const [
                  ProxyChain(
                    id: 'chain',
                    name: 'Chain',
                    hops: ['Front', 'Exit'],
                  ),
                ]
              : const [],
        ),
      );
      await testDatabase.scripts.put(script.toCompanion());
      await testDatabase.clashProviders.put(ruleSet.toCompanion());
      final container = ProviderContainer(
        overrides: [
          profilesProvider.overrideWith(() => TestProfiles([profile])),
        ],
      );
      container.listen(clashProvidersProvider, (_, _) {});
      await container.read(clashProvidersProvider.future);

      final loading = container.read(setupStateProvider(profile.id).future);
      container.dispose();
      final state = await loading;

      expect(state.script, feature == 'script' ? script : isNull);
      expect(state.bindingProfiles, isEmpty);
      expect(state.clashProviders, feature == 'rules' ? [ruleSet] : isEmpty);
      expect(state.overrides.ruleBindings, profile.overrides.ruleBindings);
      expect(state.overrides.chains, profile.overrides.chains);
    });
  }

  testWidgets('a custom setup disposed before its queries return resolves', (
    tester,
  ) async {
    const profile = Profile(
      id: 1,
      label: 'Home',
      type: ProfileType.custom,
      autoUpdateDuration: Duration.zero,
    );
    const subscription = Profile(
      id: 2,
      label: 'Sub',
      type: ProfileType.url,
      url: 'https://example.com/sub',
      autoUpdateDuration: Duration.zero,
    );
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(
          () => TestProfiles([profile, subscription]),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const SizedBox.shrink(),
      ),
    );

    final state = await container.read(setupStateProvider(profile.id).future);

    expect(state.profileType, ProfileType.custom);
    expect(state.profileProviders, {'Sub': subscription.id});
  });

  testWidgets('a custom setup leaves the extension of its profile out', (
    tester,
  ) async {
    const profile = Profile(
      id: 1,
      type: ProfileType.custom,
      autoUpdateDuration: Duration.zero,
      extendType: ExtendType.script,
      scriptId: 5,
      matchTarget: 'Proxy',
    );
    await testDatabase.profilesDao.putAll([profile.toCompanion()]);
    await testDatabase.scripts.put(
      Script(
        id: 5,
        label: 'Script',
        lastUpdateTime: DateTime(2026),
      ).toCompanion(),
    );
    await testDatabase.rulesDao.putRule(
      Rule.parse('DOMAIN,global.com,DIRECT', id: 10),
    );
    await testDatabase.rulesDao.putRule(
      Rule.parse('DOMAIN,own.com,DIRECT', id: 11),
      profileId: profile.id,
    );
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile])),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const SizedBox.shrink(),
      ),
    );

    final state = await container.read(setupStateProvider(profile.id).future);

    expect(state.script, isNull);
    expect(state.matchTarget, isNull);
    expect(state.addedRules, isEmpty);
    expect(state.rules.map((rule) => rule.id), [11]);
  });

  testWidgets('a custom setup carries the dialers of its own profile', (
    tester,
  ) async {
    const profile = Profile(
      id: 1,
      label: 'Home',
      type: ProfileType.custom,
      autoUpdateDuration: Duration.zero,
    );
    const other = Profile(
      id: 2,
      type: ProfileType.custom,
      autoUpdateDuration: Duration.zero,
    );
    await testDatabase.profilesDao.putAll([
      profile.toCompanion(),
      other.toCompanion(),
    ]);
    await testDatabase.customProxies.put(
      const CustomProxy(id: 30, definition: {'name': 'Home'}).toCompanion(),
    );
    await testDatabase.proxyDialersDao.set(profile.id, 30, 'Relay');
    await testDatabase.proxyDialersDao.set(other.id, 30, 'Other');
    final container = ProviderContainer(
      overrides: [
        profilesProvider.overrideWith(() => TestProfiles([profile, other])),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const SizedBox.shrink(),
      ),
    );

    final state = await container.read(setupStateProvider(profile.id).future);

    expect(state.proxyDialers, {30: 'Relay'});
  });
}
