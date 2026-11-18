import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'script_options.dart';

class ManagedOptionsView extends ConsumerStatefulWidget {
  const ManagedOptionsView({super.key});

  @override
  ConsumerState<ManagedOptionsView> createState() => _ManagedOptionsViewState();
}

class _ManagedOptionsViewState extends ConsumerState<ManagedOptionsView> {
  RouteCatalogIndex? _catalog;
  String _version = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final props = ref.read(managedSettingProvider);
    await ManagedScript.loadBundledVersion().catchError((_) {});
    final catalog = await ManagedScript.catalog(
      props,
    ).catchError((_) => RouteCatalogIndex(const RouteCatalog()));
    if (!mounted) return;
    setState(() {
      _catalog = catalog;
      _version = ManagedScript.version(ref.read(managedSettingProvider));
      _loading = false;
    });
  }

  void _updateProps(ManagedProps Function(ManagedProps) update) {
    ref.read(managedSettingProvider.notifier).update(update);
    _markReapplyIfManaged();
  }

  void _markReapplyIfManaged() {
    final profile = ref.read(currentProfileProvider);
    if (profile != null &&
        profile.extendType == ExtendType.managed &&
        profile.subscriptionOverrideEnabled) {
      ref.read(setupActionProvider.notifier).applyProfileDebounce();
    }
  }

  Future<void> _handleSync() async {
    final appLocalizations = context.appLocalizations;
    final props = ref.read(managedSettingProvider);
    final res = await globalState.loadingRun(
      tag: LoadingTag.scripts,
      title: appLocalizations.managedSync,
      () => ManagedScript.sync(props),
    );
    if (res == null || !mounted) return;
    _updateProps((state) => state.copyWith(syncedVersion: res.syncedVersion));
    await _load();
    if (!mounted) return;
    dialogs.showBanner(
      res.updated
          ? appLocalizations.updateSuccess
          : appLocalizations.managedAlreadyLatest,
      level: BannerLevel.success,
    );
  }

  Future<void> _handleRestore() async {
    final appLocalizations = context.appLocalizations;
    final confirmed = await dialogs.showMessage(
      title: appLocalizations.reset,
      message: TextSpan(text: appLocalizations.managedRestoreTip),
      confirmText: appLocalizations.reset,
    );
    if (confirmed != true || !mounted) return;
    await ManagedScript.restore();
    _updateProps((state) => state.copyWith(syncedVersion: null));
    await _load();
  }

  Future<void> _handleOpenScriptOptions() async {
    final props = ref.read(managedSettingProvider);
    await BaseNavigator.push<void>(
      context,
      ScriptOptionsView(
        title: context.appLocalizations.scriptOptions,
        loadScript: () => ManagedScript.read(ref.read(managedSettingProvider)),
        initialValues: props.options,
        onChanged: (next) {
          _updateProps((state) => state.copyWith(options: next));
        },
      ),
    );
  }

  Future<void> _handleAddCustomRegion() async {
    final region = await dialogs.showCommonDialog<CustomRegion>(
      child: const _CustomRegionDialog(),
    );
    if (region == null || !mounted) return;
    _updateProps(
      (state) => state.copyWith(
        customRegions: [
          for (final item in state.customRegions)
            if (item.name != region.name) item,
          region,
        ],
      ),
    );
  }

  Future<void> _handleAddOrEditRoute([CustomRoute? initial]) async {
    final index = _catalog;
    if (index == null) return;
    final result = await BaseNavigator.push<CustomRoute>(
      context,
      _CustomRouteEditorView(catalog: index, route: initial),
    );
    if (result == null || !mounted) return;
    _updateProps((state) {
      final list = List<CustomRoute>.from(state.routes);
      final pos = list.indexWhere((item) => item.id == result.id);
      if (pos >= 0) {
        list[pos] = result;
      } else {
        list.add(result);
      }
      return state.copyWith(routes: list);
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final props = ref.watch(managedSettingProvider);
    final index = _catalog;
    final catalog = index?.catalog ?? const RouteCatalog();
    final activeRegions = managedRegions(
      catalog,
      props.regions,
      props.customRegions,
    );
    return Scaffold(
      title: appLocalizations.managedOptions,
      isLoading: _loading,
      iconActions: [
        if (props.syncedVersion != null)
          IconButtonData(
            glyph: AppGlyphs.reset,
            tooltip: appLocalizations.reset,
            onPressed: _handleRestore,
          ),
        IconButtonData(
          glyph: AppGlyphs.cloudSync,
          tooltip: appLocalizations.sync,
          onPressed: _handleSync,
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
                    DecorationListItem(
                      title: Text(appLocalizations.version),
                      trailing: Text(
                        _version.isEmpty ? appLocalizations.none : _version,
                      ),
                    ),
                    ListItem.toggle(
                      title: Text(appLocalizations.smartAutoGroups),
                      subtitle: Text(appLocalizations.smartAutoGroupsDesc),
                      value: props.smartAutoGroups,
                      onChanged: (value) => _updateProps(
                        (state) => state.copyWith(smartAutoGroups: value),
                      ),
                    ),
                    DecorationListItem(
                      title: Text(appLocalizations.scriptOptions),
                      subtitle: Text(
                        appLocalizations.managedOptionsCount(
                          props.options.length,
                        ),
                      ),
                      trailing: const GlyphIcon(AppGlyphs.chevronForward),
                      onPressed: _handleOpenScriptOptions,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: generateSection(
                  title: appLocalizations.managedRegions,
                  actions: [
                    IconButtonData(
                      glyph: AppGlyphs.addCircle,
                      tooltip: appLocalizations.add,
                      onPressed: _handleAddCustomRegion,
                    ),
                  ],
                  items: [
                    for (final region in catalog.regions)
                      ListItem.toggle(
                        title: Text(region.name),
                        value: activeRegions.contains(region.name),
                        onChanged: (enabled) {
                          final next = Set<String>.from(activeRegions);
                          if (enabled) {
                            next.add(region.name);
                          } else {
                            next.remove(region.name);
                          }
                          _updateProps(
                            (state) => state.copyWith(regions: next.toList()),
                          );
                        },
                      ),
                    for (final custom in props.customRegions)
                      DecorationListItem(
                        title: Text(custom.name),
                        subtitle: Text(
                          custom.regex,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: activeRegions.contains(custom.name),
                              onChanged: (enabled) {
                                final next = Set<String>.from(activeRegions);
                                if (enabled) {
                                  next.add(custom.name);
                                } else {
                                  next.remove(custom.name);
                                }
                                _updateProps(
                                  (state) =>
                                      state.copyWith(regions: next.toList()),
                                );
                              },
                            ),
                            IconButton(
                              tooltip: appLocalizations.delete,
                              icon: const GlyphIcon(AppGlyphs.close),
                              onPressed: () {
                                _updateProps(
                                  (state) => state.copyWith(
                                    customRegions: [
                                      for (final item in state.customRegions)
                                        if (item.name != custom.name) item,
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: generateSection(
                  title: appLocalizations.managedCustomRoutes,
                  actions: [
                    IconButtonData(
                      glyph: AppGlyphs.addCircle,
                      tooltip: appLocalizations.add,
                      onPressed: () => _handleAddOrEditRoute(),
                    ),
                  ],
                  items: [
                    if (props.routes.isEmpty)
                      DecorationListItem(
                        title: Text(
                          appLocalizations.nullTip(
                            appLocalizations.managedCustomRoutes,
                          ),
                        ),
                        onPressed: () => _handleAddOrEditRoute(),
                      ),
                    for (final route in props.routes)
                      DecorationListItem(
                        title: Text(route.name),
                        subtitle: Text(
                          '${route.target ?? appLocalizations.defaultText} · ${route.sets.length}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: route.enabled,
                              onChanged: (value) {
                                _updateProps(
                                  (state) => state.copyWith(
                                    routes: [
                                      for (final item in state.routes)
                                        if (item.id == route.id)
                                          item.copyWith(enabled: value)
                                        else
                                          item,
                                    ],
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              tooltip: appLocalizations.delete,
                              icon: const GlyphIcon(AppGlyphs.close),
                              onPressed: () {
                                _updateProps(
                                  (state) => state.copyWith(
                                    routes: [
                                      for (final item in state.routes)
                                        if (item.id != route.id) item,
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onPressed: () => _handleAddOrEditRoute(route),
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

class _CustomRegionDialog extends StatefulWidget {
  const _CustomRegionDialog();

  @override
  State<_CustomRegionDialog> createState() => _CustomRegionDialogState();
}

class _CustomRegionDialogState extends State<_CustomRegionDialog> {
  final _nameController = TextEditingController();
  final _regexController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _regexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    return AlertDialog(
      title: appLocalizations.managedRegions,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(appLocalizations.cancel),
        ),
        FilledButton(
          onPressed: () {
            final name = _nameController.text.trim();
            final regex = _regexController.text.trim();
            if (name.isEmpty || regex.isEmpty) return;
            Navigator.of(context).pop(CustomRegion(name: name, regex: regex));
          },
          child: Text(appLocalizations.confirm),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormRow(
            title: appLocalizations.name,
            trailing: FormRowTextField(
              controller: _nameController,
              inputFormatters: TextInputLimits.limit(TextInputLimits.name),
            ),
          ),
          FormRow(
            title: appLocalizations.filter,
            trailing: FormRowTextField(
              controller: _regexController,
              autocorrect: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomRouteEditorView extends StatefulWidget {
  const _CustomRouteEditorView({required this.catalog, this.route});

  final RouteCatalogIndex catalog;
  final CustomRoute? route;

  @override
  State<_CustomRouteEditorView> createState() => _CustomRouteEditorViewState();
}

class _CustomRouteEditorViewState extends State<_CustomRouteEditorView> {
  late final TextEditingController _nameController;
  late final TextEditingController _urlController;
  late String? _target;
  late List<String> _sets;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.route?.name ?? '');
    _urlController = TextEditingController();
    _target = widget.route?.target;
    _sets = List<String>.from(widget.route?.sets ?? const <String>[]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _pickCatalogSet() async {
    final available = [
      for (final item in widget.catalog.catalog.sets)
        if (!_sets.contains(item.key)) item,
    ];
    final picked = await showSheet<RouteRuleSet>(
      context: context,
      builder: (_) => SelectionSheet<RouteRuleSet>(
        title: context.appLocalizations.ruleSet,
        sections: [
          SelectionSection(
            items: available,
            subtitleBuilder: (_, item) => item.type,
          ),
        ],
        labelBuilder: (item) => item.label,
        selectedOf: (_) => null,
        onSelected: (item) => Navigator.of(context).pop(item),
      ),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _sets = [..._sets, picked.key];
      if (_nameController.text.trim().isEmpty) {
        _nameController.text = picked.label;
      }
    });
  }

  void _addCustomRuleUrl() {
    final rawUrl = _urlController.text.trim();
    if (!CustomRuleSet.isValidUrl(rawUrl)) return;
    final key = CustomRuleSet(
      behavior: CustomRuleSet.guessBehavior(rawUrl),
      url: rawUrl,
    ).key;
    if (_sets.contains(key)) return;
    setState(() {
      _sets = [..._sets, key];
      _urlController.clear();
    });
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty || _sets.isEmpty) return;
    Navigator.of(context).pop(
      CustomRoute(
        id: widget.route?.id ?? snowflake.id.toString(),
        name: name,
        icon: widget.route?.icon,
        sets: _sets,
        target: _target,
        enabled: widget.route?.enabled ?? true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = context.appLocalizations;
    final targets = ['', ...widget.catalog.catalog.targets];
    return Scaffold(
      title: appLocalizations.managedCustomRoutes,
      actions: [
        FilledButton(onPressed: _save, child: Text(appLocalizations.save)),
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
                        controller: _nameController,
                        inputFormatters: TextInputLimits.limit(
                          TextInputLimits.name,
                        ),
                      ),
                    ),
                    DecorationListItem(
                      title: Text(appLocalizations.ruleTarget),
                      trailing: Text(_target ?? appLocalizations.defaultText),
                      onPressed: () async {
                        final selected = await showSheet<String>(
                          context: context,
                          builder: (_) => SelectionSheet<String>(
                            title: appLocalizations.ruleTarget,
                            sections: [SelectionSection(items: targets)],
                            labelBuilder: (item) => item.isEmpty
                                ? appLocalizations.defaultText
                                : item,
                            selectedOf: (_) => _target ?? '',
                            onSelected: (item) =>
                                Navigator.of(context).pop(item),
                          ),
                        );
                        if (selected != null && mounted) {
                          setState(() {
                            _target = selected.isEmpty ? null : selected;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: generateSection(
                  title: appLocalizations.ruleSet,
                  actions: [
                    IconButtonData(
                      glyph: AppGlyphs.addCircle,
                      tooltip: appLocalizations.add,
                      onPressed: _pickCatalogSet,
                    ),
                  ],
                  items: [
                    FormRow(
                      title: appLocalizations.url,
                      trailing: FormRowTextField(
                        controller: _urlController,
                        hintText: 'https://...',
                        autocorrect: false,
                        onFieldSubmitted: (_) => _addCustomRuleUrl(),
                      ),
                      onPressed: _addCustomRuleUrl,
                    ),
                    for (final key in _sets)
                      DecorationListItem(
                        title: Text(
                          widget.catalog.sets[key]?.label ??
                              CustomRuleSet.parse(key)?.name ??
                              key,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          key,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          tooltip: appLocalizations.delete,
                          icon: const GlyphIcon(AppGlyphs.close),
                          onPressed: () {
                            setState(() {
                              _sets = [
                                for (final item in _sets)
                                  if (item != key) item,
                              ];
                            });
                          },
                        ),
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
