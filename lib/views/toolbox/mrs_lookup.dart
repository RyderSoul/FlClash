import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'toolbox_shared.dart';

class MrsLookupView extends ConsumerStatefulWidget {
  const MrsLookupView({super.key});

  @override
  ConsumerState<MrsLookupView> createState() => _MrsLookupViewState();
}

class _MrsLookupViewState extends ConsumerState<MrsLookupView> {
  late final _core = ref.read(coreHandlerProvider);
  final _targetController = TextEditingController(text: 'www.google.com');

  bool _resolve = true;
  bool _preparing = false;
  bool _searching = false;
  MrsPrepareResult? _prepared;
  MrsLookupResult? _result;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_prepare());
    });
  }

  @override
  void dispose() {
    _targetController.dispose();
    if (_searching) {
      unawaited(_core.cancelMrsLookup());
    }
    super.dispose();
  }

  Future<void> _prepare() async {
    setState(() => _preparing = true);
    try {
      final res = await _core.prepareMrs();
      if (!mounted) return;
      setState(() => _prepared = res);
    } catch (_) {
    } finally {
      if (mounted) setState(() => _preparing = false);
    }
  }

  Future<void> _lookup() async {
    final target = _targetController.text.trim();
    if (target.isEmpty || _searching) return;
    setState(() => _searching = true);
    try {
      final res = await _core.lookupMrs(
        MrsLookupParams(target: target, resolve: _resolve),
      );
      if (!mounted) return;
      setState(() => _result = res);
    } catch (error) {
      if (!mounted) return;
      setState(
        () =>
            _result = MrsLookupResult(target: target, error: error.toString()),
      );
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final prepared = _prepared;
    final res = _result;
    return Scaffold(
      title: l10n.mrsLookup,
      body: Builder(
        builder: (context) => ToolboxScrollBody(
          children: [
            if (prepared != null && prepared.error.isNotEmpty)
              ToolboxErrorCard(
                message: toolboxErrorText(context, prepared.error),
              ),
            if (prepared != null && prepared.error.isEmpty)
              ToolboxMetricGrid(
                items: [
                  ToolboxMetricItem(
                    label: 'Geosite',
                    value: '${prepared.geosite}',
                  ),
                  ToolboxMetricItem(label: 'GeoIP', value: '${prepared.geoip}'),
                ],
              ),
            generateSection(
              items: [
                FormRow(
                  title: l10n.target,
                  trailing: FormRowTextField(
                    controller: _targetController,
                    autocorrect: false,
                    hintText: 'google.com / 8.8.8.8',
                    onFieldSubmitted: (_) => unawaited(_lookup()),
                  ),
                ),
                ListItem.toggle(
                  title: Text(l10n.mrsResolve),
                  value: _resolve,
                  onChanged: (value) => setState(() => _resolve = value),
                ),
              ],
            ),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _searching
                        ? () => unawaited(_core.cancelMrsLookup())
                        : _lookup,
                    icon: GlyphIcon(
                      _searching ? AppGlyphs.close : AppGlyphs.rulePresets,
                      fill: 1,
                    ),
                    label: Text(_searching ? l10n.cancel : l10n.run),
                  ),
                ),
                TonalButton(
                  size: TonalButtonSize.section,
                  onPressed: _preparing ? null : _prepare,
                  label: l10n.mrsPrepare,
                ),
              ],
            ),
            if (_preparing || _searching) const LinearProgressIndicator(),
            if (res != null && res.error.isNotEmpty)
              ToolboxErrorCard(message: toolboxErrorText(context, res.error)),
            if (res != null && res.error.isEmpty) ...[
              if (res.ips.isNotEmpty)
                generateSection(
                  items: [
                    ListItem(
                      title: const Text('IP'),
                      subtitle: Text(res.ips.join(', ')),
                    ),
                  ],
                ),
              if (res.matches.isEmpty)
                Card(
                  radius: AppCorner.lg,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      l10n.nullTip(l10n.rules),
                      style: AppTextStyle.subheadline
                          .of(context)
                          .copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                )
              else
                generateSection(
                  title: l10n.rules,
                  items: [
                    for (final match in res.matches)
                      ListItem.open(
                        title: Text(match.name),
                        subtitle: Text(
                          '${match.kind} · ${match.via} (${match.count})',
                        ),
                        trailing: match.referenced
                            ? Text(
                                l10n.mrsReferenced,
                                style: AppTextStyle.caption1
                                    .of(context)
                                    .copyWith(color: colorScheme.primary),
                              )
                            : null,
                        widget: _MrsDumpView(match: match),
                      ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MrsDumpView extends ConsumerStatefulWidget {
  const _MrsDumpView({required this.match});

  final MrsMatch match;

  @override
  ConsumerState<_MrsDumpView> createState() => _MrsDumpViewState();
}

class _MrsDumpViewState extends ConsumerState<_MrsDumpView> {
  late final _core = ref.read(coreHandlerProvider);
  bool _loading = true;
  String _content = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_load());
    });
  }

  Future<void> _load() async {
    try {
      final text = await _core.dumpMrs(widget.match.file);
      if (!mounted) return;
      setState(() {
        _content = text;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    return Scaffold(
      title: widget.match.name,
      isLoading: _loading,
      iconActions: [
        if (_content.isNotEmpty)
          IconButtonData(
            glyph: AppGlyphs.copy,
            tooltip: l10n.copy,
            onPressed: () => unawaited(copyToolText(context, _content)),
          ),
      ],
      body: _loading
          ? const Center(child: ActivityIndicator())
          : Builder(
              builder: (context) => ToolboxScrollBody(
                children: [
                  Card(
                    radius: AppCorner.lg,
                    inert: true,
                    padding: const EdgeInsets.all(14),
                    child: SelectableText(
                      _content.isEmpty ? l10n.nullTip(l10n.rules) : _content,
                      style: AppTextStyle.footnote.of(context),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
