part of '../action.dart';

@riverpod
Future<bool> bindingsApplied(Ref ref, int profileId) async {
  ref.watch(patchClashConfigProvider);
  ref.watch(networkSettingProvider);
  if (ref.watch(currentProfileIdProvider) != profileId) return false;
  await ref.watch(setupStateProvider(profileId).future);
  if (!ref.mounted) return false;
  return ref.read(setupActionProvider.notifier).inputsApplied();
}

@Riverpod(keepAlive: true)
class ProfileBindingsAction extends _$ProfileBindingsAction {
  @override
  void build() {}

  Future<Delay> testChainHop(int profileId, ProxyChain chain, int index) async {
    RangeError.checkValidIndex(index, chain.hops);
    final profile = ref.read(profileProvider(profileId));
    if (profile == null ||
        ref.read(currentProfileIdProvider) != profileId ||
        !profile.overrides.chainsEnabled ||
        !chain.enabled ||
        !profile.overrides.chains.contains(chain) ||
        ref.read(coreStatusProvider) != CoreStatus.connected ||
        ref.read(runTimeProvider) == null ||
        !await ref.read(bindingsAppliedProvider(profileId).future)) {
      throw MessageException(currentAppLocalizations.proxyChainApplyFirst);
    }
    final outbounds = await ref.read(coreHandlerProvider).getProxies();
    if (!ref.mounted ||
        ref.read(currentProfileIdProvider) != profileId ||
        ref.read(profileProvider(profileId)) != profile ||
        ref.read(coreStatusProvider) != CoreStatus.connected ||
        ref.read(runTimeProvider) == null) {
      throw MessageException(currentAppLocalizations.proxyChainApplyFirst);
    }
    final name = proxyChainProbeName(
      chain,
      index,
      outbounds.proxies.keys.toSet(),
      passthrough: {
        'DIRECT',
        'COMPATIBLE',
        for (final entry in outbounds.proxies.entries)
          if (entry.value is Map &&
              (entry.value['type'] as String?)?.toLowerCase() == 'direct')
            entry.key,
      },
    );
    if (!outbounds.proxies.containsKey(chain.name) ||
        !outbounds.proxies.containsKey(name)) {
      throw MessageException(currentAppLocalizations.proxyChainApplyFirst);
    }
    return ref
        .read(coreHandlerProvider)
        .testDelay(
          TestDelayParams(
            proxyName: name,
            testUrl: ref.read(realTestUrlProvider(null)),
            timeout: ref.read(appSettingProvider).delayTestTimeout,
          ),
        );
  }

  Future<
    ({
      Map<int, Map<String, dynamic>> subscriptions,
      Map<int, Map<String, dynamic>> rules,
    })
  >
  prepare(SetupState state) async {
    final subscriptions = <int, Map<String, dynamic>>{};
    for (final binding in state.overrides.subscriptions.where(
      (item) => item.enabled,
    )) {
      if (binding.sourceId == state.profileId) {
        throw MessageException(currentAppLocalizations.bindingSelfReference);
      }
      final source = state.bindingProfiles.getProfile(binding.sourceId);
      if (source == null || source.type == ProfileType.custom) {
        throw MessageException(
          currentAppLocalizations.bindingSourceMissing(binding.name),
        );
      }
      if (subscriptions.containsKey(source.id)) continue;
      final config = await ref
          .read(coreHandlerProvider)
          .readConfig(
            source.id,
            providerCacheProfileId: state.profileId,
            providerPrefix: 'flsmart-${binding.id}-',
          );
      final providers = config['proxy-providers'];
      if (providers is Map) {
        for (final entry in providers.entries) {
          final provider = entry.value;
          if (provider is Map && provider['type'] == 'file') {
            provider['path'] = join(
              await appPath.profilesPath,
              providersDirectoryName,
              source.id.toString(),
              proxiesProviderDirectoryName,
              'proxy-providers/${entry.key}'.toMd5(),
            );
          }
        }
      }
      subscriptions[source.id] = config;
    }
    final rules = <int, Map<String, dynamic>>{};
    for (final binding in state.overrides.ruleBindings.where(
      (item) => item.enabled,
    )) {
      final provider = state.clashProviders
          .where((item) => item.id == binding.sourceId)
          .firstOrNull;
      if (provider == null) {
        throw MessageException(
          currentAppLocalizations.bindingSourceMissing(
            binding.sourceId.toString(),
          ),
        );
      }
      final prepared = await ref
          .read(clashProvidersActionProvider.notifier)
          .prepare(provider);
      if (!await File(await prepared.corePath).exists()) {
        throw MessageException(
          currentAppLocalizations.bindingSourceMissing(prepared.label),
        );
      }
      rules[provider.id] = prepared.definition(await prepared.corePath);
    }
    return (subscriptions: subscriptions, rules: rules);
  }

  Future<ClashConfig> inventory(int profileId) async {
    final profile = ref.read(profileProvider(profileId));
    if (profile == null) throw StateError('Profile no longer exists');
    Future<ClashConfig> readInventory(int id, {String? providerPrefix}) async {
      var raw = await ref
          .read(coreHandlerProvider)
          .readConfig(
            id,
            providerCacheProfileId: providerPrefix == null ? null : profileId,
            providerPrefix: providerPrefix,
          );
      if (id == profileId &&
          profile.subscriptionOverrideEnabled &&
          profile.scriptId != null) {
        final script = await database.scriptsDao
            .get(profile.scriptId!)
            .getSingleOrNull();
        final content = await script?.content;
        if (script == null || content == null) {
          throw MessageException(
            currentAppLocalizations.bindingSourceMissing(
              script?.label ?? profile.scriptId.toString(),
            ),
          );
        }
        if (content.isNotEmpty) raw = await handleEvaluate(content, raw);
      }
      return clashConfigTask({
        'proxy-groups': [
          for (final group in raw['proxy-groups'] as List? ?? const [])
            {'name': group['name'], 'type': group['type']},
        ],
        'proxies': [
          ...raw['proxies'] as List? ?? const [],
          ...raw['x-flsmart-provider-nodes'] as List? ?? const [],
        ],
      });
    }

    final base = profile.type == ProfileType.custom
        ? ClashConfig(
            proxies: [
              for (final node in await database.customProxiesDao.query().get())
                Proxy(name: node.name, type: node.type),
            ],
            proxyGroups: await database.proxyGroupsDao.query(profileId).get(),
          )
        : await readInventory(profileId);
    final nodes = [...base.proxies];
    final groups = [...base.proxyGroups];
    for (final binding in profile.overrides.subscriptions.where(
      (item) => profile.overrides.attachmentsEnabled && item.enabled,
    )) {
      final source = ref.read(profilesProvider).getProfile(binding.sourceId);
      if (source == null ||
          source.type == ProfileType.custom ||
          source.id == profileId) {
        continue;
      }
      final data = await readInventory(
        source.id,
        providerPrefix: 'flsmart-${binding.id}-',
      );
      nodes.addAll([
        for (final node in data.proxies)
          node.copyWith(name: '${binding.name} · ${node.name}'),
      ]);
      groups.add(
        ProxyGroup(
          id: binding.sourceId,
          name: binding.name,
          type: binding.groupType,
        ),
      );
      groups.addAll([
        for (final group in data.proxyGroups)
          group.copyWith(name: '${binding.name} · ${group.name}'),
      ]);
    }
    return base.copyWith(
      proxies: {for (final node in nodes) node.name: node}.values.toList(),
      proxyGroups: {
        for (final group in groups) group.name: group,
      }.values.toList(),
    );
  }

  Future<BuiltProfile> preview(
    Profile candidate, {
    List<Rule>? localRules,
  }) async {
    final original = await ref.read(setupStateProvider(candidate.id).future);
    final script =
        candidate.subscriptionOverrideEnabled && candidate.scriptId != null
        ? await database.scriptsDao.get(candidate.scriptId!).getSingleOrNull()
        : null;
    if (candidate.subscriptionOverrideEnabled &&
        candidate.scriptId != null &&
        script == null) {
      throw MessageException(
        currentAppLocalizations.bindingSourceMissing(
          candidate.scriptId.toString(),
        ),
      );
    }
    final managed = candidate.type == ProfileType.custom
        ? candidate.overrides
        : candidate.overrides.copyWith(
            dns: original.overrides.dns,
            dnsOverrideKeys: original.overrides.dnsOverrideKeys,
            tun: original.overrides.tun,
            tunOverrideKeys: original.overrides.tunOverrideKeys,
          );
    final disabledRules = await database.rulesDao
        .queryDisabledRuleIds(candidate.id)
        .get();
    final state = original.copyWith(
      overrides: managed.copyWith(
        chains: candidate.overrides.chainsEnabled
            ? candidate.overrides.chains
            : const [],
        subscriptions: candidate.overrides.attachmentsEnabled
            ? candidate.overrides.subscriptions
            : const [],
        ruleBindings: candidate.rulesOverrideEnabled
            ? candidate.overrides.ruleBindings
            : const [],
        replaceRules:
            candidate.rulesOverrideEnabled && candidate.overrides.replaceRules,
      ),
      bindingProfiles: ref
          .read(profilesProvider)
          .where(
            (profile) => candidate.overrides.subscriptions.any(
              (item) => item.sourceId == profile.id,
            ),
          )
          .toList(),
      clashProviders:
          ref.read(clashProvidersProvider).value ??
          await database.clashProvidersDao.query().get(),
      script: script,
      matchTarget: candidate.matchTarget,
      rules: candidate.type == ProfileType.custom && localRules != null
          ? localRules
          : original.rules,
      addedRules:
          candidate.type != ProfileType.custom && candidate.rulesOverrideEnabled
          ? localRules == null
                ? await database.rulesDao.queryAddedRules(candidate.id).get()
                : [
                    ...localRules,
                    ...await database.rulesDao.queryGlobalRules().get().then(
                      (rules) => rules.where(
                        (rule) => !disabledRules.contains(rule.id),
                      ),
                    ),
                  ]
          : const [],
    );
    return ref
        .read(setupActionProvider.notifier)
        .getProfile(
          setupState: state,
          patchConfig: ref.read(patchClashConfigProvider),
        );
  }

  Future<void> validate(Profile candidate, {List<Rule>? localRules}) async {
    final built = await preview(candidate, localRules: localRules);
    final text = built.base == null
        ? built.yaml
        : await ref.read(coreHandlerProvider).buildProfile(built.base!);
    final error = await ref
        .read(coreHandlerProvider)
        .validateConfigWithData(utf8.encode(text));
    if (error != null && error.isNotEmpty) throw MessageException(error);
  }

  Future<void> save(Profile candidate, {List<Rule>? localRules}) async {
    final before = ref.read(profileProvider(candidate.id));
    await validate(candidate, localRules: localRules);
    final latest = ref.read(profileProvider(candidate.id));
    if (latest == null) throw StateError('Profile no longer exists');
    if (latest.overrides != before?.overrides ||
        latest.scriptId != before?.scriptId ||
        latest.matchTarget != before?.matchTarget) {
      throw MessageException(currentAppLocalizations.bindingChanged);
    }
    final profiles = ref.read(profilesProvider.notifier);
    Profile update(Profile value) => value.copyWith(
      overrides: candidate.overrides,
      scriptId: candidate.scriptId,
      matchTarget: candidate.matchTarget,
    );
    if (localRules == null) {
      await profiles.updateProfileAndWait(candidate.id, update);
    } else {
      await profiles.rewriteCustom(() async {
        await database.batch(
          (batch) => database.rulesDao.setProfileRulesWithBatch(
            candidate.id,
            batch,
            localRules,
          ),
        );
        return {candidate.id: update};
      });
    }
  }

  Future<List<Rule>> localRules(int profileId) =>
      database.rulesDao.queryProfileRules(profileId).get();

  Future<List<Rule>> copyLocalRules(
    int sourceId,
    int targetId,
    Map<String, String> mapping,
  ) async {
    final rules = [...await localRules(targetId)];
    final existing = rules.map((rule) => rule.rawValue).toSet();
    for (final rule in await localRules(sourceId)) {
      final copy = rule.copyWith(
        id: snowflake.id,
        ruleTarget: mapping[rule.ruleTarget] ?? rule.ruleTarget,
      );
      if (existing.add(copy.rawValue)) rules.add(copy);
    }
    return rules;
  }

  Future<void> saveIndependentCopy(
    Profile candidate, {
    required Set<String> subscriptionIds,
    required Set<String> ruleIds,
    required bool copyScript,
    List<Rule>? localRules,
  }) async {
    final cleanup = <Future<void> Function()>[];
    try {
      final subscriptions = <SubscriptionBinding>[];
      final subscriptionCopies = <int, int>{};
      for (final binding in candidate.overrides.subscriptions) {
        if (!subscriptionIds.contains(binding.id)) {
          subscriptions.add(binding);
          continue;
        }
        var id = subscriptionCopies[binding.sourceId];
        if (id == null) {
          final original = ref
              .read(profilesProvider)
              .getProfile(binding.sourceId);
          if (original == null) {
            throw MessageException(
              currentAppLocalizations.bindingSourceMissing(binding.name),
            );
          }
          final copy = Profile.normal(
            label: original.realLabel,
            url: original.url,
          ).copyWith(ageSecretKey: original.ageSecretKey);
          cleanup.add(() async {
            await ref.read(profilesProvider.notifier).del(copy.id);
            await (await copy.file).safeDelete();
          });
          final saved = await copy.saveFile(
            await (await original.file).readAsBytes(),
            validate: (path, key) =>
                ref.read(coreHandlerProvider).validateProfile(path, key),
          );
          final sourceCache = Directory(
            join(
              await appPath.profilesPath,
              providersDirectoryName,
              original.id.toString(),
              proxiesProviderDirectoryName,
            ),
          );
          final copyCache = Directory(
            join(
              await appPath.profilesPath,
              providersDirectoryName,
              saved.id.toString(),
              proxiesProviderDirectoryName,
            ),
          );
          cleanup.add(() async {
            if (await copyCache.exists()) {
              await copyCache.delete(recursive: true);
            }
          });
          if (await sourceCache.exists()) {
            await copyCache.create(recursive: true);
            await for (final file in sourceCache.list()) {
              if (file is File) {
                await file.copy(join(copyCache.path, basename(file.path)));
              }
            }
          }
          ref.read(profilesProvider.notifier).put(saved);
          id = saved.id;
          subscriptionCopies[binding.sourceId] = id;
        }
        subscriptions.add(binding.copyWith(sourceId: id));
      }
      final rules = <RuleSetBinding>[];
      final ruleCopies = <int, int>{};
      final providers = [...await ref.read(clashProvidersProvider.future)];
      for (final binding in candidate.overrides.ruleBindings) {
        if (!ruleIds.contains(binding.id)) {
          rules.add(binding);
          continue;
        }
        var id = ruleCopies[binding.sourceId];
        if (id == null) {
          final original = providers
              .where((item) => item.id == binding.sourceId)
              .firstOrNull;
          if (original == null) {
            throw MessageException(
              currentAppLocalizations.bindingSourceMissing(
                binding.sourceId.toString(),
              ),
            );
          }
          final copy = original.copyWith(
            id: snowflake.id,
            label: uniqueLabelFor(
              original.label,
              fallback: original.label,
              taken: (name) => providers.any((item) => item.label == name),
            ),
          );
          cleanup.add(() async {
            ref.read(clashProvidersProvider.notifier).del(copy.id);
            await File(await copy.path).safeDelete();
            await File(await copy.compiledPath).safeDelete();
          });
          final saved = await ref
              .read(clashProvidersActionProvider.notifier)
              .putProvider(
                copy,
                content: await File(await original.path).readAsBytes(),
              );
          providers.add(saved);
          id = saved.id;
          ruleCopies[binding.sourceId] = id;
        }
        rules.add(binding.copyWith(sourceId: id));
      }
      var scriptId = candidate.scriptId;
      if (copyScript && scriptId != null) {
        final script = (await ref.read(scriptsProvider.future)).get(scriptId);
        if (script == null) {
          throw MessageException(
            currentAppLocalizations.bindingSourceMissing(scriptId.toString()),
          );
        }
        final content = await script.content;
        if (content == null) {
          throw MessageException(
            currentAppLocalizations.bindingSourceMissing(script.label),
          );
        }
        final copy = Script.create(label: script.label, url: script.url);
        cleanup.add(() async {
          ref.read(scriptsProvider.notifier).del(copy.id);
          await File(
            await appPath.getScriptPath(copy.id.toString()),
          ).safeDelete();
        });
        final saved = await copy.save(content);
        ref.read(scriptsProvider.notifier).put(saved);
        scriptId = saved.id;
      }
      await save(
        candidate.copyWith(
          scriptId: scriptId,
          overrides: candidate.overrides.copyWith(
            subscriptions: subscriptions,
            ruleBindings: rules,
          ),
        ),
        localRules: localRules,
      );
    } catch (_) {
      for (final undo in cleanup.reversed) {
        try {
          await undo();
        } catch (error) {
          commonPrint.log(
            'binding copy cleanup: ${compactError(error)}',
            logLevel: LogLevel.warning,
          );
        }
      }
      rethrow;
    }
  }
}
