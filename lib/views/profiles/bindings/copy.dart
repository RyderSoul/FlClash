import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CopyBindingsView extends ConsumerStatefulWidget {
  const CopyBindingsView({super.key, required this.profileId});
  final int profileId;
  @override
  ConsumerState<CopyBindingsView> createState() => _CopyBindingsViewState();
}

class _CopyBindingsViewState extends ConsumerState<CopyBindingsView> {
  int? _target;
  ClashConfig? _inventory;
  List<Rule> _sourceRules = [];
  final _mapping = <String, String>{};
  bool _independent = false;
  bool _subscriptions = true;
  bool _rules = true;
  bool _chains = true;
  bool _script = true;
  bool _saving = false;
  String? _error;

  Set<String> _references(Profile source) =>
      {
          if (_subscriptions)
            for (final binding in source.overrides.subscriptions)
              ...binding.attachments.map((item) => item.target),
          if (_rules)
            ...source.overrides.ruleBindings.map((item) => item.target),
          if (_rules) ..._sourceRules.map((item) => item.ruleTarget).nonNulls,
          if (_rules) ?source.matchTarget,
          if (_chains)
            for (final chain in source.overrides.chains) ...chain.targets,
          if (_chains)
            for (final chain in source.overrides.chains) ...chain.hops,
        }
        ..removeAll({
          'DIRECT',
          'REJECT',
          'REJECT-DROP',
          'PASS',
          'COMPATIBLE',
          'GLOBAL',
          'MATCH',
          if (_subscriptions)
            ...source.overrides.subscriptions.map((item) => item.name),
          if (_chains) ...source.overrides.chains.map((item) => item.name),
          if (_subscriptions)
            for (final binding in source.overrides.subscriptions)
              for (final chain in source.overrides.chains)
                ...chain.hops.where(
                  (name) => name.startsWith('${binding.name} · '),
                ),
        })
        ..removeWhere(
          (name) =>
              _subscriptions &&
              source.overrides.subscriptions.any(
                (binding) => name.startsWith('${binding.name} · '),
              ),
        );

  Future<void> _chooseTarget(Profile source) async {
    final profiles = ref
        .read(profilesProvider)
        .where((profile) => profile.id != source.id)
        .toList();
    final target = await showSheet<int>(
      context: context,
      builder: (_) => SelectionSheet<int>(
        title: context.appLocalizations.bindingApplyToProfiles,
        sections: [
          SelectionSection(
            items: profiles.map((profile) => profile.id).toList(),
          ),
        ],
        labelBuilder: (id) =>
            profiles.firstWhere((profile) => profile.id == id).realLabel,
        selectedOf: (_) => _target,
        onSelected: (id) => Navigator.of(context).pop(id),
      ),
    );
    if (target == null || !mounted) return;
    setState(() {
      _target = target;
      _inventory = null;
      _error = null;
      _mapping.clear();
    });
    try {
      final inventory = await ref
          .read(profileBindingsActionProvider.notifier)
          .inventory(target);
      final sourceRules = await ref
          .read(profileBindingsActionProvider.notifier)
          .localRules(source.id);
      if (!mounted || _target != target) return;
      _sourceRules = sourceRules;
      final names = {
        ...inventory.proxyGroups.map((group) => group.name),
        ...inventory.proxies.map((proxy) => proxy.name),
      };
      setState(() {
        _inventory = inventory;
        for (final name in _references(source)) {
          if (names.contains(name)) _mapping[name] = name;
        }
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  Future<void> _save(Profile source) async {
    final labels = context.appLocalizations;
    if (_target == null ||
        _inventory == null ||
        _references(source).any((name) => _mapping[name]?.isNotEmpty != true)) {
      setState(() => _error = labels.bindingMappingRequired);
      return;
    }
    if (!_subscriptions && !_rules && !_chains && !_script) {
      setState(() => _error = labels.bindingRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final target = ref.read(profileProvider(_target))!;
      String mapped(String name) => _mapping[name] ?? name;
      final original = source.overrides;
      final copied = target.copyWith(
        scriptId: _script ? source.scriptId : target.scriptId,
        matchTarget: _rules
            ? _mapping[source.matchTarget] ?? source.matchTarget
            : target.matchTarget,
        overrides: target.overrides.copyWith(
          replaceRules: _rules
              ? original.replaceRules
              : target.overrides.replaceRules,
          attachmentsEnabled: _subscriptions
              ? original.attachmentsEnabled
              : target.overrides.attachmentsEnabled,
          rulesEnabled: _rules
              ? source.rulesOverrideEnabled
              : target.rulesOverrideEnabled,
          subscriptionEnabled: _script
              ? source.subscriptionOverrideEnabled
              : target.subscriptionOverrideEnabled,
          chainsEnabled: _chains
              ? original.chainsEnabled
              : target.overrides.chainsEnabled,
          subscriptions: _subscriptions
              ? [
                  ...target.overrides.subscriptions.where(
                    (item) => !original.subscriptions.any(
                      (binding) => binding.id == item.id,
                    ),
                  ),
                  for (final binding in original.subscriptions)
                    binding.copyWith(
                      attachments: [
                        for (final item in binding.attachments)
                          item.copyWith(target: mapped(item.target)),
                      ],
                    ),
                ]
              : target.overrides.subscriptions,
          ruleBindings: _rules
              ? [
                  ...target.overrides.ruleBindings.where(
                    (item) => !original.ruleBindings.any(
                      (binding) => binding.id == item.id,
                    ),
                  ),
                  for (final binding in original.ruleBindings)
                    binding.copyWith(target: mapped(binding.target)),
                ]
              : target.overrides.ruleBindings,
          chains: _chains
              ? [
                  ...target.overrides.chains.where(
                    (item) =>
                        !original.chains.any((chain) => chain.id == item.id),
                  ),
                  for (final chain in original.chains)
                    chain.copyWith(
                      targetGroup: null,
                      targetGroups: chain.targets.map(mapped).toList(),
                      hops: chain.hops.map(mapped).toList(),
                    ),
                ]
              : target.overrides.chains,
        ),
      );
      final action = ref.read(profileBindingsActionProvider.notifier);
      final localRules = _rules
          ? await action.copyLocalRules(source.id, target.id, _mapping)
          : null;
      await action.validate(copied, localRules: localRules);
      if (_independent) {
        await action.saveIndependentCopy(
          copied,
          subscriptionIds: _subscriptions
              ? original.subscriptions.map((item) => item.id).toSet()
              : {},
          ruleIds: _rules
              ? original.ruleBindings.map((item) => item.id).toSet()
              : {},
          copyScript: _script,
          localRules: localRules,
        );
      } else {
        await action.save(copied, localRules: localRules);
      }
      if (mounted) {
        dialogs.showBanner(labels.bindingCopySaved, level: BannerLevel.success);
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = context.appLocalizations;
    final source = ref.watch(profileProvider(widget.profileId));
    if (source == null) return const SizedBox.shrink();
    final groupNames = {...?_inventory?.proxyGroups.map((group) => group.name)};
    final nodeNames = {...?_inventory?.proxies.map((node) => node.name)};
    final groupReferences = {
      if (_subscriptions)
        for (final binding in source.overrides.subscriptions)
          ...binding.attachments.map((item) => item.target),
      if (_chains)
        for (final chain in source.overrides.chains) ...chain.targets,
    };
    final nodeReferences = {
      if (_chains)
        for (final chain in source.overrides.chains) ...chain.hops.skip(1),
    };
    final references = _references(source);
    return FormPage(
      title: labels.bindingApplyToProfiles,
      saveLabel: labels.save,
      onSave: () => _save(source),
      error: _error,
      saving: _saving,
      children: [
        generateSection(
          title: labels.profile,
          items: [
            FormRow(
              title: labels.bindingTargetProfile,
              trailing: Text(
                ref.watch(profileProvider(_target))?.realLabel ?? labels.none,
              ),
              onPressed: () => _chooseTarget(source),
            ),
            ListItem.toggle(
              title: Text(labels.bindingIndependentCopy),
              subtitle: Text(labels.bindingCopyHint),
              value: _independent,
              onChanged: (value) => setState(() => _independent = value),
            ),
          ],
        ),
        generateSection(
          title: labels.bindingCopyItems,
          items: [
            ListItem.toggle(
              title: Text(labels.attachedSubscriptions),
              value: _subscriptions,
              onChanged: (value) => setState(() => _subscriptions = value),
            ),
            ListItem.toggle(
              title: Text(labels.bindingRuleSources),
              value: _rules,
              onChanged: (value) => setState(() => _rules = value),
            ),
            ListItem.toggle(
              title: Text(labels.proxyChains),
              value: _chains,
              onChanged: (value) => setState(() => _chains = value),
            ),
            ListItem.toggle(
              title: Text(labels.script),
              value: _script,
              onChanged: (value) => setState(() => _script = value),
            ),
          ],
        ),
        if (_target != null)
          generateSection(
            title: labels.bindingReferenceMapping,
            items: [
              for (final name in references)
                ListItem<String>.options(
                  title: Text(name),
                  value: _mapping[name] ?? '',
                  options: [
                    '',
                    ...(groupReferences.contains(name)
                        ? groupNames
                        : nodeReferences.contains(name)
                        ? nodeNames
                        : {...groupNames, ...nodeNames, 'DIRECT', 'REJECT'}),
                  ],
                  textBuilder: (name) =>
                      name.isEmpty ? labels.bindingNeedsMapping : name,
                  onChanged: (value) => setState(() => _mapping[name] = value),
                ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            labels.bindingCopyPreview,
            style: AppTextStyle.footnote.of(context),
          ),
        ),
      ],
    );
  }
}
