import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/profile_binding.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/state.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProxyChainsView extends ConsumerWidget {
  const ProxyChainsView({super.key, required this.profileId});

  final int profileId;

  Future<void> _update(
    WidgetRef ref,
    List<ProxyChain> Function(List<ProxyChain>) change,
  ) async {
    await globalState.safeRun(() async {
      final profile = ref.read(profileProvider(profileId));
      if (profile == null) return;
      await ref
          .read(profileBindingsActionProvider.notifier)
          .save(
            profile.copyWith(
              overrides: profile.overrides.copyWith(
                chains: change(profile.overrides.chains),
              ),
            ),
          );
    });
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    ProxyChain? chain,
  ]) async {
    final result = await showFormSheet<ProxyChain>(
      context: context,
      builder: (_) => _ChainForm(profileId: profileId, chain: chain),
    );
    if (result == null) return;
    await _update(
      ref,
      (chains) => [...chains.where((item) => item.id != result.id), result],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.appLocalizations;
    final chains = ref.watch(
      profileProvider(
        profileId,
      ).select((profile) => profile?.overrides.chains ?? const <ProxyChain>[]),
    );
    return Scaffold(
      title: labels.proxyChains,
      primaryAction: IconButtonData(
        glyph: AppGlyphs.addCircle,
        tooltip: labels.addProxyChain,
        onPressed: () => _edit(context, ref),
      ),
      body: NullStatusSwitcher(
        isEmpty: chains.isEmpty,
        nullStatus: NullStatus(
          label: labels.proxyChainEmpty,
          illustration: NullStatusIllustration.data,
          action: TonalButton(
            label: labels.addProxyChain,
            onPressed: () => _edit(context, ref),
          ),
        ),
        child: PrismListView(
          padding: EdgeInsets.fromLTRB(
            16,
            context.contentTopPadding,
            16,
            24 + context.bottomInset,
          ),
          itemCount: chains.length,
          itemBuilder: (_, index) {
            final chain = chains[index];
            return ItemPositionProvider(
              key: ValueKey(chain.id),
              position: ItemPosition.get(index, chains.length),
              child: ContextMenuRegion(
                menuItems: [
                  PopupMenuItem(
                    glyph: AppGlyphs.edit,
                    label: labels.edit,
                    onPressed: () => _edit(context, ref, chain),
                  ),
                  PopupMenuItem(
                    glyph: AppGlyphs.delete,
                    label: labels.delete,
                    danger: true,
                    onPressed: () => _update(
                      ref,
                      (items) =>
                          items.where((item) => item.id != chain.id).toList(),
                    ),
                  ),
                ],
                child: _ChainLatencyPanel(
                  profileId: profileId,
                  chain: chain,
                  onChanged: (value) => _update(
                    ref,
                    (items) => [
                      for (final item in items)
                        item.id == chain.id
                            ? item.copyWith(enabled: value)
                            : item,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ChainLatencyPanel extends ConsumerStatefulWidget {
  const _ChainLatencyPanel({
    required this.profileId,
    required this.chain,
    required this.onChanged,
  });

  final int profileId;
  final ProxyChain chain;
  final ValueChanged<bool> onChanged;

  @override
  ConsumerState<_ChainLatencyPanel> createState() => _ChainLatencyPanelState();
}

class _ChainLatencyPanelState extends ConsumerState<_ChainLatencyPanel> {
  final _delays = <int, int>{};
  final _failed = <int>{};
  String? _error;
  int? _checking;
  int _revision = 0;

  void _clear() {
    _revision++;
    _delays.clear();
    _failed.clear();
    _error = null;
    _checking = null;
  }

  @override
  void didUpdateWidget(covariant _ChainLatencyPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chain != widget.chain) _clear();
  }

  Future<void> _check() async {
    if (_checking != null) return;
    final revision = ++_revision;
    setState(() {
      _delays.clear();
      _failed.clear();
      _error = null;
      _checking = 0;
    });
    try {
      for (var index = 0; index < widget.chain.hops.length; index++) {
        if (!mounted || revision != _revision) return;
        setState(() => _checking = index);
        try {
          final delay = await ref
              .read(profileBindingsActionProvider.notifier)
              .testChainHop(widget.profileId, widget.chain, index);
          if (!mounted || revision != _revision) return;
          setState(() => _delays[index] = delay.value ?? 0);
        } catch (error) {
          if (!mounted || revision != _revision) return;
          setState(() {
            _failed.add(index);
            _error = error.toString();
          });
          if (error is MessageException) break;
        }
      }
    } finally {
      if (mounted && revision == _revision) {
        setState(() => _checking = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(currentProfileIdProvider, (_, _) => setState(_clear));
    ref.listen(
      runTimeProvider.select((runtime) => runtime != null),
      (_, _) => setState(_clear),
    );
    ref.listen(coreStatusProvider, (_, _) => setState(_clear));
    ref.listen(realTestUrlProvider(null), (_, _) => setState(_clear));
    ref.listen(bindingsAppliedProvider(widget.profileId), (_, next) {
      if (next.value != true || next.isLoading) setState(_clear);
    });
    ref.listen(selectedMapProvider, (_, _) => setState(_clear));
    final labels = context.appLocalizations;
    final busy = _checking != null;
    final ready =
        ref.watch(currentProfileIdProvider) == widget.profileId &&
        ref.watch(coreStatusProvider) == CoreStatus.connected &&
        ref.watch(runTimeProvider.select((runtime) => runtime != null)) &&
        ref.watch(bindingsAppliedProvider(widget.profileId)).value == true;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        padding: const EdgeInsets.all(16),
        inert: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 12,
          children: [
            Row(
              children: [
                const GlyphIcon(AppGlyphs.layers, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.chain.name,
                    style: AppTextStyle.headline.of(context),
                  ),
                ),
                Switch(
                  value: widget.chain.enabled,
                  onChanged: widget.onChanged,
                ),
              ],
            ),
            for (var index = 0; index < widget.chain.hops.length; index++)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labels.proxyChainHopLabel(index + 1),
                    style: AppTextStyle.caption1
                        .of(context)
                        .copyWith(color: context.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.chain.hops[index],
                      style: AppTextStyle.subheadline.of(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_checking == index)
                    const ActivityIndicator(size: 16)
                  else
                    Text(
                      _failed.contains(index)
                          ? labels.error
                          : _delays.containsKey(index)
                          ? _delays[index]! > 0
                                ? '${_delays[index]} ms'
                                : delayFailureText(_delays[index]!, labels)
                          : labels.proxyChainUnchecked,
                      style: AppTextStyle.caption1
                          .of(context)
                          .copyWith(
                            color: _failed.contains(index)
                                ? context.colorScheme.error
                                : context.colorScheme.delayColor(
                                    _delays[index],
                                  ),
                          ),
                    ),
                ],
              ),
            Text(
              labels.proxyChainLatencyHint,
              style: AppTextStyle.caption1
                  .of(context)
                  .copyWith(color: context.colorScheme.onSurfaceVariant),
            ),
            if (_delays.containsKey(widget.chain.hops.length - 1))
              Text(
                '${labels.proxyChainTotal}: ${_delays[widget.chain.hops.length - 1]! > 0 ? '${_delays[widget.chain.hops.length - 1]} ms' : delayFailureText(_delays[widget.chain.hops.length - 1]!, labels)}',
                style: AppTextStyle.headline.of(context),
              ),
            if (!ready) Text(labels.proxyChainApplyFirst),
            ErrorBanner(message: _error),
            TonalButton(
              label: busy ? labels.loading : labels.proxyChainCheck,
              onPressed: busy || !ready || !widget.chain.enabled
                  ? null
                  : _check,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChainForm extends ConsumerStatefulWidget {
  const _ChainForm({required this.profileId, this.chain});

  final int profileId;
  final ProxyChain? chain;

  @override
  ConsumerState<_ChainForm> createState() => _ChainFormState();
}

class _ChainFormState extends ConsumerState<_ChainForm> {
  late final _name = TextEditingController(text: widget.chain?.name ?? '');
  late final List<String> _hops = [...?widget.chain?.hops];
  late bool _hidden = widget.chain?.hidden ?? false;
  late final Set<String> _targets = {...?widget.chain?.targets};
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<ClashConfig?> _loadInventory() async {
    try {
      return await ref
          .read(profileBindingsActionProvider.notifier)
          .inventory(widget.profileId);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
      return null;
    }
  }

  Future<void> _chooseHop([int? index]) async {
    final config = await _loadInventory();
    if (config == null || !mounted) return;
    final labels = context.appLocalizations;
    final names =
        [
              ...config.proxyGroups.map((group) => group.name),
              ...config.proxies.map((proxy) => proxy.name),
            ]
            .where(
              (name) =>
                  !_hops.contains(name) ||
                  (index != null && _hops[index] == name),
            )
            .toList();
    final result = await showSheet<String>(
      context: context,
      builder: (_) => SelectionSheet<String>(
        title: labels.proxyChainHops,
        sections: [SelectionSection(items: names)],
        labelBuilder: (name) => name,
        selectedOf: (_) => index == null ? '' : _hops[index],
        onSelected: (name) => Navigator.of(context).pop(name),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (index == null) {
        _hops.add(result);
      } else {
        _hops[index] = result;
      }
      _error = null;
    });
  }

  Future<void> _chooseTarget() async {
    final config = await _loadInventory();
    if (config == null || !mounted) return;
    final labels = context.appLocalizations;
    final result = await showSheet<String>(
      context: context,
      builder: (_) => SelectionSheet<String>(
        title: labels.bindingTargetGroups,
        sections: [
          SelectionSection(
            items: {
              ...config.proxyGroups
                  .where(
                    (group) => attachableGroupTypes.contains(group.type.value),
                  )
                  .map((group) => group.name),
              ..._targets,
            }.toList(),
          ),
        ],
        labelBuilder: (name) => '${_targets.contains(name) ? '✓ ' : ''}$name',
        selectedOf: (_) => null,
        onSelected: (name) => Navigator.of(context).pop(name),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (!_targets.remove(result)) _targets.add(result);
    });
  }

  void _move(int index, int offset) {
    final next = index + offset;
    if (next < 0 || next >= _hops.length) return;
    setState(() {
      final hop = _hops.removeAt(index);
      _hops.insert(next, hop);
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final chain = ProxyChain(
        id: widget.chain?.id ?? uniqueId,
        name: _name.text.trim(),
        hops: List.of(_hops),
        enabled: widget.chain?.enabled ?? true,
        hidden: _hidden,
        targetGroups: _targets.toList(),
      );
      final profile = ref.read(profileProvider(widget.profileId));
      if (profile == null) throw StateError('Profile no longer exists');
      await ref
          .read(profileBindingsActionProvider.notifier)
          .validate(
            profile.copyWith(
              overrides: profile.overrides.copyWith(
                chainsEnabled: true,
                chains: [
                  ...profile.overrides.chains.where(
                    (item) => item.id != chain.id,
                  ),
                  chain.copyWith(enabled: true),
                ],
              ),
            ),
          );
      if (mounted) Navigator.of(context).pop(chain);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = context.appLocalizations;
    return FormPage(
      title: labels.proxyChains,
      saving: _saving,
      error: _error,
      onSave: _save,
      children: [
        generateSection(
          title: labels.proxyChains,
          items: [
            FormRow(
              title: labels.name,
              trailing: FormRowTextField(controller: _name),
            ),
            FormRow(
              title: labels.bindingTargetGroups,
              trailing: Text(
                _targets.isEmpty ? labels.none : _targets.join(' / '),
              ),
              onPressed: _chooseTarget,
            ),
            ListItem.toggle(
              title: Text(labels.proxyChainHidden),
              value: _hidden,
              onChanged: (value) => setState(() => _hidden = value),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            labels.proxyChainHelp,
            style: AppTextStyle.footnote.of(context),
          ),
        ),
        Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(labels.proxyChainClient, textAlign: TextAlign.center),
              for (var index = 0; index < _hops.length; index++) ...[
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: GlyphIcon(AppGlyphs.arrowDown),
                ),
                ContextMenuRegion(
                  menuItems: [
                    if (index > 0)
                      PopupMenuItem(
                        glyph: AppGlyphs.arrowUp,
                        label: labels.proxyChainMoveUp,
                        onPressed: () => _move(index, -1),
                      ),
                    if (index + 1 < _hops.length)
                      PopupMenuItem(
                        glyph: AppGlyphs.arrowDown,
                        label: labels.proxyChainMoveDown,
                        onPressed: () => _move(index, 1),
                      ),
                    PopupMenuItem(
                      glyph: AppGlyphs.delete,
                      label: labels.remove,
                      danger: true,
                      onPressed: () => setState(() => _hops.removeAt(index)),
                    ),
                  ],
                  child: DecorationListItem(
                    title: Text('${index + 1}. ${_hops[index]}'),
                    onPressed: () => _chooseHop(index),
                  ),
                ),
              ],
              const Padding(
                padding: EdgeInsets.all(8),
                child: GlyphIcon(AppGlyphs.arrowDown),
              ),
              Text(labels.proxyChainDestination, textAlign: TextAlign.center),
            ],
          ),
        ),
        if (_hops.length < 8)
          MoreActionButton(label: labels.add, onPressed: _chooseHop),
      ],
    );
  }
}
