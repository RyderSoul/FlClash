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

class SpeedTestView extends ConsumerStatefulWidget {
  const SpeedTestView({super.key});

  @override
  ConsumerState<SpeedTestView> createState() => _SpeedTestViewState();
}

class _SpeedTestViewState extends ConsumerState<SpeedTestView>
    with CoreEventListener {
  late final _core = ref.read(coreHandlerProvider);

  String _provider = 'cloudflare';
  String _protocol = 'h1';
  String _proxy = '';
  int _duration = 10;
  int _streams = 8;
  SpeedtestNetServer? _selectedServer;
  SpeedTestState? _state;
  bool _running = false;
  bool _probing = false;

  @override
  void initState() {
    super.initState();
    coreEventManager.addListener(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_probe());
    });
  }

  @override
  void dispose() {
    coreEventManager.removeListener(this);
    if (_running) {
      unawaited(_core.cancelSpeedTest());
    }
    super.dispose();
  }

  @override
  void onSpeedTest(SpeedTestState state) {
    if (!mounted || !_running) return;
    setState(() {
      _state = state;
    });
  }

  SpeedTestParams _buildParams() => SpeedTestParams(
    provider: _provider,
    proxy: _proxy,
    duration: _duration,
    protocol: _protocol,
    streams: _streams,
    server: _provider == 'speedtest' ? _selectedServer : null,
  );

  Future<void> _probe() async {
    setState(() {
      _probing = true;
    });
    try {
      final result = await _core.probeSpeedTest(_buildParams());
      if (!mounted) return;
      setState(() {
        _state = result;
      });
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          _probing = false;
        });
      }
    }
  }

  Future<void> _start() async {
    if (_running) return;
    setState(() {
      _running = true;
      _state = SpeedTestState(
        provider: _provider,
        protocol: _protocol,
        streams: _streams,
        duration: _duration,
        phase: 'connecting',
      );
    });
    try {
      final result = await _core.startSpeedTest(_buildParams());
      if (!mounted) return;
      setState(() {
        _state = result;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _state = (_state ?? const SpeedTestState()).copyWith(
          error: error.toString(),
          phase: 'done',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _running = false;
        });
      }
    }
  }

  Future<void> _cancel() async {
    await _core.cancelSpeedTest();
  }

  Future<void> _pickServer() async {
    final l10n = context.appLocalizations;
    try {
      final servers = await _core.getSpeedTestServers(
        SpeedTestServersParams(proxy: _proxy),
      );
      if (!mounted) return;
      final items = <SpeedtestNetServer?>[null, ...servers];
      final chosen = await showSheet<SpeedtestNetServer?>(
        context: context,
        builder: (sheetContext) => SelectionSheet<SpeedtestNetServer?>(
          title: l10n.server,
          sections: [SelectionSection(items: items)],
          labelBuilder: (item) {
            if (item == null) return l10n.defaultText;
            final latency = item.latency > 0
                ? ' (${item.latency.toStringAsFixed(0)} ms)'
                : '';
            return '${item.sponsor} - ${item.name}$latency';
          },
          selectedOf: (_) => _selectedServer,
          onSelected: (item) => Navigator.of(sheetContext).pop(item),
        ),
      );
      if (!mounted) return;
      setState(() {
        _selectedServer = chosen;
      });
      if (_provider == 'speedtest') {
        unawaited(_probe());
      }
    } catch (error) {
      if (!mounted) return;
      dialogs.showBanner(
        toolboxErrorText(context, error.toString()),
        level: BannerLevel.warning,
      );
    }
  }

  Future<void> _pickDuration() async {
    final l10n = context.appLocalizations;
    final picked = await showSheet<int>(
      context: context,
      builder: (sheetContext) => SelectionSheet<int>(
        title: l10n.duration,
        sections: const [
          SelectionSection(items: [5, 10, 15, 30]),
        ],
        labelBuilder: (item) => '${item}s',
        selectedOf: (_) => _duration,
        onSelected: (item) => Navigator.of(sheetContext).pop(item),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _duration = picked);
    }
  }

  Future<void> _pickStreams() async {
    final l10n = context.appLocalizations;
    final picked = await showSheet<int>(
      context: context,
      builder: (sheetContext) => SelectionSheet<int>(
        title: l10n.speedTestStreams,
        sections: const [
          SelectionSection(items: [1, 4, 8, 16]),
        ],
        labelBuilder: (item) => '$item',
        selectedOf: (_) => _streams,
        onSelected: (item) => Navigator.of(sheetContext).pop(item),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _streams = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final state = _state;
    return Scaffold(
      title: l10n.speedTest,
      body: Builder(
        builder: (context) => ToolboxScrollBody(
          children: [
            SegmentedControl<String>(
              segments: const [
                ('cloudflare', 'Cloudflare'),
                ('apple', 'Apple'),
                ('speedtest', 'Speedtest.net'),
              ],
              value: _provider,
              onChanged: (value) {
                if (_running) return;
                setState(() => _provider = value);
                unawaited(_probe());
              },
            ),
            SegmentedControl<String>(
              segments: const [('h1', 'TCP'), ('h2', 'HTTP/2'), ('h3', 'QUIC')],
              value: _protocol,
              onChanged: (value) {
                if (_running) return;
                setState(() => _protocol = value);
              },
            ),
            generateSection(
              items: [
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
                            unawaited(_probe());
                          }
                        },
                  trailing: Text(
                    _proxy.isEmpty ? l10n.speedTestFollowRules : _proxy,
                  ),
                ),
                if (_provider == 'speedtest')
                  FormRow(
                    title: l10n.server,
                    onPressed: _running ? null : _pickServer,
                    trailing: Text(
                      _selectedServer == null
                          ? l10n.defaultText
                          : '${_selectedServer!.sponsor} (${_selectedServer!.name})',
                    ),
                  ),
                FormRow(
                  title: l10n.duration,
                  onPressed: _running ? null : _pickDuration,
                  trailing: Text('${_duration}s'),
                ),
                FormRow(
                  title: l10n.speedTestStreams,
                  onPressed: _running ? null : _pickStreams,
                  trailing: Text('$_streams'),
                ),
              ],
            ),
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _running ? _cancel : _start,
                    icon: GlyphIcon(
                      _running ? AppGlyphs.close : AppGlyphs.playPause(0),
                      fill: 1,
                    ),
                    label: Text(_running ? l10n.cancel : l10n.start),
                  ),
                ),
                if (!_running)
                  TonalButton(
                    size: TonalButtonSize.section,
                    onPressed: _probing ? null : _probe,
                    label: l10n.refresh,
                  ),
              ],
            ),
            if (_running || _probing)
              LinearProgressIndicator(
                value: _running && (state?.progress ?? 0) > 0
                    ? state!.progress.clamp(0.0, 1.0)
                    : null,
              ),
            if (state != null && state.error.isNotEmpty)
              ToolboxErrorCard(message: toolboxErrorText(context, state.error)),
            if (state != null) ...[
              ToolboxMetricGrid(
                items: [
                  ToolboxMetricItem(
                    label: l10n.download,
                    value: toolboxFormatSpeed(state.download),
                    color: colorScheme.primary,
                  ),
                  ToolboxMetricItem(
                    label: l10n.upload,
                    value: toolboxFormatSpeed(state.upload),
                    color: colorScheme.primary,
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
                    label: l10n.speedTestRpm,
                    value: state.rpm > 0 ? '${state.rpm}' : '—',
                  ),
                  ToolboxMetricItem(
                    label: l10n.speedTestExitIp,
                    value: state.exitIp.isEmpty ? '—' : state.exitIp,
                  ),
                ],
              ),
              generateSection(
                items: [
                  if (state.outbound != null &&
                      state.outbound!.chains.isNotEmpty)
                    ListItem(
                      title: Text(l10n.routeTraceChain),
                      subtitle: Text(state.outbound!.chains.join(' -> ')),
                      trailing: state.fallback
                          ? Text(
                              l10n.speedTestFallback,
                              style: AppTextStyle.caption1
                                  .of(context)
                                  .copyWith(color: colorScheme.warning),
                            )
                          : null,
                    ),
                  if (state.server != null &&
                      (state.server!.host.isNotEmpty ||
                          state.server!.colo.isNotEmpty ||
                          state.server!.sponsor.isNotEmpty))
                    ListItem(
                      title: Text(l10n.server),
                      subtitle: Text(
                        [
                          if (state.server!.sponsor.isNotEmpty)
                            state.server!.sponsor,
                          if (state.server!.city.isNotEmpty) state.server!.city,
                          if (state.server!.country.isNotEmpty)
                            state.server!.country,
                          if (state.server!.colo.isNotEmpty) state.server!.colo,
                          if (state.server!.ip.isNotEmpty) state.server!.ip,
                        ].join(' · '),
                      ),
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
