import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/common/profile_binding.dart';
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
                child: ListItem.toggle(
                  title: Text(chain.name),
                  subtitle: Text(chain.hops.join(' → ')),
                  value: chain.enabled,
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

  Future<void> _chooseHop([int? index]) async {
    final config = await ref
        .read(profileBindingsActionProvider.notifier)
        .inventory(widget.profileId);
    if (!mounted) return;
    final labels = context.appLocalizations;
    final position = index ?? _hops.length;
    final names =
        [
              if (position == 0)
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
    final config = await ref
        .read(profileBindingsActionProvider.notifier)
        .inventory(widget.profileId);
    if (!mounted) return;
    final labels = context.appLocalizations;
    final result = await showSheet<String>(
      context: context,
      builder: (_) => SelectionSheet<String>(
        title: labels.proxyChainTarget,
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
              title: labels.proxyChainTarget,
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
