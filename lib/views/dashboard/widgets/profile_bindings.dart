import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/profiles/bindings/manager.dart';
import 'package:fl_clash/views/profiles/bindings/status.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';

class ProfileBindingsCard extends ConsumerStatefulWidget {
  const ProfileBindingsCard({super.key});
  @override
  ConsumerState<ProfileBindingsCard> createState() =>
      _ProfileBindingsCardState();
}

class _ProfileBindingsCardState extends ConsumerState<ProfileBindingsCard> {
  String? _busyKey;

  Future<void> _toggle(
    String key,
    Profile profile,
    ProfileOverrides overrides,
  ) async {
    if (_busyKey != null) return;
    setState(() => _busyKey = key);
    try {
      await globalState.safeRun(() async {
        await ref
            .read(profileBindingsActionProvider.notifier)
            .save(profile.copyWith(overrides: overrides));
        final applied = await ref
            .read(setupActionProvider.notifier)
            .applyProfile();
        if (!applied) {
          throw MessageException(currentAppLocalizations.bindingApplyFailed);
        }
      });
    } finally {
      if (mounted) setState(() => _busyKey = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = context.appLocalizations;
    final profile = ref.watch(currentProfileProvider);
    final data = profile?.overrides ?? const ProfileOverrides();
    final sources = ref.watch(profilesProvider);
    final ruleSources = ref.watch(clashProvidersProvider).value;
    final scripts = ref.watch(scriptsProvider).value;
    final missing = <String>{
      for (final binding in data.subscriptions)
        if (sources.getProfile(binding.sourceId) == null) binding.name,
      if (ruleSources != null)
        for (final binding in data.ruleBindings)
          if (!ruleSources.any((source) => source.id == binding.sourceId))
            binding.sourceId.toString(),
      if (profile?.scriptId != null &&
          scripts != null &&
          scripts.get(profile!.scriptId) == null)
        labels.script,
    };

    final metrics =
        <
          ({
            String key,
            String title,
            Glyph glyph,
            int count,
            bool enabled,
            ProfileOverrides Function(bool) update,
          })
        >[
          (
            key: 'rules',
            title: labels.bindingRuleSources,
            glyph: AppGlyphs.rules,
            count: data.ruleBindings.length,
            enabled: profile?.rulesOverrideEnabled ?? false,
            update: (value) => data.copyWith(rulesEnabled: value),
          ),
          (
            key: 'attachments',
            title: labels.attachedSubscriptions,
            glyph: AppGlyphs.link,
            count: data.subscriptions.length,
            enabled: data.attachmentsEnabled,
            update: (value) => data.copyWith(attachmentsEnabled: value),
          ),
          (
            key: 'script',
            title: labels.script,
            glyph: AppGlyphs.code,
            count: profile?.scriptId == null ? 0 : 1,
            enabled: profile?.subscriptionOverrideEnabled ?? false,
            update: (value) => data.copyWith(subscriptionEnabled: value),
          ),
          (
            key: 'chains',
            title: labels.proxyChains,
            glyph: AppGlyphs.layers,
            count: data.chains.length,
            enabled: data.chainsEnabled,
            update: (value) => data.copyWith(chainsEnabled: value),
          ),
        ];
    return DashboardCard(
      semanticLabel: labels.profileManagement,
      onTap: profile == null
          ? null
          : () => BaseNavigator.push(
              context,
              ProfileBindingsView(profileId: profile.id),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.puzzle,
            title: labels.profileManagement,
            chevron: true,
          ),
          const SizedBox(height: 12),
          Text(
            profile?.realLabel ?? labels.nullProfileDesc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.headline.of(context),
          ),
          if (profile != null) ...[
            const SizedBox(height: 6),
            ProfileBindingApplyStatus(profileId: profile.id),
          ],
          const SizedBox(height: 12),
          for (final metric in metrics)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  GlyphIcon(
                    metric.glyph,
                    size: 20,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      metric.title,
                      style: DashboardText.label(context),
                    ),
                  ),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${metric.count}',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.headline.of(context).toTabular,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: metric.enabled,
                    onChanged: profile == null || _busyKey == metric.key
                        ? null
                        : (value) => _toggle(
                            metric.key,
                            profile,
                            metric.update(value),
                          ),
                  ),
                ],
              ),
            ),
          if (missing.isNotEmpty)
            Text(
              labels.bindingSourceMissing(missing.join(' / ')),
              style: DashboardText.label(
                context,
              ).copyWith(color: context.colorScheme.error),
            ),
          const SizedBox(height: 8),
          Text(
            labels.bindingDashboardHint,
            style: DashboardText.label(context),
          ),
        ],
      ),
    );
  }
}
