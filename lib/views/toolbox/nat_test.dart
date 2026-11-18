import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/event.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'toolbox_shared.dart';

const _stunPresetServers = [
  'stun.cloudflare.com:3478',
  'stun.l.google.com:19302',
  'stun.miwifi.com:3478',
  'stun.voipgate.com:3478',
  'stun.nextcloud.com:443',
];

class NatTestView extends ConsumerStatefulWidget {
  const NatTestView({super.key});

  @override
  ConsumerState<NatTestView> createState() => _NatTestViewState();
}

class _NatTestViewState extends ConsumerState<NatTestView>
    with CoreEventListener {
  late final _core = ref.read(coreHandlerProvider);
  final _serverController = TextEditingController(
    text: _stunPresetServers.first,
  );

  String _proxy = '';
  bool _running = false;
  StunTestState? _state;

  @override
  void initState() {
    super.initState();
    coreEventManager.addListener(this);
  }

  @override
  void dispose() {
    coreEventManager.removeListener(this);
    _serverController.dispose();
    if (_running) {
      unawaited(_core.cancelStunTest());
    }
    super.dispose();
  }

  @override
  void onStunTest(StunTestState state) {
    if (!mounted || !_running) return;
    setState(() => _state = state);
  }

  Future<void> _start() async {
    if (_running) return;
    setState(() {
      _running = true;
      _state = StunTestState(
        phase: 'connecting',
        server: _serverController.text.trim(),
      );
    });
    try {
      final res = await _core.startStunTest(
        StunTestParams(server: _serverController.text.trim(), proxy: _proxy),
      );
      if (!mounted) return;
      setState(() => _state = res);
    } catch (error) {
      if (!mounted) return;
      setState(
        () => _state = (_state ?? const StunTestState()).copyWith(
          error: error.toString(),
          phase: 'done',
        ),
      );
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  Future<void> _pickServer() async {
    final picked = await showSheet<String>(
      context: context,
      builder: (sheetContext) => SelectionSheet<String>(
        title: context.appLocalizations.server,
        sections: const [SelectionSection(items: _stunPresetServers)],
        labelBuilder: (item) => item,
        selectedOf: (_) => _serverController.text.trim(),
        onSelected: (item) => Navigator.of(sheetContext).pop(item),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _serverController.text = picked);
    }
  }

  String _natLabel(String type) {
    return switch (type) {
      'open' => 'OPEN',
      'full-cone' => 'NAT1 · Full Cone',
      'restricted' => 'NAT2 · Restricted',
      'port-restricted' => 'NAT3 · Port Restricted',
      'symmetric' => 'NAT4 · Symmetric',
      'cone' => 'NAT1-3 · Cone',
      'blocked' => 'UDP Blocked',
      _ => context.appLocalizations.unknown,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final state = _state;
    return Scaffold(
      title: l10n.natTest,
      body: Builder(
        builder: (context) => ToolboxScrollBody(
          children: [
            generateSection(
              items: [
                FormRow(
                  title: l10n.server,
                  trailing: FormRowTextField(
                    controller: _serverController,
                    autocorrect: false,
                    hintText: 'stun.cloudflare.com:3478',
                  ),
                ),
                FormRow(
                  title: l10n.search,
                  onPressed: _running ? null : _pickServer,
                  trailing: Text(l10n.server),
                ),
                FormRow(
                  title: l10n.proxy,
                  onPressed: _running
                      ? null
                      : () async {
                          final picked = await pickToolboxProxy(
                            context,
                            ref,
                            _proxy,
                          );
                          if (picked != null && mounted) {
                            setState(() => _proxy = picked);
                          }
                        },
                  trailing: Text(
                    _proxy.isEmpty ? l10n.speedTestFollowRules : _proxy,
                  ),
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: _running
                  ? () => unawaited(_core.cancelStunTest())
                  : _start,
              icon: GlyphIcon(
                _running ? AppGlyphs.close : AppGlyphs.connections,
                fill: 1,
              ),
              label: Text(_running ? l10n.cancel : l10n.start),
            ),
            if (_running)
              LinearProgressIndicator(
                value: (state?.progress ?? 0) > 0
                    ? state!.progress.clamp(0.0, 1.0)
                    : null,
              ),
            if (state != null && state.error.isNotEmpty)
              ToolboxErrorCard(message: toolboxErrorText(context, state.error)),
            if (state != null && state.error.isEmpty) ...[
              ToolboxMetricGrid(
                items: [
                  ToolboxMetricItem(
                    label: l10n.natType,
                    value: state.natType.isEmpty
                        ? '—'
                        : _natLabel(state.natType),
                    color: colorScheme.primary,
                  ),
                  ToolboxMetricItem(
                    label: l10n.natMapping,
                    value: state.mapping.isEmpty ? '—' : state.mapping,
                  ),
                  ToolboxMetricItem(
                    label: l10n.natFiltering,
                    value: state.filtering.isEmpty ? '—' : state.filtering,
                  ),
                  ToolboxMetricItem(
                    label: l10n.latency,
                    value: toolboxFormatMillis(state.latency),
                  ),
                  ToolboxMetricItem(
                    label: l10n.natJitter,
                    value: toolboxFormatMillis(state.jitter),
                  ),
                  ToolboxMetricItem(
                    label: l10n.natPacketLoss,
                    value: '${(state.packetLoss * 100).toStringAsFixed(0)}%',
                  ),
                ],
              ),
              generateSection(
                items: [
                  if (state.externalIp.isNotEmpty)
                    ListItem(
                      title: Text(l10n.natEndpoint),
                      subtitle: Text(
                        '${state.externalIp}:${state.externalPort}',
                      ),
                      onTap: () => unawaited(
                        copyToolText(
                          context,
                          '${state.externalIp}:${state.externalPort}',
                        ),
                      ),
                    ),
                  if (state.localIp.isNotEmpty)
                    ListItem(
                      title: Text(l10n.natLocalEndpoint),
                      subtitle: Text('${state.localIp}:${state.localPort}'),
                    ),
                  ListItem(
                    title: Text(l10n.natRfc5780),
                    trailing: Text(
                      state.rfc5780
                          ? (state.portPreserved == 1
                                ? l10n.natPreserved
                                : l10n.natNotPreserved)
                          : l10n.none,
                    ),
                  ),
                  if (state.outbound != null &&
                      state.outbound!.chains.isNotEmpty)
                    ListItem(
                      title: Text(l10n.routeTraceChain),
                      subtitle: Text(state.outbound!.chains.join(' -> ')),
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
