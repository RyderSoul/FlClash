import 'dart:math' as math;

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/core/method.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/dashboard/style.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';

const _previewCount = 4;

Color _nodeColor(BuildContext context, int index) => switch (index % 4) {
  0 => context.colorScheme.primary,
  1 => context.colorScheme.tertiary,
  2 => DashboardColors.of(context).series2,
  _ => context.colorScheme.secondary,
};

mixin _NodeTrafficPolling<T extends ConsumerStatefulWidget>
    on
        ConsumerState<T>,
        WidgetsBindingObserver,
        ActivePollingMixin<T>,
        RouteMotionHoldMixin<T> {
  List<NodeTraffic> nodes = const [];
  bool unavailable = false;
  int upload = 0;
  int download = 0;

  int get total => upload + download;

  @override
  Duration get pollInterval => const Duration(seconds: 2);

  void acceptNodes(List<NodeTraffic> next) {
    nodes = next;
    upload = 0;
    download = 0;
    for (final node in next) {
      upload += node.up;
      download += node.down;
    }
  }

  @override
  Future<void> poll(PollGuard isCurrent) async {
    if (ref.read(coreStatusProvider) != CoreStatus.connected) return;
    try {
      final next = await ref.read(coreHandlerProvider).getNodeTraffic();
      if (!isCurrent()) return;
      updateWhenRouteSettled(
        () => setState(() {
          acceptNodes(next);
          unavailable = false;
        }),
      );
    } catch (error) {
      if (!isCurrent()) return;
      commonPrint.log(
        'node traffic: $error',
        logLevel: coreFailureLogLevel(error),
      );
      updateWhenRouteSettled(() => setState(() => unavailable = true));
    }
  }

  Widget status(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 18),
    child: Text(
      unavailable
          ? context.appLocalizations.nodeTrafficUnavailable
          : context.appLocalizations.nodeTrafficEmpty,
      textAlign: TextAlign.center,
      style: DashboardText.label(context),
    ),
  );
}

class NodeTrafficCard extends ConsumerStatefulWidget {
  const NodeTrafficCard({super.key});

  @override
  ConsumerState<NodeTrafficCard> createState() => _NodeTrafficCardState();
}

class _NodeTrafficCardState extends ConsumerState<NodeTrafficCard>
    with
        WidgetsBindingObserver,
        ActivePollingMixin<NodeTrafficCard>,
        RouteMotionHoldMixin<NodeTrafficCard>,
        _NodeTrafficPolling<NodeTrafficCard> {
  bool _detailOpen = false;

  @override
  bool get canPoll => super.canPoll && !_detailOpen;

  Future<void> _showDetail() async {
    if (_detailOpen) return;
    _detailOpen = true;
    stopPolling();
    try {
      await showSheet<void>(
        context: context,
        builder: (_) => _NodeTrafficSheet(initial: nodes),
      );
    } finally {
      _detailOpen = false;
      if (mounted) restartPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = context.appLocalizations;
    return DashboardCard(
      semanticLabel: labels.nodeTraffic,
      onTap: _showDetail,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.dataUsage,
            title: labels.nodeTraffic,
            chevron: true,
            trailing: [
              Text(
                labels.nodeTrafficSession,
                style: DashboardText.label(context),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _TrafficOverview(nodes: nodes, upload: upload, download: download),
          const SizedBox(height: 16),
          if (nodes.isEmpty)
            status(context)
          else ...[
            for (var i = 0; i < math.min(_previewCount, nodes.length); i++)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: _NodeTrafficRow(node: nodes[i], index: i, total: total),
              ),
            if (nodes.length > _previewCount)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  labels.viewAll,
                  textAlign: TextAlign.end,
                  style: DashboardText.label(context),
                ),
              ),
          ],
          const SizedBox(height: 12),
          if (unavailable && nodes.isNotEmpty)
            Text(
              labels.nodeTrafficUnavailable,
              style: DashboardText.label(context),
            ),
          Text(labels.nodeTrafficHint, style: DashboardText.label(context)),
        ],
      ),
    );
  }
}

class _TrafficOverview extends StatelessWidget {
  const _TrafficOverview({
    required this.nodes,
    required this.upload,
    required this.download,
  });

  final List<NodeTraffic> nodes;
  final int upload;
  final int download;

  @override
  Widget build(BuildContext context) {
    final total = upload + download;
    final colors = [
      for (var i = 0; i < _previewCount; i++) _nodeColor(context, i),
      DashboardColors.of(context).track,
    ];
    final top = nodes.take(_previewCount).map((node) => node.total).toList();
    final rest = total - top.fold<int>(0, (sum, value) => sum + value);
    return Row(
      spacing: 20,
      children: [
        SizedBox.square(
          dimension: 88,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _TrafficRing(
                values: [...top, if (rest > 0) rest],
                colors: colors,
                track: DashboardColors.of(context).track,
              ),
              child: Center(
                child: GlyphIcon(
                  AppGlyphs.dataUsage,
                  size: 28,
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                context.appLocalizations.totalTraffic,
                style: DashboardText.label(context),
              ),
              Text(
                dashboardTraffic(total),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DashboardText.figure(context, AppTextStyle.title1),
              ),
              Wrap(
                spacing: 12,
                runSpacing: 4,
                children: [
                  _DirectionTotal(
                    glyph: AppGlyphs.arrowUp,
                    label: context.appLocalizations.upload,
                    bytes: upload,
                  ),
                  _DirectionTotal(
                    glyph: AppGlyphs.arrowDown,
                    label: context.appLocalizations.download,
                    bytes: download,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DirectionTotal extends StatelessWidget {
  const _DirectionTotal({
    required this.glyph,
    required this.label,
    required this.bytes,
  });
  final Glyph glyph;
  final String label;
  final int bytes;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label ${dashboardTraffic(bytes)}',
    excludeSemantics: true,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 3,
      children: [
        GlyphIcon(glyph, size: 12, color: context.colorScheme.onSurfaceVariant),
        Flexible(
          child: Text(
            dashboardTraffic(bytes),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DashboardText.label(context),
          ),
        ),
      ],
    ),
  );
}

class _NodeTrafficRow extends StatelessWidget {
  const _NodeTrafficRow({
    required this.node,
    required this.index,
    required this.total,
  });
  final NodeTraffic node;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? node.total / total : 0.0;
    final color = _nodeColor(context, index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        DashboardCappedRow(
          start: Text(
            node.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: DashboardText.rowTitle(context),
          ),
          end: Text(
            dashboardTraffic(node.total),
            style: AppTextStyle.footnote
                .of(context, emphasized: true)
                .toTabular,
          ),
        ),
        ClipRSuperellipse(
          borderRadius: AppRadius.full,
          child: SizedBox(
            height: 5,
            child: ColoredBox(
              color: DashboardColors.of(context).track,
              child: FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: ratio.clamp(0, 1),
                child: ColoredBox(color: color),
              ),
            ),
          ),
        ),
        DashboardCappedRow(
          start: Wrap(
            spacing: 10,
            runSpacing: 4,
            children: [
              _DirectionTotal(
                glyph: AppGlyphs.arrowUp,
                label: context.appLocalizations.upload,
                bytes: node.up,
              ),
              _DirectionTotal(
                glyph: AppGlyphs.arrowDown,
                label: context.appLocalizations.download,
                bytes: node.down,
              ),
            ],
          ),
          end: Text(
            '${(ratio * 100).toStringAsFixed(1)}%',
            style: DashboardText.label(context, color: color),
          ),
        ),
      ],
    );
  }
}

class _TrafficRing extends CustomPainter {
  const _TrafficRing({
    required this.values,
    required this.colors,
    required this.track,
  });
  final List<int> values;
  final List<Color> colors;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 9.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawOval(rect, paint..color = track);
    final total = values.fold(0, (sum, value) => sum + value);
    if (total == 0) return;
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = values[i] / total * 2 * math.pi;
      final gap = math.min(0.045, sweep * 0.2);
      canvas.drawArc(
        rect,
        start + gap / 2,
        sweep - gap,
        false,
        paint..color = colors[i],
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_TrafficRing oldDelegate) =>
      !listEquals(values, oldDelegate.values) ||
      !listEquals(colors, oldDelegate.colors) ||
      track != oldDelegate.track;
}

class _NodeTrafficSheet extends ConsumerStatefulWidget {
  const _NodeTrafficSheet({required this.initial});
  final List<NodeTraffic> initial;

  @override
  ConsumerState<_NodeTrafficSheet> createState() => _NodeTrafficSheetState();
}

class _NodeTrafficSheetState extends ConsumerState<_NodeTrafficSheet>
    with
        WidgetsBindingObserver,
        ActivePollingMixin<_NodeTrafficSheet>,
        RouteMotionHoldMixin<_NodeTrafficSheet>,
        _NodeTrafficPolling<_NodeTrafficSheet> {
  @override
  void initState() {
    super.initState();
    acceptNodes(widget.initial);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    title: context.appLocalizations.nodeTraffic,
    body: PrismListView(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
        top: context.contentTopPadding,
        bottom: 20 + context.bottomInset,
      ),
      itemCount: nodes.length + 1,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: index == 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  _TrafficOverview(
                    nodes: nodes,
                    upload: upload,
                    download: download,
                  ),
                  Text(
                    context.appLocalizations.nodeTrafficHint,
                    style: DashboardText.label(context),
                  ),
                  if (unavailable && nodes.isNotEmpty)
                    Text(
                      context.appLocalizations.nodeTrafficUnavailable,
                      style: DashboardText.label(context),
                    ),
                  if (nodes.isEmpty) status(context),
                ],
              )
            : _NodeTrafficRow(
                node: nodes[index - 1],
                index: index - 1,
                total: total,
              ),
      ),
    ),
  );
}
