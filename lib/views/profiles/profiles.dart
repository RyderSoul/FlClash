import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/profiles/custom/custom.dart';
import 'package:fl_clash/views/profiles/extend/extend.dart';
import 'package:fl_clash/views/profiles/merge_profile.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add.dart';
import 'edit.dart';
import 'preview.dart';

const _infoGap = 4.0;

double get _profileItemHeight {
  final measure = globalState.measure;
  return measure.textHeight(AppTextStyle.headline) +
      _infoGap +
      measure.textHeight(AppTextStyle.footnote) +
      2 * listRowVerticalPadding;
}

class ProfilesView extends ConsumerStatefulWidget {
  const ProfilesView({super.key, this.picker = false});

  /// Clears the bar and opens at the top, for switching profiles from a sheet.
  final bool picker;

  @override
  ConsumerState<ProfilesView> createState() => _ProfilesViewState();
}

class _ProfilesViewState extends ConsumerState<ProfilesView> {
  bool _isUpdating = false;
  final _expandedBundles = <int>{};

  void _toggleBundle(int profileId) {
    setState(() {
      if (!_expandedBundles.add(profileId)) {
        _expandedBundles.remove(profileId);
      }
    });
  }

  Future<void> _updateProfiles(List<Profile> profiles) async {
    if (_isUpdating == true) {
      return;
    }
    _isUpdating = true;
    final appLocalizations = context.appLocalizations;
    final profilesAction = ref.read(profilesActionProvider.notifier);
    final List<UpdatingMessage> messages = [];
    final updatedIds = <int>{};
    final updateProfiles = profiles.map<Future>((profile) async {
      if (profile.type != ProfileType.url) return;
      try {
        await profilesAction.updateProfile(
          profile,
          showLoading: true,
          rebuildBundles: false,
        );
        updatedIds.add(profile.id);
      } catch (e) {
        messages.add(
          UpdatingMessage(
            label: profile.realLabel,
            message: userFacingErrorMessage(e, appLocalizations),
          ),
        );
      }
    });
    await Future.wait(updateProfiles);
    if (updatedIds.isNotEmpty) {
      for (final profile in profiles) {
        final bundle = profile.overrides.bundle;
        if (bundle == null) continue;
        final depends = bundle.members.any(
          (member) => member.enabled && updatedIds.contains(member.profileId),
        );
        if (!depends) continue;
        try {
          await profilesAction.syncBundleProfile(
            profile.id,
            refreshUrls: false,
          );
        } catch (e) {
          messages.add(
            UpdatingMessage(
              label: profile.realLabel,
              message: userFacingErrorMessage(e, appLocalizations),
            ),
          );
        }
      }
    }
    dialogs.showFailures(messages);
    _isUpdating = false;
  }

  List<IconButtonData> _buildActions(List<Profile> profiles) {
    return profiles.isNotEmpty
        ? [
            IconButtonData(
              glyph: AppGlyphs.sync,
              onPressed: () {
                _updateProfiles(profiles);
              },
              tooltip: context.appLocalizations.update,
            ),
            IconButtonData(
              glyph: AppGlyphs.sort,
              onPressed: () {
                showSheet(
                  context: context,
                  builder: (_) {
                    return ReorderableProfilesSheet(profiles: profiles);
                  },
                );
              },
              tooltip: context.appLocalizations.profilesSort,
            ),
          ]
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, _) {
        final appLocalizations = context.appLocalizations;
        final isLoading = ref.watch(loadingProvider(LoadingTag.profiles));
        final state = ref.watch(profilesStateProvider);
        final spacing = cardSpacingOf(context, ref.watch(viewModeProvider));
        final picker = widget.picker;
        return Scaffold(
          isLoading: isLoading,
          title: appLocalizations.profiles,
          iconActions: picker ? const [] : _buildActions(state.profiles),
          actions: state.profiles.isEmpty || picker
              ? null
              : [
                  AddProfileMenu(
                    builder: (open) => IconButton(
                      tooltip: appLocalizations.addProfile,
                      onPressed: open,
                      icon: const GlyphIcon(AppGlyphs.addCircle),
                    ),
                  ),
                ],
          body: NullStatusSwitcher(
            isEmpty: state.profiles.isEmpty,
            nullStatus: NullStatus(
              label: appLocalizations.nullTip(appLocalizations.profiles),
              description: appLocalizations.nullProfileDesc,
              illustration: NullStatusIllustration.profile,
              action: AddProfileMenu(
                builder: (open) => TonalButton(
                  size: TonalButtonSize.bar,
                  glyph: AppGlyphs.addCircle,
                  label: appLocalizations.addProfile,
                  onPressed: open,
                ),
              ),
            ),
            child: _ProfilesGrid(
              profiles: state.profiles,
              currentProfileId: state.currentProfileId,
              spacing: spacing,
              revealsSelected: !picker,
              expandedBundles: _expandedBundles,
              onToggleBundle: _toggleBundle,
            ),
          ),
        );
      },
    );
  }
}

typedef _ProfileEntry = ({Profile profile, bool isBundleMember});

List<_ProfileEntry> _visibleProfileEntries(
  List<Profile> profiles,
  int? currentProfileId,
  Set<int> expandedBundles,
) {
  final nestedIds = <int>{};
  for (final profile in profiles) {
    final bundle = profile.overrides.bundle;
    if (bundle == null) continue;
    for (final member in bundle.members) {
      if (member.enabled) nestedIds.add(member.profileId);
    }
  }
  final byId = {for (final profile in profiles) profile.id: profile};
  final entries = <_ProfileEntry>[];
  final emittedExpanded = <int>{};
  for (final profile in profiles) {
    if (nestedIds.contains(profile.id) && profile.id != currentProfileId) {
      continue;
    }
    entries.add((profile: profile, isBundleMember: false));
    final bundle = profile.overrides.bundle;
    if (bundle != null && expandedBundles.contains(profile.id)) {
      for (final member in bundle.members) {
        if (!member.enabled) continue;
        final child = byId[member.profileId];
        if (child != null && emittedExpanded.add(child.id)) {
          entries.add((profile: child, isBundleMember: true));
        }
      }
    }
  }
  return entries;
}

class _ProfilesGrid extends ConsumerStatefulWidget {
  const _ProfilesGrid({
    required this.profiles,
    required this.currentProfileId,
    required this.spacing,
    required this.revealsSelected,
    required this.expandedBundles,
    required this.onToggleBundle,
  });

  final List<Profile> profiles;
  final int? currentProfileId;
  final double spacing;
  final bool revealsSelected;
  final Set<int> expandedBundles;
  final ValueChanged<int> onToggleBundle;

  @override
  ConsumerState<_ProfilesGrid> createState() => _ProfilesGridState();
}

class _ProfilesGridState extends ConsumerState<_ProfilesGrid> {
  static const _horizontalPadding = 16.0;

  late final ScrollController _controller;
  var _revealed = false;

  @override
  void initState() {
    super.initState();
    _controller = sheetScrollController(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_revealed ||
        !widget.revealsSelected ||
        !PageActivityScope.isActiveOf(context)) {
      return;
    }
    _revealed = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _revealSelected());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  EdgeInsets get _padding => EdgeInsets.only(
    left: _horizontalPadding,
    right: _horizontalPadding,
    top: context.contentTopPadding,
    bottom: 16 + context.bottomInset,
  );

  int _columnsFor(double width) => getProfilesColumns(
    width - _horizontalPadding * 2,
    spacing: widget.spacing,
    minItemWidth: profileItemMinWidth.ap(context),
  );

  void _revealSelected() {
    if (!mounted || !_controller.hasClients) {
      return;
    }
    final visibleEntries = _visibleProfileEntries(
      widget.profiles,
      widget.currentProfileId,
      widget.expandedBundles,
    );
    final index = visibleEntries.indexWhere(
      (entry) => entry.profile.id == widget.currentProfileId,
    );
    if (index == -1) {
      return;
    }
    final position = _controller.position;
    final padding = _padding;
    final height = _profileItemHeight;
    final row = index ~/ _columnsFor(context.size!.width);
    final atTop = row * (height + widget.spacing);
    final atBottom =
        atTop + padding.vertical + height - position.viewportDimension;
    if (position.pixels >= atBottom && position.pixels <= atTop) {
      return;
    }
    _controller.jumpTo(
      ((atTop + atBottom) / 2).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleEntries = _visibleProfileEntries(
      widget.profiles,
      widget.currentProfileId,
      widget.expandedBundles,
    );
    return WidthBuilder(
      builder: (_, width) {
        return GridView.builder(
          key: profilesStoreKey,
          controller: _controller,
          padding: _padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _columnsFor(width),
            mainAxisSpacing: widget.spacing,
            crossAxisSpacing: widget.spacing,
            mainAxisExtent: _profileItemHeight,
          ),
          itemCount: visibleEntries.length,
          itemBuilder: (context, index) {
            final entry = visibleEntries[index];
            final profile = entry.profile;
            return ProfileItem(
              key: ValueKey(
                entry.isBundleMember ? 'member_${profile.id}' : profile.id,
              ),
              profile: profile,
              groupValue: widget.currentProfileId,
              isExpanded: widget.expandedBundles.contains(profile.id),
              isBundleMember: entry.isBundleMember,
              onToggleExpand: profile.isBundle
                  ? () => widget.onToggleBundle(profile.id)
                  : null,
              onChanged: (profileId) {
                ref.read(currentProfileIdProvider.notifier).value = profileId;
              },
            );
          },
        );
      },
    );
  }
}

class ProfileItem extends ConsumerWidget {
  final Profile profile;
  final int? groupValue;
  final bool isExpanded;
  final bool isBundleMember;
  final VoidCallback? onToggleExpand;
  final void Function(int? value) onChanged;

  const ProfileItem({
    super.key,
    required this.profile,
    required this.groupValue,
    this.isExpanded = false,
    this.isBundleMember = false,
    this.onToggleExpand,
    required this.onChanged,
  });

  Future<void> _handleDeleteProfile(BuildContext context, WidgetRef ref) async {
    final profilesAction = ref.read(profilesActionProvider.notifier);
    final appLocalizations = context.appLocalizations;
    final users = await profilesAction.providerUsers(profile);
    final res = await dialogs.showMessage(
      title: appLocalizations.tip,
      message: TextSpan(
        text: users.isEmpty
            ? appLocalizations.deleteTip(appLocalizations.profile)
            : appLocalizations.providerInUse(
                profile.realLabel,
                users.map((item) => item.realLabel).join(', '),
              ),
      ),
      destructive: true,
      confirmText: appLocalizations.delete,
    );
    if (res != true) {
      return;
    }
    await profilesAction.deleteProfile(profile.id);
  }

  Future<void> _handlePreview(BuildContext context) async {
    unawaited(
      BaseNavigator.push<String>(context, PreviewProfileView(profile: profile)),
    );
  }

  Future updateProfile(WidgetRef ref) async {
    if (profile.isBundle) {
      await globalState.loadingRun(() async {
        await ref
            .read(profilesActionProvider.notifier)
            .syncBundleProfile(profile.id);
      }, tag: LoadingTag.profiles);
      return;
    }
    if (profile.type != ProfileType.url) return;
    await globalState.loadingRun(() async {
      await ref
          .read(profilesActionProvider.notifier)
          .updateProfile(profile, showLoading: true);
    }, tag: LoadingTag.profiles);
  }

  void _handleShowEditExtendPage(BuildContext context) {
    showExtend(
      context,
      builder: (context) => EditProfileView(profile: profile),
    );
  }

  SubscriptionInfo? get _subscriptionInfo =>
      profile.type == ProfileType.url ? profile.subscriptionInfo : null;

  String _subtitle(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    if (profile.overrides.bundle case final bundle?) {
      final count = bundle.members.where((item) => item.enabled).length;
      final proxies = bundle.report?.proxies ?? 0;
      return appLocalizations.bundleSummary(count, proxies);
    }
    final info = _subscriptionInfo;
    if (info != null && info.usage != null) {
      final used = info.upload + info.download;
      return '${used.traffic.show} / ${info.total.traffic.show}';
    }
    final source = switch (profile.type) {
      ProfileType.url => appLocalizations.remote,
      ProfileType.file => appLocalizations.local,
      ProfileType.custom => appLocalizations.custom,
    };
    return isBundleMember ? '↳ $source' : source;
  }

  Widget _buildTrailing(BuildContext context, {required bool isUpdating}) {
    return AnimatedSwitcher(
      duration: context.motionDuration(commonDuration),
      layoutBuilder: (currentChild, previousChildren) => Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [...previousChildren, ?currentChild],
      ),
      child: isUpdating
          ? const ActivityIndicator(key: ValueKey('updating'), size: 24)
          : LastUpdateTimeText(
              key: const ValueKey('lastUpdate'),
              lastUpdateDate: profile.lastUpdateDate,
              style: AppTextStyle.footnote.of(context).toLighter,
              compact: true,
            ),
    );
  }

  Future<void> _handleCopyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: profile.url));
    if (context.mounted) {
      dialogs.showBanner(
        context.appLocalizations.copySuccess,
        level: BannerLevel.success,
      );
    }
  }

  Future<void> _handleExportFile(BuildContext context) async {
    final appLocalizations = context.appLocalizations;
    final res = await globalState.safeRun<bool>(() async {
      final mFile = await profile.file;
      final value = await picker.saveFile(
        profile.exportFileName,
        mFile.readAsBytesSync(),
      );
      if (value == null) return false;
      return true;
    }, title: appLocalizations.tip);
    if (res == true && context.mounted) {
      dialogs.showBanner(
        appLocalizations.exportSuccess,
        level: BannerLevel.success,
      );
    }
  }

  void _handlePushGenProfilePage(BuildContext context, int id) {
    BaseNavigator.push(context, ExtendView(profileId: id));
  }

  void _handlePushCustomProfilePage(BuildContext context, int id) {
    BaseNavigator.push(context, CustomProfileView(profileId: id));
  }

  void _handleEdit(BuildContext context) {
    if (profile.type == ProfileType.custom) {
      _handlePushCustomProfilePage(context, profile.id);
    } else if (profile.isBundle) {
      BaseNavigator.push(context, MergeProfileView(profileId: profile.id));
    } else {
      _handleShowEditExtendPage(context);
    }
  }

  List<PopupMenuItem> _menuItems(BuildContext context, WidgetRef ref) {
    final appLocalizations = context.appLocalizations;
    final isUrl = profile.type == ProfileType.url;
    final isCustom = profile.type == ProfileType.custom;
    return [
      PopupMenuItem(
        glyph: AppGlyphs.edit,
        label: appLocalizations.edit,
        onPressed: () => _handleEdit(context),
      ),
      if (isCustom) ...[
        PopupMenuItem(
          glyph: AppGlyphs.textShort,
          label: appLocalizations.rename,
          onPressed: () {
            renameProfile(context, ref, profile);
          },
        ),
        PopupMenuItem(
          glyph: AppGlyphs.eye,
          label: appLocalizations.runtimeConfig,
          onPressed: () {
            _handlePreview(context);
          },
        ),
      ] else
        PopupMenuItem(
          glyph: AppGlyphs.puzzle,
          label: appLocalizations.extend,
          onPressed: () {
            _handlePushGenProfilePage(context, profile.id);
          },
        ),
      if (isUrl || profile.isBundle)
        PopupMenuItem(
          glyph: AppGlyphs.sync,
          label: appLocalizations.sync,
          onPressed: () {
            updateProfile(ref);
          },
        ),
      if (!isCustom)
        PopupMenuItem(
          glyph: AppGlyphs.moreCircle,
          label: appLocalizations.more,
          subItems: [
            PopupMenuItem(
              glyph: AppGlyphs.eye,
              label: appLocalizations.runtimeConfig,
              onPressed: () {
                _handlePreview(context);
              },
            ),
            if (isUrl)
              PopupMenuItem(
                glyph: AppGlyphs.copy,
                label: appLocalizations.copyLink,
                onPressed: () {
                  _handleCopyLink(context);
                },
              ),
            if (isUrl)
              PopupMenuItem(
                glyph: AppGlyphs.qrCode,
                label: appLocalizations.qrcode,
                onPressed: () {
                  dialogs.showQrCode(
                    title: profile.realLabel,
                    data: profile.url,
                    message: appLocalizations.shareQrcodeTip,
                  );
                },
              ),
            PopupMenuItem(
              glyph: AppGlyphs.export,
              label: appLocalizations.exportFile,
              onPressed: () {
                _handleExportFile(context);
              },
            ),
          ],
        ),
      PopupMenuItem(
        danger: true,
        glyph: AppGlyphs.delete,
        label: appLocalizations.delete,
        onPressed: () {
          _handleDeleteProfile(context, ref);
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUpdating = ref.watch(isUpdatingProvider(profile.updatingKey));
    final subscriptionInfo = _subscriptionInfo;
    final isSelected = profile.id == groupValue;
    return ContextMenuRegion(
      menuItems: isUpdating ? null : _menuItems(context, ref),
      child: Card(
        enterActionsOnRight: true,
        radius: AppCorner.xl,
        isSelected: isSelected,
        onPressed: () {
          onChanged(profile.id);
        },
        child: ListItem(
          key: Key(profile.id.toString()),
          minTileHeight: _profileItemHeight,
          minVerticalPadding: listRowVerticalPadding,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              if (onToggleExpand case final toggle?)
                IconButton(
                  tooltip: context.appLocalizations.bundleMembers,
                  icon: GlyphIcon(
                    isExpanded
                        ? AppGlyphs.chevronDown
                        : AppGlyphs.chevronForward,
                  ),
                  onPressed: toggle,
                ),
              if (profile.type == ProfileType.custom)
                _GroupsCountChip(profileId: profile.id)
              else
                _buildTrailing(context, isUpdating: isUpdating),
              if (isSelected) const SelectionBadge(size: 24),
            ],
          ),
          title: _ProfileCardTitle(
            profile: profile,
            expire: subscriptionInfo?.expireDate,
            subtitle: _subtitle(context),
          ),
        ),
      ),
    );
  }
}

class _ProfileCardTitle extends StatelessWidget {
  const _ProfileCardTitle({
    required this.profile,
    required this.expire,
    required this.subtitle,
  });

  final Profile profile;
  final DateTime? expire;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipTitle(
          title: profile.realLabel,
          expire: expire,
          style: AppTextStyle.headline.of(context),
        ),
        const SizedBox(height: _infoGap),
        Text(
          subtitle,
          style: AppTextStyle.footnote.of(context).toLighter,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// Square-cornered so a lone digit never reads as a second [SelectionBadge].
class _GroupsCountChip extends ConsumerWidget {
  const _GroupsCountChip({required this.profileId});

  final int profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(profileGroupsCountProvider(profileId)).value;
    if (count == null) {
      return const SizedBox.shrink();
    }
    final colorScheme = context.colorScheme;
    return Tooltip(
      message: context.appLocalizations.proxyGroupsCount(count, count.compact),
      child: TonalChip(
        label: count.compact,
        color: colorScheme.primary.opacity15,
        foregroundColor: colorScheme.primary,
      ),
    );
  }
}

class ReorderableProfilesSheet extends ConsumerStatefulWidget {
  final List<Profile> profiles;

  const ReorderableProfilesSheet({super.key, required this.profiles});

  @override
  ConsumerState<ReorderableProfilesSheet> createState() =>
      _ReorderableProfilesSheetState();
}

class _ReorderableProfilesSheetState
    extends ConsumerState<ReorderableProfilesSheet> {
  late List<Profile> profiles;

  @override
  void initState() {
    super.initState();
    profiles = List.from(widget.profiles);
  }

  Widget _buildItem(int index) {
    final position = ItemPosition.get(index, profiles.length);
    final profile = profiles[index];
    return ReorderDragStartListener(
      key: Key(profile.id.toString()),
      index: index,
      child: ItemPositionProvider(
        position: position,
        child: DecorationListItem(
          contentPadding: const EdgeInsets.only(left: 16),
          trailing: SortHandle(index: index),
          title: Text(profile.realLabel),
        ),
      ),
    );
  }

  void _handleSave() {
    Navigator.of(context).pop();
    final latest = ref.read(profilesProvider);
    final ids = {for (final profile in profiles) profile.id};
    ref.read(profilesProvider.notifier).reorder([
      for (final profile in profiles) ?latest.getProfile(profile.id),
      for (final profile in latest)
        if (!ids.contains(profile.id)) profile,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return Scaffold(
      confirmationAction: IconButtonData(
        glyph: AppGlyphs.check,
        onPressed: _handleSave,
        tooltip: context.appLocalizations.save,
      ),
      body: PrismReorderableListView(
        padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(
          top: context.contentTopPadding,
          bottom: 32 + context.bottomInset,
        ),
        proxyDecorator: (child, index, animation) {
          return commonProxyDecorator(_buildItem(index), index, animation);
        },
        onReorderItem: (oldIndex, newIndex) {
          setState(() {
            profiles = profiles.copyAndReorder(oldIndex, newIndex);
          });
        },
        itemBuilder: (_, index) {
          return _buildItem(index);
        },
        itemCount: profiles.length,
      ),
      title: appLocalizations.profilesSort,
    );
  }
}
