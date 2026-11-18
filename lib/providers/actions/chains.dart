part of '../action.dart';

@riverpod
Future<bool> profileInputsApplied(Ref ref, int profileId) async {
  ref.watch(patchClashConfigProvider);
  ref.watch(networkSettingProvider);
  if (ref.watch(currentProfileIdProvider) != profileId) return false;
  await ref.watch(setupStateProvider(profileId).future);
  if (!ref.mounted) return false;
  return ref.read(setupActionProvider.notifier).inputsApplied();
}

@Riverpod(keepAlive: true)
class ChainAction extends _$ChainAction {
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
        !await ref.read(profileInputsAppliedProvider(profileId).future)) {
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

  Future<ClashConfig> inventory(int profileId) async {
    final profile = ref.read(profileProvider(profileId));
    if (profile == null) throw StateError('Profile no longer exists');
    if (profile.type == ProfileType.custom) {
      return ClashConfig(
        proxies: [
          for (final node in await database.customProxiesDao.query().get())
            Proxy(name: node.name, type: node.type),
        ],
        proxyGroups: await database.proxyGroupsDao.query(profileId).get(),
      );
    }
    await ref
        .read(profilesActionProvider.notifier)
        .rebuildBundleIfMissing(profile);
    var raw = await ref.read(coreHandlerProvider).readConfig(profileId);
    if (profile.subscriptionOverrideEnabled) {
      if (profile.extendType == ExtendType.managed) {
        final managed = ref.read(managedSettingProvider);
        final prepared = await ManagedScript.prepare(managed);
        final options = {
          ...prepared.customOptions,
          ...profile.overrides.scriptOptions,
        };
        raw = await handleEvaluate(
          prepared.content,
          raw,
          customOptions: options,
        );
        if (managed.smartAutoGroups) {
          raw = ManagedScript.applySmartAutoGroups(raw);
        }
      } else if (profile.extendType == ExtendType.script &&
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
        if (content.isNotEmpty) {
          final defaults =
              ref.read(scriptCustomOptionsProvider)[script.id.toString()] ??
              const <String, bool>{};
          raw = await handleEvaluate(
            content,
            raw,
            customOptions: {...defaults, ...profile.overrides.scriptOptions},
          );
        }
      }
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

  Future<BuiltProfile> preview(Profile candidate) async {
    final original = await ref.read(setupStateProvider(candidate.id).future);
    final managed = candidate.type == ProfileType.custom
        ? candidate.overrides
        : candidate.overrides.copyWith(
            dns: original.overrides.dns,
            dnsOverrideKeys: original.overrides.dnsOverrideKeys,
            tun: original.overrides.tun,
            tunOverrideKeys: original.overrides.tunOverrideKeys,
          );
    final state = original.copyWith(
      overrides: managed.copyWith(
        chains: candidate.overrides.chainsEnabled
            ? candidate.overrides.chains
            : const [],
      ),
    );
    return ref
        .read(setupActionProvider.notifier)
        .getProfile(
          setupState: state,
          patchConfig: ref.read(patchClashConfigProvider),
        );
  }

  Future<void> validate(Profile candidate) async {
    final built = await preview(candidate);
    final text = built.base == null
        ? built.yaml
        : await ref.read(coreHandlerProvider).buildProfile(built.base!);
    final error = await ref
        .read(coreHandlerProvider)
        .validateConfigWithData(utf8.encode(text));
    if (error != null && error.isNotEmpty) throw MessageException(error);
  }

  Future<void> save(Profile candidate) async {
    final before = ref.read(profileProvider(candidate.id));
    await validate(candidate);
    final latest = ref.read(profileProvider(candidate.id));
    if (latest == null) throw StateError('Profile no longer exists');
    if (latest.overrides != before?.overrides) {
      throw MessageException(currentAppLocalizations.bindingChanged);
    }
    await ref
        .read(profilesProvider.notifier)
        .updateProfileAndWait(
          candidate.id,
          (value) => value.copyWith(overrides: candidate.overrides),
        );
  }
}
