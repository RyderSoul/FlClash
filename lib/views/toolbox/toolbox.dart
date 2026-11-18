import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';

import 'age_tool.dart';
import 'dns_lookup.dart';
import 'local_ping.dart';
import 'mrs_lookup.dart';
import 'nat_test.dart';
import 'route_trace.dart';
import 'speed_test.dart';

export 'age_tool.dart';
export 'dns_lookup.dart';
export 'local_ping.dart';
export 'mrs_lookup.dart';
export 'nat_test.dart';
export 'route_trace.dart';
export 'speed_test.dart';

class ToolboxView extends StatelessWidget {
  const ToolboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.appLocalizations;
    return Scaffold(
      title: l10n.toolbox,
      body: Builder(
        builder: (context) => PrismListView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: context.sectionsTopPadding,
            bottom: 20 + context.bottomInset,
          ),
          itemCount: 1,
          itemBuilder: (_, _) => generateSection(
            items: [
              ListItem.open(
                leading: const GlyphIcon(AppGlyphs.speed),
                title: Text(l10n.speedTest),
                subtitle: Text(l10n.speedTestDesc),
                widget: const SpeedTestView(),
              ),
              ListItem.open(
                leading: const GlyphIcon(AppGlyphs.split),
                title: Text(l10n.routeTrace),
                subtitle: Text(l10n.routeTraceDesc),
                widget: const RouteTraceView(),
              ),
              ListItem.open(
                leading: const GlyphIcon(AppGlyphs.dns),
                title: Text(l10n.dnsQuery),
                subtitle: Text(l10n.dnsQueryDesc),
                widget: const DnsLookupView(),
              ),
              ListItem.open(
                leading: const GlyphIcon(AppGlyphs.rulePresets),
                title: Text(l10n.mrsLookup),
                subtitle: Text(l10n.mrsLookupDesc),
                widget: const MrsLookupView(),
              ),
              ListItem.open(
                leading: const GlyphIcon(AppGlyphs.connections),
                title: Text(l10n.natTest),
                subtitle: Text(l10n.natTestDesc),
                widget: const NatTestView(),
              ),
              ListItem.open(
                leading: const GlyphIcon(AppGlyphs.target),
                title: Text(l10n.localPing),
                subtitle: Text(l10n.localPingDesc),
                widget: const LocalPingView(),
              ),
              ListItem.open(
                leading: const GlyphIcon(AppGlyphs.key),
                title: Text(l10n.ageTool),
                subtitle: Text(l10n.ageToolDesc),
                widget: const AgeToolView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
