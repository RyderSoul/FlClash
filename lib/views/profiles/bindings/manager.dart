import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/config/providers.dart';
import 'package:fl_clash/views/config/scripts.dart';
import 'package:fl_clash/views/profiles/extend/chains.dart';
import 'package:fl_clash/views/profiles/extend/extend.dart';
import 'package:fl_clash/views/profiles/profiles.dart';
import 'package:fl_clash/views/profiles/edit.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'copy.dart';
import 'forms.dart';
import 'status.dart';

class ProfileBindingsView extends ConsumerStatefulWidget {
  const ProfileBindingsView({super.key, required this.profileId});
  final int profileId;
  @override
  ConsumerState<ProfileBindingsView> createState() =>
      _ProfileBindingsViewState();
}

class _ProfileBindingsViewState extends ConsumerState<ProfileBindingsView> {
  String? _error;
  bool _busy = false;
  Object? _busyKey;

  Future<void> _run(Future<void> Function() operation, {Object? key}) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _busyKey = key;
      _error = null;
    });
    try {
      await operation();
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _busyKey = null;
        });
      }
    }
  }

  Future<void> _change(Profile Function(Profile) change, {Object? key}) =>
      _run(() async {
        final profile = ref.read(profileProvider(widget.profileId));
        if (profile == null) return;
        await ref
            .read(profileBindingsActionProvider.notifier)
            .save(change(profile));
      }, key: key);

  Future<void> _apply() => _run(() async {
    final candidate = ref.read(profileProvider(widget.profileId));
    if (candidate == null) return;
    final labels = context.appLocalizations;
    await ref.read(profileBindingsActionProvider.notifier).validate(candidate);
    if (!mounted) return;
    if (ref.read(currentProfileIdProvider) != widget.profileId) {
      dialogs.showBanner(labels.bindingValidated, level: BannerLevel.success);
      return;
    }
    final applied = await ref.read(setupActionProvider.notifier).applyProfile();
    if (!applied) {
      throw MessageException(labels.bindingApplyFailed);
    }
    dialogs.showBanner(labels.applied, level: BannerLevel.success);
  });

  Future<void> _open(Widget page) async {
    await BaseNavigator.push(context, page);
  }

  Widget _section({required List<Widget> items}) => generateGroup(items);

  Widget _toggle(
    Object key,
    String title,
    String subtitle,
    Glyph glyph,
    bool value,
    Profile Function(Profile, bool) update,
  ) => ListItem.toggle(
    leading: GlyphIcon(glyph, size: 22),
    horizontalTitleGap: 12,
    title: Text(title, style: AppTextStyle.headline.of(context)),
    subtitle: Text(subtitle),
    value: value,
    onChanged: _busy && _busyKey == key
        ? null
        : (next) => _change((profile) => update(profile, next), key: key),
  );

  Widget _action(String label, Glyph glyph, VoidCallback onPressed) => ListItem(
    leading: GlyphIcon(glyph, size: 22),
    horizontalTitleGap: 12,
    title: Text(label),
    trailing: const GlyphIcon(AppGlyphs.chevronForward, size: 18),
    onTap: _busy ? null : onPressed,
  );

  @override
  Widget build(BuildContext context) {
    final labels = context.appLocalizations;
    final profile = ref.watch(profileProvider(widget.profileId));
    final rules =
        ref.watch(clashProvidersProvider).value ?? const <ClashProvider>[];
    final scripts = ref.watch(scriptsProvider).value ?? const <Script>[];
    final sources = ref.watch(profilesProvider);
    if (profile == null) {
      return Scaffold(
        title: labels.profileManagement,
        body: const SizedBox.shrink(),
      );
    }
    final overrides = profile.overrides;
    return Scaffold(
      title: labels.profileManagement,
      isLoading: _busy,
      primaryAction: IconButtonData(
        glyph: AppGlyphs.check,
        tooltip: labels.applyNow,
        isLoading: _busy,
        onPressed: _busy ? null : _apply,
      ),
      menuItems: [
        PopupMenuItem(
          glyph: AppGlyphs.copy,
          label: labels.bindingApplyToProfiles,
          onPressed: () => _open(CopyBindingsView(profileId: profile.id)),
        ),
        PopupMenuItem(
          glyph: AppGlyphs.layers,
          label: labels.bindingLibrary,
          onPressed: () => _open(const BindingLibraryView()),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16).copyWith(
          top: context.contentTopPadding,
          bottom: 24 + context.bottomInset,
        ),
        children: [
          Card(
            radius: AppCorner.xl,
            padding: const EdgeInsets.all(20),
            inert: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                Text(
                  profile.realLabel,
                  style: AppTextStyle.title2.of(context, emphasized: true),
                ),
                ProfileBindingApplyStatus(profileId: profile.id),
                Text(
                  labels.bindingApplyHint,
                  style: AppTextStyle.footnote
                      .of(context)
                      .copyWith(color: context.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          ErrorBanner(message: _error),
          const SizedBox(height: 16),
          _section(
            items: [
              _toggle(
                'attachments',
                labels.attachedSubscriptions,
                labels.bindingSubscriptionsEnabled,
                AppGlyphs.link,
                overrides.attachmentsEnabled,
                (p, enabled) => p.copyWith(
                  overrides: p.overrides.copyWith(attachmentsEnabled: enabled),
                ),
              ),
              for (final binding in overrides.subscriptions)
                ContextMenuRegion(
                  menuItems: [
                    PopupMenuItem(
                      glyph: AppGlyphs.edit,
                      label: labels.edit,
                      onPressed: () async {
                        await editSubscriptionBinding(
                          context,
                          profile.id,
                          binding,
                        );
                      },
                    ),
                    PopupMenuItem(
                      glyph: AppGlyphs.sync,
                      label: labels.update,
                      onPressed: () => _run(() async {
                        final source = sources.getProfile(binding.sourceId);
                        if (source == null) {
                          throw MessageException(
                            labels.bindingSourceMissing(binding.name),
                          );
                        }
                        await ref
                            .read(profilesActionProvider.notifier)
                            .updateProfile(source, showLoading: true);
                      }),
                    ),
                    PopupMenuItem(
                      glyph: AppGlyphs.delete,
                      label: labels.delete,
                      danger: true,
                      onPressed: () => _change(
                        (p) => p.copyWith(
                          overrides: p.overrides.copyWith(
                            subscriptions: p.overrides.subscriptions
                                .where((item) => item.id != binding.id)
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                  child: ListItem.toggle(
                    leading: const SizedBox.square(dimension: 22),
                    horizontalTitleGap: 12,
                    title: Text(binding.name),
                    subtitle: Text(
                      sources.getProfile(binding.sourceId) == null
                          ? labels.bindingSourceMissing(binding.name)
                          : [
                              '${sources.getProfile(binding.sourceId)!.realLabel} · ${sources.getProfile(binding.sourceId)!.lastUpdateDate?.show ?? labels.none}',
                              if (binding.attachments.isNotEmpty)
                                binding.attachments
                                    .map(
                                      (item) =>
                                          '${item.target} · ${item.mode == SubscriptionAttachMode.nodes ? labels.bindingExpandNodes : labels.bindingReferenceGroup}',
                                    )
                                    .join(' / '),
                            ].join('\n'),
                    ),
                    value: binding.enabled,
                    onChanged: _busy && _busyKey == ('subscription', binding.id)
                        ? null
                        : (enabled) => _change(
                            (p) => p.copyWith(
                              overrides: p.overrides.copyWith(
                                subscriptions: [
                                  for (final item in p.overrides.subscriptions)
                                    item.id == binding.id
                                        ? item.copyWith(enabled: enabled)
                                        : item,
                                ],
                              ),
                            ),
                            key: ('subscription', binding.id),
                          ),
                  ),
                ),
              _action(
                labels.add,
                AppGlyphs.add,
                () => editSubscriptionBinding(context, profile.id),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _section(
            items: [
              _toggle(
                'rules',
                labels.bindingRuleSources,
                labels.rulesOverrideEnabled,
                AppGlyphs.rules,
                profile.rulesOverrideEnabled,
                (p, enabled) => p.copyWith(
                  overrides: p.overrides.copyWith(rulesEnabled: enabled),
                ),
              ),
              for (final binding in overrides.ruleBindings)
                ContextMenuRegion(
                  menuItems: [
                    PopupMenuItem(
                      glyph: AppGlyphs.edit,
                      label: labels.edit,
                      onPressed: () =>
                          editRuleBinding(context, profile.id, binding),
                    ),
                    PopupMenuItem(
                      glyph: AppGlyphs.sync,
                      label: labels.update,
                      onPressed: () => _run(() async {
                        final source = rules
                            .where((item) => item.id == binding.sourceId)
                            .firstOrNull;
                        if (source == null) {
                          throw MessageException(
                            labels.bindingSourceMissing(
                              binding.sourceId.toString(),
                            ),
                          );
                        }
                        await ref
                            .read(resourcesActionProvider.notifier)
                            .updateRuleProvider(source);
                      }),
                    ),
                    PopupMenuItem(
                      glyph: AppGlyphs.delete,
                      label: labels.delete,
                      danger: true,
                      onPressed: () => _change(
                        (p) => p.copyWith(
                          overrides: p.overrides.copyWith(
                            ruleBindings: p.overrides.ruleBindings
                                .where((item) => item.id != binding.id)
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                  child: ListItem.toggle(
                    leading: const SizedBox.square(dimension: 22),
                    horizontalTitleGap: 12,
                    title: Text(
                      rules
                              .where((item) => item.id == binding.sourceId)
                              .firstOrNull
                              ?.label ??
                          labels.bindingSourceMissing(
                            binding.sourceId.toString(),
                          ),
                    ),
                    subtitle: Text(binding.target),
                    value: binding.enabled,
                    onChanged: _busy && _busyKey == ('rule', binding.id)
                        ? null
                        : (enabled) => _change(
                            (p) => p.copyWith(
                              overrides: p.overrides.copyWith(
                                ruleBindings: [
                                  for (final item in p.overrides.ruleBindings)
                                    item.id == binding.id
                                        ? item.copyWith(enabled: enabled)
                                        : item,
                                ],
                              ),
                            ),
                            key: ('rule', binding.id),
                          ),
                  ),
                ),
              _action(
                labels.add,
                AppGlyphs.add,
                () => editRuleBinding(context, profile.id),
              ),
              if (profile.type != ProfileType.custom)
                _action(
                  labels.bindingLocalRules,
                  AppGlyphs.rules,
                  () => _open(ExtendView(profileId: profile.id)),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _section(
            items: [
              _toggle(
                'script',
                labels.script,
                labels.subscriptionOverrideEnabled,
                AppGlyphs.code,
                profile.subscriptionOverrideEnabled,
                (p, enabled) => p.copyWith(
                  overrides: p.overrides.copyWith(subscriptionEnabled: enabled),
                ),
              ),
              ListItem<int?>.options(
                leading: const SizedBox.square(dimension: 22),
                horizontalTitleGap: 12,
                title: Text(labels.script),
                value: profile.scriptId,
                options: [null, ...scripts.map((item) => item.id)],
                textBuilder: (id) => scripts.get(id)?.label ?? labels.none,
                onChanged: (id) => _change((p) => p.copyWith(scriptId: id)),
              ),
              _action(
                labels.goToConfigureScript,
                AppGlyphs.code,
                () => _open(const ScriptsView()),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _section(
            items: [
              _toggle(
                'chains',
                labels.proxyChains,
                labels.bindingChainsEnabled,
                AppGlyphs.layers,
                overrides.chainsEnabled,
                (p, enabled) => p.copyWith(
                  overrides: p.overrides.copyWith(chainsEnabled: enabled),
                ),
              ),
              for (final chain in overrides.chains)
                ListItem(
                  leading: const SizedBox.square(dimension: 22),
                  horizontalTitleGap: 12,
                  title: Text(chain.name),
                  subtitle: Text(
                    [
                      chain.hops.join(' → '),
                      if (chain.targets.isNotEmpty) chain.targets.join(' / '),
                    ].join('\n'),
                  ),
                  onTap: () => _open(ProxyChainsView(profileId: profile.id)),
                ),
              _action(
                labels.proxyChains,
                AppGlyphs.layers,
                () => _open(ProxyChainsView(profileId: profile.id)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BindingLibraryView extends ConsumerWidget {
  const BindingLibraryView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.appLocalizations;
    final profiles = ref
        .watch(profilesProvider)
        .where((profile) => profile.type != ProfileType.custom)
        .toList();
    return Scaffold(
      title: labels.bindingLibrary,
      primaryAction: IconButtonData(
        glyph: AppGlyphs.addCircle,
        tooltip: labels.importUrl,
        onPressed: () => importBindingSubscription(context, ref),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16).copyWith(
          top: context.contentTopPadding,
          bottom: 24 + context.bottomInset,
        ),
        children: [
          Text(
            labels.bindingLibraryHint,
            style: AppTextStyle.footnote.of(context),
          ),
          const SizedBox(height: 16),
          generateSection(
            title: labels.attachedSubscriptions,
            items: [
              for (final profile in profiles)
                ProfileItem(
                  profile: profile,
                  groupValue: null,
                  onChanged: (_) => showExtend(
                    context,
                    builder: (_) => EditProfileView(profile: profile),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          generateGroup([
            ListItem(
              title: Text(labels.ruleProviders),
              onTap: () =>
                  BaseNavigator.push(context, const ClashProvidersView()),
            ),
            ListItem(
              title: Text(labels.script),
              onTap: () => BaseNavigator.push(context, const ScriptsView()),
            ),
          ]),
        ],
      ),
    );
  }
}
