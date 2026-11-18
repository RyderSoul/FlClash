import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MergeProfileView extends ConsumerStatefulWidget {
  final int? profileId;

  const MergeProfileView({super.key, this.profileId});

  @override
  ConsumerState<MergeProfileView> createState() => _MergeProfileViewState();
}

class _MergeProfileViewState extends ConsumerState<MergeProfileView> {
  late final TextEditingController _labelController;
  late List<BundleMember> _members;

  @override
  void initState() {
    super.initState();
    final existing = widget.profileId == null
        ? null
        : ref.read(profileProvider(widget.profileId));
    _labelController = TextEditingController(text: existing?.label ?? '');
    _members = List.of(
      existing?.overrides.bundle?.members ?? const <BundleMember>[],
    );
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  List<Profile> _candidates(List<Profile> profiles) {
    final added = {for (final member in _members) member.profileId};
    return [
      for (final profile in profiles)
        if (profile.type != ProfileType.custom &&
            !profile.isBundle &&
            profile.id != widget.profileId &&
            !added.contains(profile.id))
          profile,
    ];
  }

  Future<void> _handleAddMember(List<Profile> candidates) async {
    final appLocalizations = context.appLocalizations;
    final picked = await showSheet<Profile>(
      context: context,
      builder: (_) => SelectionSheet<Profile>(
        title: appLocalizations.add,
        sections: [SelectionSection(items: candidates)],
        labelBuilder: (item) => item.realLabel,
        selectedOf: (_) => null,
        emptyLabel: appLocalizations.nullTip(appLocalizations.profile),
        onSelected: (item) => Navigator.of(context).pop(item),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _members = [..._members, BundleMember(profileId: picked.id)];
    });
  }

  Future<void> _handleEditPrefix(BundleMember member, String fallback) async {
    final appLocalizations = context.appLocalizations;
    final edited = await dialogs.showCommonDialog<String>(
      child: InputDialog(
        title: appLocalizations.edit,
        labelText: appLocalizations.prefix,
        value: member.prefix.isEmpty ? fallback : member.prefix,
        inputFormatters: TextInputLimits.limit(TextInputLimits.name),
      ),
    );
    if (edited == null || !mounted) return;
    final clean = edited.trim();
    setState(() {
      _members = [
        for (final item in _members)
          if (item.profileId == member.profileId)
            item.copyWith(prefix: clean == fallback ? '' : clean)
          else
            item,
      ];
    });
  }

  Future<void> _handleSave() async {
    final appLocalizations = context.appLocalizations;
    final activeCount = _members.where((item) => item.enabled).length;
    if (activeCount < 2) {
      dialogs.showBanner(
        appLocalizations.mergeMinMembersTip,
        level: BannerLevel.warning,
      );
      return;
    }
    final label = _labelController.text.trim();
    final saved = await globalState.loadingRun(
      tag: LoadingTag.profiles,
      title: appLocalizations.mergeProfiles,
      () => ref
          .read(profilesActionProvider.notifier)
          .saveBundleProfile(
            profileId: widget.profileId,
            label: label.isEmpty ? appLocalizations.mergeProfiles : label,
            members: _members,
          ),
    );
    if (saved != null && mounted) {
      Navigator.of(context).pop(saved);
    }
  }

  Widget _buildMemberTile(int index, List<Profile> profiles) {
    final member = _members[index];
    final target = profiles.getProfile(member.profileId);
    final label = target?.realLabel ?? member.profileId.toString();
    final fallback = bundlePrefixOf(label);
    final displayPrefix = member.prefix.trim().isEmpty
        ? fallback
        : member.prefix.trim();
    final position = ItemPosition.get(index, _members.length);
    return ReorderDragStartListener(
      key: ValueKey(member.profileId),
      index: index,
      child: ItemPositionProvider(
        position: position,
        child: DecorationListItem(
          contentPadding: const EdgeInsets.only(left: 16, right: 8),
          leading: SortHandle(index: index),
          title: EmojiText(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            displayPrefix.isEmpty
                ? context.appLocalizations.none
                : '${context.appLocalizations.prefix}: $displayPrefix',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                value: member.enabled,
                onChanged: (value) {
                  setState(() {
                    _members = [
                      for (final item in _members)
                        if (item.profileId == member.profileId)
                          item.copyWith(enabled: value)
                        else
                          item,
                    ];
                  });
                },
              ),
              IconButton(
                tooltip: context.appLocalizations.delete,
                icon: const GlyphIcon(AppGlyphs.close),
                onPressed: () {
                  setState(() {
                    _members = [
                      for (final item in _members)
                        if (item.profileId != member.profileId) item,
                    ];
                  });
                },
              ),
            ],
          ),
          onPressed: () => _handleEditPrefix(member, fallback),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final profiles = ref.watch(profilesProvider);
    final existing = widget.profileId == null
        ? null
        : profiles.getProfile(widget.profileId);
    final report = existing?.overrides.bundle?.report;
    final candidates = _candidates(profiles);
    return Scaffold(
      title: appLocalizations.mergeProfiles,
      actions: [
        FilledButton(
          onPressed: _handleSave,
          child: Text(
            widget.profileId == null
                ? appLocalizations.create
                : appLocalizations.save,
          ),
        ),
      ],
      body: ScrollConfiguration(
        behavior: const ShowBarScrollBehavior(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: context.sectionsTopPadding),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: generateSection(
                  items: [
                    FormRow(
                      title: appLocalizations.name,
                      trailing: FormRowTextField(
                        controller: _labelController,
                        hintText: appLocalizations.mergeProfiles,
                        inputFormatters: TextInputLimits.limit(
                          TextInputLimits.name,
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (report != null)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: generateSection(
                    title: appLocalizations.summary,
                    items: [
                      DecorationListItem(
                        title: Text(appLocalizations.proxies),
                        trailing: Text('${report.proxies}'),
                      ),
                      DecorationListItem(
                        title: Text(appLocalizations.duplicate),
                        trailing: Text('${report.duplicates}'),
                      ),
                      DecorationListItem(
                        title: Text(appLocalizations.proxyGroup),
                        trailing: Text('${report.groups}'),
                      ),
                    ],
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              sliver: SliverToBoxAdapter(
                child: ListHeader(title: appLocalizations.bundleMembers),
              ),
            ),
            if (_members.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverPrismReorderableList(
                  itemCount: _members.length,
                  itemExtent: globalState.measure.listRowHeight,
                  itemBuilder: (_, index) => _buildMemberTile(index, profiles),
                  proxyDecorator: (_, index, animation) => commonProxyDecorator(
                    _buildMemberTile(index, profiles),
                    index,
                    animation,
                  ),
                  onReorderItem: (oldIndex, newIndex) {
                    setState(() {
                      _members = _members.copyAndReorder(oldIndex, newIndex);
                    });
                  },
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              sliver: SliverToBoxAdapter(
                child: generateSection(
                  items: [
                    DecorationListItem(
                      leading: const GlyphIcon(AppGlyphs.addCircle),
                      title: Text(appLocalizations.add),
                      invalid: candidates.isEmpty,
                      onPressed: candidates.isEmpty
                          ? null
                          : () => _handleAddMember(candidates),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 16 + context.bottomInset),
            ),
          ],
        ),
      ),
    );
  }
}
