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

class RouteTraceView extends ConsumerStatefulWidget {
  const RouteTraceView({super.key});

  @override
  ConsumerState<RouteTraceView> createState() => _RouteTraceViewState();
}

class _RouteTraceViewState extends ConsumerState<RouteTraceView> {
  late final _core = ref.read(coreHandlerProvider);
  final _targetController = TextEditingController(text: 'www.google.com');
  final _portController = TextEditingController(text: '443');

  String _network = 'tcp';
  bool _running = false;
  RouteTraceResult? _result;

  @override
  void dispose() {
    _targetController.dispose();
    _portController.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final target = _targetController.text.trim();
    if (target.isEmpty || _running) return;
    final port = int.tryParse(_portController.text.trim()) ?? 443;
    setState(() {
      _running = true;
    });
    try {
      final res = await _core.routeTrace(
        RouteTraceParams(
          target: target,
          network: _network,
          port: port.clamp(1, 65535),
        ),
      );
      if (!mounted) return;
      setState(() => _result = res);
    } catch (error) {
      if (!mounted) return;
      setState(
        () =>
            _result = RouteTraceResult(target: target, error: error.toString()),
      );
    } finally {
      if (mounted) {
        setState(() => _running = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final res = _result;
    return Scaffold(
      title: l10n.routeTrace,
      body: Builder(
        builder: (context) => ToolboxScrollBody(
          children: [
            generateSection(
              items: [
                FormRow(
                  title: l10n.target,
                  trailing: FormRowTextField(
                    controller: _targetController,
                    autocorrect: false,
                    hintText: 'example.com / 1.1.1.1',
                    onFieldSubmitted: (_) => unawaited(_run()),
                  ),
                ),
                FormRow(
                  title: l10n.port,
                  trailing: FormRowTextField(
                    controller: _portController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    hintText: '443',
                  ),
                ),
              ],
            ),
            SegmentedControl<String>(
              segments: const [('tcp', 'TCP'), ('udp', 'UDP')],
              value: _network,
              onChanged: (value) => setState(() => _network = value),
            ),
            FilledButton.icon(
              onPressed: _running ? null : _run,
              icon: const GlyphIcon(AppGlyphs.split, fill: 1),
              label: Text(l10n.run),
            ),
            if (_running) const LinearProgressIndicator(),
            if (res != null && res.error.isNotEmpty)
              ToolboxErrorCard(message: toolboxErrorText(context, res.error)),
            if (res != null && res.error.isEmpty) ...[
              ToolboxMetricGrid(
                items: [
                  ToolboxMetricItem(
                    label: l10n.routeTraceMatched,
                    value: res.fallbackDirect
                        ? l10n.routeTraceFallbackDirect
                        : (res.matched?.adapter ?? l10n.none),
                    color: colorScheme.primary,
                  ),
                  ToolboxMetricItem(
                    label: l10n.mode,
                    value: res.mode.isEmpty ? '—' : res.mode,
                  ),
                  ToolboxMetricItem(
                    label: l10n.latency,
                    value: toolboxFormatMillis(res.matchTime),
                  ),
                  ToolboxMetricItem(
                    label: l10n.routeTraceChecked(res.checked, res.total),
                    value: '${res.checked}/${res.total}',
                  ),
                ],
              ),
              generateSection(
                items: [
                  if (res.chains.isNotEmpty)
                    ListItem(
                      title: Text(l10n.routeTraceChain),
                      subtitle: Text(
                        res.chains.map((item) => item.name).join(' -> '),
                      ),
                      trailing: Text(
                        res.supportUdp ? l10n.routeTraceUdpSupported : 'TCP',
                        style: AppTextStyle.caption1
                            .of(context)
                            .copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  if (res.matched != null)
                    ListItem(
                      title: Text(l10n.routeTraceMatched),
                      subtitle: Text(
                        '${res.matched!.type}: ${res.matched!.payload}',
                      ),
                    ),
                  if (res.resolvedIps.isNotEmpty || res.dstIp.isNotEmpty)
                    ListItem(
                      title: const Text('IP'),
                      subtitle: Text(
                        res.resolvedIps.isNotEmpty
                            ? res.resolvedIps.join(', ')
                            : res.dstIp,
                      ),
                    ),
                ],
              ),
              if (res.steps.isNotEmpty)
                generateSection(
                  title: l10n.routeTraceSteps,
                  items: [
                    for (final step in res.steps.take(100))
                      ListItem(
                        title: Text('#${step.index + 1} ${step.type}'),
                        subtitle: Text(
                          '${step.payload} -> ${step.adapter}'
                          '${step.skipped.isNotEmpty ? ' (${step.skipped})' : ''}',
                        ),
                        trailing: step.matched
                            ? GlyphIcon(
                                AppGlyphs.checkCircle,
                                color: colorScheme.success,
                                size: 18,
                              )
                            : null,
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
