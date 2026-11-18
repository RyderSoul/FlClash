part of '../state.dart';

@riverpod
ProfilesState profilesState(Ref ref) {
  final currentProfileId = ref.watch(currentProfileIdProvider);
  final profiles = ref.watch(profilesProvider);
  return ProfilesState(profiles: profiles, currentProfileId: currentProfileId);
}

@riverpod
Profile? currentProfile(Ref ref) {
  final profileId = ref.watch(currentProfileIdProvider);
  return ref.watch(
    profilesProvider.select((state) => state.getProfile(profileId)),
  );
}

@riverpod
Profile? profile(Ref ref, int? profileId) {
  return ref.watch(
    profilesProvider.select((state) => state.getProfile(profileId)),
  );
}

@riverpod
ExtendType extendType(Ref ref, int? profileId) {
  return ref.watch(
    profileProvider(
      profileId,
    ).select((state) => state?.extendType ?? ExtendType.standard),
  );
}

@riverpod
Future<ClashConfig> clashConfig(Ref ref, int profileId) async {
  final type = ref.read(profileProvider(profileId))?.type;
  if (type == ProfileType.custom) {
    return const ClashConfig();
  }
  final outbounds = await ref
      .read(coreHandlerProvider)
      .getProfileOutbounds(profileId);
  return clashConfigTask(outbounds);
}

@riverpod
Future<SetupState> setupState(Ref ref, int? profileId) async {
  final profile = ref.watch(profileProvider(profileId));
  final scriptId = profile?.scriptId;
  final profileLastUpdateDate = profile?.lastUpdateDate?.millisecondsSinceEpoch;
  final profileType = profile?.type ?? ProfileType.file;
  final extendType = profile?.extendType ?? ExtendType.standard;
  final overrides = profileType == ProfileType.custom
      ? ref.watch(
          patchClashConfigProvider.select(
            (state) => (profile?.overrides ?? const ProfileOverrides())
                .overAppTun(state.tunOverride, state.tunOverrideKeys),
          ),
        )
      : ref.watch(
          patchClashConfigProvider.select(
            (state) => ProfileOverrides(
              rulesEnabled: profile?.overrides.rulesEnabled,
              subscriptionEnabled: profile?.overrides.subscriptionEnabled,
              replaceRules: profile?.overrides.replaceRules ?? false,
              chains: profile?.overrides.chains ?? const [],
              chainsEnabled: profile?.overrides.chainsEnabled ?? true,
              bundle: profile?.overrides.bundle,
              scriptOptions: profile?.overrides.scriptOptions ?? const {},
              dns: state.dns,
              dnsOverrideKeys: state.dnsOverrideKeys.intersection(
                DnsOverrideKey.normalProfileKeys,
              ),
              tun: state.tunOverride,
              tunOverrideKeys: state.tunOverrideKeys,
            ),
          ),
        );
  final allProfileProviders = ref.watch(profileProvidersProvider);
  final watchedManagedProps =
      profileType != ProfileType.custom &&
          profile?.subscriptionOverrideEnabled == true &&
          extendType == ExtendType.managed
      ? ref.watch(managedSettingProvider)
      : null;
  final watchedScriptOptions =
      profileType != ProfileType.custom &&
          profile?.subscriptionOverrideEnabled == true &&
          extendType == ExtendType.script &&
          scriptId != null
      ? ref.watch(
          scriptCustomOptionsProvider.select(
            (map) => map[scriptId.toString()] ?? const <String, bool>{},
          ),
        )
      : const <String, bool>{};
  final mitmModules =
      mitmFeature &&
          ref.watch(
            patchClashConfigProvider.select((state) => state.mitm.enable),
          )
      ? ref.watch(mitmModulesProvider.future)
      : null;
  List<ProxyGroup> proxyGroups = [];
  List<Rule> rules = [];
  List<Rule> addedRules = [];
  List<ClashProvider> clashProviders = [];
  Map<String, int> profileProviders = const {};
  List<CustomProxy> appProxies = [];
  Map<int, String> proxyDialers = const {};
  Script? script;
  ManagedProps? managedProps;
  Map<String, bool> scriptCustomOptions = const {};
  if (profileId != null) {
    if (profileType == ProfileType.custom) {
      rules = await database.rulesDao.queryProfileRules(profileId).get();
      proxyGroups = await database.proxyGroupsDao.query(profileId).get();
      clashProviders = await database.clashProvidersDao.query().get();
      profileProviders = allProfileProviders;
      appProxies = await database.customProxiesDao.query().get();
      proxyDialers = {
        for (final dialer
            in await database.proxyDialersDao.query(profileId).get())
          dialer.proxyId: dialer.target,
      };
    } else {
      if (profile?.rulesOverrideEnabled == true) {
        addedRules = await database.rulesDao.queryAddedRules(profileId).get();
      }
      if (profile?.subscriptionOverrideEnabled == true) {
        if (extendType == ExtendType.managed) {
          managedProps = watchedManagedProps;
        } else if (extendType == ExtendType.script && scriptId != null) {
          scriptCustomOptions = watchedScriptOptions;
          script = await database.scriptsDao.get(scriptId).getSingleOrNull();
          if (script == null) {
            throw MessageException(
              currentAppLocalizations.bindingSourceMissing(scriptId.toString()),
            );
          }
        }
      }
    }
  }
  return SetupState(
    mitmModules: mitmModules == null
        ? const []
        : await mitmModuleSources(await mitmModules),
    clashProviders: clashProviders,
    profileProviders: profileProviders,
    appProxies: appProxies,
    proxyDialers: proxyDialers,
    rules: rules,
    proxyGroups: proxyGroups,
    profileId: profileId,
    profileLastUpdateDate: profileLastUpdateDate,
    profileType: profileType,
    extendType: extendType,
    addedRules: addedRules,
    script: script,
    managedProps: managedProps,
    scriptCustomOptions: scriptCustomOptions,
    overrides: overrides.copyWith(
      chains: overrides.chainsEnabled ? overrides.chains : const [],
      replaceRules:
          profileType != ProfileType.custom &&
          profile?.rulesOverrideEnabled == true &&
          overrides.replaceRules,
    ),
    matchTarget:
        profileType != ProfileType.custom &&
            profile?.rulesOverrideEnabled == true
        ? profile?.matchTarget
        : null,
  );
}

/// A module whose content is not on disk yet adds nothing until it downloads.
Future<List<MitmModuleSource>> mitmModuleSources(
  Iterable<MitmModule> modules,
) async {
  final directory = await appPath.mitmModulesDirPath;
  final sources = <MitmModuleSource>[];
  for (final module in modules) {
    if (!module.enabled) {
      continue;
    }
    final file = File(join(directory, module.fileName));
    if (!await file.exists()) {
      continue;
    }
    sources.add(
      MitmModuleSource(
        content: await file.readAsString(),
        arguments: module.arguments,
        resources: module.resources,
      ),
    );
  }
  return sources;
}

/// Subscription profiles double as proxy providers for custom profiles.
@riverpod
Map<String, int> profileProviders(Ref ref) {
  final profiles = ref.watch(profilesProvider);
  return {
    for (final profile in profiles)
      if (profile.type != ProfileType.custom) profile.realLabel: profile.id,
  };
}
