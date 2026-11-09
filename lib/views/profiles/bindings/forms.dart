import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/profile_binding.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<Profile?> importBindingSubscription(
  BuildContext context,
  WidgetRef ref,
) async {
  final input = await showNamedUrlForm(
    context,
    title: context.appLocalizations.importUrl,
    urlValidator: (value) => value?.webUri == null
        ? context.appLocalizations.urlTip(context.appLocalizations.value)
        : null,
  );
  if (input == null) return null;
  return globalState.loadingRun(() async {
    final existing = ref
        .read(profilesProvider)
        .where((profile) => profile.url == input.url)
        .firstOrNull;
    if (existing != null) return existing;
    final profile = Profile.normal(label: input.label, url: input.url);
    final saved = await profile.update(
      validate: (path, key) =>
          ref.read(coreHandlerProvider).validateProfile(path, key),
    );
    ref.read(profilesProvider.notifier).put(saved);
    return ref.read(profilesProvider).getProfile(saved.id);
  });
}

Future<void> editSubscriptionBinding(
  BuildContext context,
  int profileId, [
  SubscriptionBinding? binding,
]) => showFormSheet<void>(
  context: context,
  builder: (_) => _SubscriptionForm(profileId: profileId, binding: binding),
);

class _SubscriptionForm extends ConsumerStatefulWidget {
  const _SubscriptionForm({required this.profileId, this.binding});
  final int profileId;
  final SubscriptionBinding? binding;
  @override
  ConsumerState<_SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends ConsumerState<_SubscriptionForm> {
  late final _name = TextEditingController(text: widget.binding?.name ?? '');
  late final _filter = TextEditingController(
    text: widget.binding?.filter ?? '',
  );
  late int? _source = widget.binding?.sourceId;
  late GroupType _type = widget.binding?.groupType ?? GroupType.Selector;
  late final _attachments = {
    for (final item in widget.binding?.attachments ?? <GroupAttachment>[])
      item.target: item.mode,
  };
  ClashConfig? _inventory;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    ref
        .read(profileBindingsActionProvider.notifier)
        .inventory(widget.profileId)
        .then(
          (value) {
            if (mounted) setState(() => _inventory = value);
          },
          onError: (Object error) {
            if (mounted) setState(() => _error = error.toString());
          },
        );
  }

  @override
  void dispose() {
    _name.dispose();
    _filter.dispose();
    super.dispose();
  }

  Future<void> _chooseSource() async {
    final sources = ref
        .read(profilesProvider)
        .where(
          (item) =>
              item.id != widget.profileId && item.type != ProfileType.custom,
        )
        .toList();
    final source = await showSheet<int>(
      context: context,
      builder: (_) => SelectionSheet<int>(
        title: context.appLocalizations.bindingSource,
        sections: [
          SelectionSection(items: sources.map((item) => item.id).toList()),
        ],
        labelBuilder: (id) =>
            sources.firstWhere((item) => item.id == id).realLabel,
        selectedOf: (_) => _source,
        onSelected: (id) => Navigator.of(context).pop(id),
      ),
    );
    if (source == null || !mounted) return;
    setState(() {
      _source = source;
      if (_name.text.isEmpty)
        _name.text = sources.firstWhere((item) => item.id == source).realLabel;
    });
  }

  Future<void> _import() async {
    final source = await importBindingSubscription(context, ref);
    if (source == null || !mounted) return;
    setState(() {
      _source = source.id;
      if (_name.text.isEmpty) _name.text = source.realLabel;
    });
  }

  Future<void> _save() async {
    final labels = context.appLocalizations;
    if (_source == null || _name.text.trim().isEmpty) {
      setState(() => _error = labels.bindingRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      if (_filter.text.isNotEmpty) RegExp(_filter.text);
      final binding = SubscriptionBinding(
        id: widget.binding?.id ?? uniqueId,
        sourceId: _source!,
        name: _name.text.trim(),
        filter: _filter.text,
        enabled: widget.binding?.enabled ?? true,
        groupType: _type,
        attachments: [
          for (final entry in _attachments.entries)
            GroupAttachment(target: entry.key, mode: entry.value),
        ],
      );
      final profile = ref.read(profileProvider(widget.profileId))!;
      await ref
          .read(profileBindingsActionProvider.notifier)
          .save(
            profile.copyWith(
              overrides: profile.overrides.copyWith(
                subscriptions: [
                  ...profile.overrides.subscriptions.where(
                    (item) => item.id != binding.id,
                  ),
                  binding,
                ],
              ),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = context.appLocalizations;
    final sources = ref.watch(profilesProvider);
    final groups = {
      ...?_inventory?.proxyGroups
          .where(
            (group) =>
                attachableGroupTypes.contains(group.type.value) &&
                group.name != widget.binding?.name,
          )
          .map((group) => group.name),
      ..._attachments.keys,
    };
    return FormPage(
      title: labels.attachedSubscriptions,
      onSave: _save,
      saving: _saving,
      error: _error,
      children: [
        generateSection(
          title: labels.basicInfo,
          items: [
            FormRow(
              title: labels.bindingSource,
              onPressed: _chooseSource,
              trailing: Text(
                sources.getProfile(_source)?.realLabel ??
                    labels.bindingSelectSource,
              ),
            ),
            MoreActionButton(label: labels.importUrl, onPressed: _import),
            FormRow(
              title: labels.name,
              trailing: FormRowTextField(controller: _name),
            ),
            FormRow(
              title: labels.bindingFilter,
              trailing: FormRowTextField(
                controller: _filter,
                autocorrect: false,
              ),
            ),
            ListItem<GroupType>.options(
              title: Text(labels.proxyType),
              value: _type,
              options: const [
                GroupType.Selector,
                GroupType.URLTest,
                GroupType.Smart,
              ],
              textBuilder: (type) => type.value,
              onChanged: (type) => setState(() => _type = type),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            labels.bindingModesHint,
            style: AppTextStyle.footnote.of(context),
          ),
        ),
        generateSection(
          title: labels.bindingTargetGroups,
          items: [
            for (final group in groups)
              ListItem<SubscriptionAttachMode?>.options(
                title: Text(group),
                value: _attachments[group],
                options: const [
                  null,
                  SubscriptionAttachMode.nodes,
                  SubscriptionAttachMode.group,
                ],
                textBuilder: (mode) => switch (mode) {
                  null => labels.none,
                  SubscriptionAttachMode.nodes => labels.bindingExpandNodes,
                  SubscriptionAttachMode.group => labels.bindingReferenceGroup,
                },
                onChanged: (mode) => setState(() {
                  if (mode == null) {
                    _attachments.remove(group);
                  } else {
                    _attachments[group] = mode;
                  }
                }),
              ),
          ],
        ),
      ],
    );
  }
}

Future<void> editRuleBinding(
  BuildContext context,
  int profileId, [
  RuleSetBinding? binding,
]) => showFormSheet<void>(
  context: context,
  builder: (_) => _RuleBindingForm(profileId: profileId, binding: binding),
);

class _RuleBindingForm extends ConsumerStatefulWidget {
  const _RuleBindingForm({required this.profileId, this.binding});
  final int profileId;
  final RuleSetBinding? binding;
  @override
  ConsumerState<_RuleBindingForm> createState() => _RuleBindingFormState();
}

class _RuleBindingFormState extends ConsumerState<_RuleBindingForm> {
  late int? _source = widget.binding?.sourceId;
  late String _target = widget.binding?.target ?? 'DIRECT';
  ClashConfig? _inventory;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    ref
        .read(profileBindingsActionProvider.notifier)
        .inventory(widget.profileId)
        .then(
          (value) {
            if (mounted) setState(() => _inventory = value);
          },
          onError: (Object error) {
            if (mounted) setState(() => _error = error.toString());
          },
        );
  }

  Future<void> _import() async {
    final input = await showNamedUrlForm(
      context,
      title: context.appLocalizations.importUrl,
      urlValidator: (value) => value?.webUri == null
          ? context.appLocalizations.urlTip(context.appLocalizations.value)
          : null,
    );
    if (input == null) return;
    final saved = await globalState.loadingRun(() async {
      final label = uniqueLabelFor(
        input.label,
        fallback: input.url.urlFileName,
        taken: (name) => (ref.read(clashProvidersProvider).value ?? []).any(
          (item) => item.label == name,
        ),
      );
      return ref
          .read(clashProvidersActionProvider.notifier)
          .putProvider(ClashProvider.create(label: label, url: input.url));
    });
    if (saved != null && mounted) setState(() => _source = saved.id);
  }

  Future<void> _save() async {
    if (_source == null) {
      setState(() => _error = context.appLocalizations.bindingRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final binding = RuleSetBinding(
        id: widget.binding?.id ?? uniqueId,
        sourceId: _source!,
        target: _target,
        enabled: widget.binding?.enabled ?? true,
      );
      final profile = ref.read(profileProvider(widget.profileId))!;
      await ref
          .read(profileBindingsActionProvider.notifier)
          .save(
            profile.copyWith(
              overrides: profile.overrides.copyWith(
                ruleBindings: [
                  ...profile.overrides.ruleBindings.where(
                    (item) => item.id != binding.id,
                  ),
                  binding,
                ],
              ),
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = context.appLocalizations;
    final providers = ref.watch(clashProvidersProvider).value ?? [];
    final targets = {
      'DIRECT',
      'REJECT',
      ...?_inventory?.proxyGroups.map((group) => group.name),
      ...?_inventory?.proxies.map((node) => node.name),
      ...?ref
          .watch(profileProvider(widget.profileId))
          ?.overrides
          .chains
          .where((chain) => chain.enabled)
          .map((chain) => chain.name),
      _target,
    };
    return FormPage(
      title: labels.bindingRuleSources,
      onSave: _save,
      saving: _saving,
      error: _error,
      children: [
        generateSection(
          title: labels.basicInfo,
          items: [
            if (providers.isNotEmpty)
              ListItem<int?>.options(
                title: Text(labels.bindingSource),
                options: [null, ...providers.map((item) => item.id)],
                value: _source,
                textBuilder: (id) =>
                    providers
                        .where((item) => item.id == id)
                        .firstOrNull
                        ?.label ??
                    labels.bindingSelectSource,
                onChanged: (id) => setState(() => _source = id),
              ),
            MoreActionButton(label: labels.importUrl, onPressed: _import),
            ListItem<String>.options(
              title: Text(labels.splitStrategy),
              options: targets.toList(),
              value: _target,
              textBuilder: (name) => name,
              onChanged: (name) => setState(() => _target = name),
            ),
          ],
        ),
      ],
    );
  }
}
