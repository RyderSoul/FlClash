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

class LocalPingView extends ConsumerStatefulWidget {
  const LocalPingView({super.key});

  @override
  ConsumerState<LocalPingView> createState() => _LocalPingViewState();
}

class _LocalPingViewState extends ConsumerState<LocalPingView>
    with CoreEventListener {
  late final _core = ref.read(coreHandlerProvider);
  final _targetController = TextEditingController(text: '1.1.1.1');
  final _portController = TextEditingController(text: '443');
  final _countController = TextEditingController(text: '10');
  final _intervalController = TextEditingController(text: '1000');

  String _protocol = 'icmp';
  bool _running = false;
  LocalPingState? _state;
  List<LocalPingReply> _replies = const [];

  @override
  void initState() {
    super.initState();
    coreEventManager.addListener(this);
  }

  @override
  void dispose() {
    coreEventManager.removeListener(this);
    _targetController.dispose();
    _portController.dispose();
    _countController.dispose();
    _intervalController.dispose();
    if (_running) {
      unawaited(_core.cancelLocalPing());
    }
    super.dispose();
  }

  @override
  void onLocalPing(LocalPingState state) {
    if (!mounted || !_running) return;
    setState(() {
      _state = state;
      if (state.reply != null) {
        _replies = [
          ..._replies.where((item) => item.seq != state.reply!.seq),
          state.reply!,
        ];
      } else if (state.replies.isNotEmpty) {
        _replies = state.replies;
      }
    });
  }

  Future<void> _start() async {
    final target = _targetController.text.trim();
    if (target.isEmpty || _running) return;
    final port = int.tryParse(_portController.text.trim()) ?? 443;
    final count = (int.tryParse(_countController.text.trim()) ?? 10).clamp(
      1,
      9999,
    );
    final interval = (int.tryParse(_intervalController.text.trim()) ?? 1000)
        .clamp(100, 10000);
    setState(() {
      _running = true;
      _replies = const [];
      _state = LocalPingState(
        target: target,
        protocol: _protocol,
        count: count,
      );
    });
    try {
      final res = await _core.startLocalPing(
        LocalPingParams(
          target: target,
          protocol: _protocol,
          port: _protocol == 'icmp' ? 0 : port.clamp(1, 65535),
          count: count,
          interval: interval,
        ),
      );
      if (!mounted) return;
      setState(() {
        _state = res;
        if (res.replies.isNotEmpty) {
          _replies = res.replies;
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(
        () => _state = (_state ?? const LocalPingState()).copyWith(
          error: error.toString(),
          phase: 'done',
        ),
      );
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    final colorScheme = context.colorScheme;
    final state = _state;
    final okReplies = [
      for (final reply in _replies)
        if (reply.status == 'ok' && reply.rtt > 0) reply.rtt,
    ];
    final sent = _replies.length;
    final lost = sent - okReplies.length;
    final avg = okReplies.isEmpty
        ? 0.0
        : okReplies.reduce((a, b) => a + b) / okReplies.length;
    final minRtt = okReplies.isEmpty
        ? 0.0
        : okReplies.reduce((a, b) => a < b ? a : b);
    final maxRtt = okReplies.isEmpty
        ? 0.0
        : okReplies.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      title: l10n.localPing,
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
                    hintText: '1.1.1.1 / example.com',
                    onFieldSubmitted: (_) => unawaited(_start()),
                  ),
                ),
                if (_protocol != 'icmp')
                  FormRow(
                    title: l10n.port,
                    trailing: FormRowTextField(
                      controller: _portController,
                      autocorrect: false,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                FormRow(
                  title: l10n.localPingCount,
                  trailing: FormRowTextField(
                    controller: _countController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                  ),
                ),
                FormRow(
                  title: l10n.interval,
                  trailing: FormRowTextField(
                    controller: _intervalController,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    hintText: 'ms',
                  ),
                ),
              ],
            ),
            SegmentedControl<String>(
              segments: const [
                ('icmp', 'ICMP'),
                ('tcp', 'TCP'),
                ('udp', 'UDP'),
              ],
              value: _protocol,
              onChanged: (value) {
                if (_running) return;
                setState(() => _protocol = value);
              },
            ),
            FilledButton.icon(
              onPressed: _running
                  ? () => unawaited(_core.cancelLocalPing())
                  : _start,
              icon: GlyphIcon(
                _running ? AppGlyphs.close : AppGlyphs.target,
                fill: 1,
              ),
              label: Text(_running ? l10n.cancel : l10n.start),
            ),
            if (_running) const LinearProgressIndicator(),
            if (state != null && state.error.isNotEmpty)
              ToolboxErrorCard(message: toolboxErrorText(context, state.error)),
            if (sent > 0) ...[
              ToolboxMetricGrid(
                items: [
                  ToolboxMetricItem(
                    label: l10n.localPingMin,
                    value: toolboxFormatMillis(minRtt),
                  ),
                  ToolboxMetricItem(
                    label: l10n.localPingAvg,
                    value: toolboxFormatMillis(avg),
                    color: colorScheme.primary,
                  ),
                  ToolboxMetricItem(
                    label: l10n.localPingMax,
                    value: toolboxFormatMillis(maxRtt),
                  ),
                  ToolboxMetricItem(
                    label: l10n.localPingLost,
                    value: '$lost / $sent',
                    color: lost > 0 ? colorScheme.warning : null,
                  ),
                ],
              ),
              generateSection(
                items: [
                  for (final reply in _replies.reversed.take(50))
                    ListItem(
                      title: Text(
                        '#${reply.seq} · ${reply.status.toUpperCase()}',
                      ),
                      subtitle: Text(
                        [
                          if (reply.rtt > 0) toolboxFormatMillis(reply.rtt),
                          if (reply.ttl > 0) 'TTL ${reply.ttl}',
                          if (reply.bytes > 0) '${reply.bytes} B',
                        ].join(' · '),
                      ),
                      trailing: GlyphIcon(
                        reply.status == 'ok'
                            ? AppGlyphs.checkCircle
                            : AppGlyphs.warning,
                        size: 18,
                        color: reply.status == 'ok'
                            ? colorScheme.success
                            : colorScheme.warning,
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
