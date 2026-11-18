import 'dart:async';

import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/views/toolbox/toolbox.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'card.dart';

class ToolboxCard extends ConsumerWidget {
  const ToolboxCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.appLocalizations;
    return DashboardCard(
      semanticLabel: l10n.toolbox,
      onTap: () => unawaited(BaseNavigator.push(context, const ToolboxView())),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          DashboardCardHeader(
            glyph: AppGlyphs.tools,
            title: l10n.toolbox,
            chevron: true,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              TonalButton(
                size: TonalButtonSize.compact,
                onPressed: () => unawaited(
                  BaseNavigator.push(context, const SpeedTestView()),
                ),
                label: l10n.speedTest,
              ),
              TonalButton(
                size: TonalButtonSize.compact,
                onPressed: () => unawaited(
                  BaseNavigator.push(context, const RouteTraceView()),
                ),
                label: l10n.routeTrace,
              ),
              TonalButton(
                size: TonalButtonSize.compact,
                onPressed: () => unawaited(
                  BaseNavigator.push(context, const DnsLookupView()),
                ),
                label: l10n.dnsQuery,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
