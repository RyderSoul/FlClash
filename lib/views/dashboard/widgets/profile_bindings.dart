import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/views/profiles/bindings/manager.dart';
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
  bool _busy = false;

  Future<void> _toggle(Profile profile, ProfileOverrides overrides) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await globalState.safeRun(() async {
        await ref
            .read(profileBindingsActionProvider.notifier)
            .save(profile.copyWith(overrides: overrides));
        final applied = await ref
            .read(setupActionProvider.notifier)
            .applyProfile();
        if (!applied)
          throw MessageException(currentAppLocalizations.bindingApplyFailed);
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = context.appLocalizations;
    final profile = ref.watch(currentProfileProvider);
    final data = profile?.overrides ?? const ProfileOverrides();
    final metrics =
        <
          ({
            String title,
            int count,
            bool enabled,
            ProfileOverrides Function(bool) update,
          })
        >[
          (
            title: labels.bindingRuleSources,
            count: data.ruleBindings.length,
            enabled: profile?.rulesOverrideEnabled ?? false,
            update: (value) => data.copyWith(rulesEnabled: value),
          ),
          (
            title: labels.attachedSubscriptions,
            count: data.subscriptions.length,
            enabled: data.attachmentsEnabled,
            update: (value) => data.copyWith(attachmentsEnabled: value),
          ),
          (
            title: labels.script,
            count: profile?.scriptId == null ? 0 : 1,
            enabled: profile?.subscriptionOverrideEnabled ?? false,
            update: (value) => data.copyWith(subscriptionEnabled: value),
          ),
          (
            title: labels.proxyChains,
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
            style: DashboardText.label(context),
          ),
          if (profile != null)
            Text(
              ref.watch(bindingsAppliedProvider(profile.id)).value == true
                  ? labels.applied
                  : labels.bindingApplyHint,
              style: DashboardText.label(context),
            ),
          const SizedBox(height: 12),
          for (final metric in metrics)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      metric.title,
                      style: DashboardText.label(context),
                    ),
                  ),
                  Text(
                    '${metric.count}',
                    style: AppTextStyle.headline.of(context),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: metric.enabled,
                    onChanged: profile == null || _busy
                        ? null
                        : (value) => _toggle(profile, metric.update(value)),
                  ),
                ],
              ),
            ),
          Text(
            labels.bindingDashboardHint,
            style: DashboardText.label(context),
          ),
        ],
      ),
    );
  }
}
