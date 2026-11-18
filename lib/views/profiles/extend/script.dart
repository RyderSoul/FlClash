import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/views/config/scripts.dart';
import 'package:fl_clash/views/profiles/script_options.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScriptContent extends ConsumerWidget {
  const ScriptContent({super.key});

  void _handleChange(WidgetRef ref, int profileId, int scriptId) {
    ref.read(profilesProvider.notifier).updateProfile(profileId, (state) {
      return state.copyWith(
        scriptId: state.scriptId == scriptId ? null : scriptId,
      );
    });
  }

  @override
  Widget build(BuildContext context, ref) {
    final appLocalizations = context.appLocalizations;
    final profileId = ProfileIdProvider.of(context)!.profileId;
    final profile = ref.watch(profileProvider(profileId));
    final scriptId = profile?.scriptId;
    final scripts = ref.watch(scriptsProvider).value ?? [];
    final selectedScript = scripts
        .where((item) => item.id == scriptId)
        .firstOrNull;
    final scriptDefaults = scriptId == null
        ? const <String, bool>{}
        : ref.watch(
            scriptCustomOptionsProvider.select(
              (map) => map[scriptId.toString()] ?? const <String, bool>{},
            ),
          );
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListHeader(title: appLocalizations.extendScript),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: generateGroup([
              for (final script in scripts)
                _ScriptOption(
                  label: script.label,
                  isSelected: script.id == scriptId,
                  onSelected: () {
                    _handleChange(ref, profileId, script.id);
                  },
                ),
            ]),
          ),
        ),
        if (selectedScript != null && profile != null) ...[
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
          SliverToBoxAdapter(
            child: MoreActionButton(
              label: appLocalizations.scriptOptions,
              onPressed: () {
                BaseNavigator.push(
                  context,
                  ScriptOptionsView(
                    title: selectedScript.label,
                    loadScript: () => selectedScript.content,
                    initialValues: profile.overrides.scriptOptions,
                    defaultsLabel: scriptDefaults,
                    onChanged: (next) {
                      ref
                          .read(profilesProvider.notifier)
                          .updateProfile(
                            profileId,
                            (state) => state.copyWith(
                              overrides: state.overrides.copyWith(
                                scriptOptions: next,
                              ),
                            ),
                          );
                    },
                  ),
                );
              },
            ),
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        SliverToBoxAdapter(
          child: MoreActionButton(
            label: appLocalizations.goToConfigureScript,
            onPressed: () {
              showInSheet<void>(context, builder: (_) => const ScriptsView());
            },
          ),
        ),
      ],
    );
  }
}

class _ScriptOption extends StatelessWidget {
  const _ScriptOption({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return DecorationListItem(
      isSelected: isSelected,
      title: Text(label),
      trailing: isSelected ? const SelectionCheck() : null,
      onPressed: onSelected,
    );
  }
}
