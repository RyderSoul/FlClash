import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/features/form/form.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> copyToolText(BuildContext context, String text) async {
  if (text.isEmpty) return;
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    dialogs.showBanner(
      context.appLocalizations.copySuccess,
      level: BannerLevel.success,
    );
  }
}

String toolboxErrorText(BuildContext context, String code) {
  final l10n = context.appLocalizations;
  return switch (code) {
    'stopped' => l10n.coreNotRunning,
    'timeout' => l10n.timeout,
    'missing' => l10n.mrsMissing,
    'cancelled' => l10n.cancel,
    _ => code.isEmpty ? l10n.error : '${l10n.error}: $code',
  };
}

String toolboxFormatSpeed(double bitsPerSec) {
  if (bitsPerSec <= 0) return '0 Mbps';
  if (bitsPerSec >= 1e9) {
    return '${(bitsPerSec / 1e9).toStringAsFixed(2)} Gbps';
  }
  if (bitsPerSec >= 1e6) {
    return '${(bitsPerSec / 1e6).toStringAsFixed(2)} Mbps';
  }
  return '${(bitsPerSec / 1e3).toStringAsFixed(1)} Kbps';
}

String toolboxFormatMillis(double value) {
  if (value <= 0) return '0 ms';
  final digits = value < 1
      ? 2
      : value < 100
      ? 1
      : 0;
  return '${value.toStringAsFixed(digits)} ms';
}

List<String> collectToolboxProxies(WidgetRef ref) {
  final groups = ref.read(groupsProvider);
  final seen = <String>{'', 'DIRECT'};
  final result = <String>['', 'DIRECT'];
  for (final group in groups) {
    if (seen.add(group.name)) {
      result.add(group.name);
    }
    for (final proxy in group.all) {
      if (seen.add(proxy.name)) {
        result.add(proxy.name);
      }
    }
  }
  return result;
}

Future<String?> pickToolboxProxy(
  BuildContext context,
  WidgetRef ref,
  String current,
) {
  final l10n = context.appLocalizations;
  final items = collectToolboxProxies(ref);
  return showSheet<String>(
    context: context,
    builder: (sheetContext) => SelectionSheet<String>(
      title: l10n.proxy,
      sections: [SelectionSection(items: items)],
      labelBuilder: (item) => item.isEmpty ? l10n.speedTestFollowRules : item,
      selectedOf: (_) => current,
      onSelected: (item) => Navigator.of(sheetContext).pop(item),
    ),
  );
}

class ToolboxScrollBody extends StatelessWidget {
  const ToolboxScrollBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ShowBarScrollBehavior(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: context.sectionsTopPadding,
          bottom: 20 + context.bottomInset,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: children,
        ),
      ),
    );
  }
}

class ToolboxErrorCard extends StatelessWidget {
  const ToolboxErrorCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colorScheme.errorContainer,
        shape: AppShape.all(AppCorner.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          spacing: 10,
          children: [
            GlyphIcon(
              AppGlyphs.error,
              size: 18,
              color: colorScheme.onErrorContainer,
            ),
            Expanded(
              child: Text(
                message,
                style: AppTextStyle.subheadline
                    .of(context)
                    .copyWith(color: colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToolboxMetricItem {
  const ToolboxMetricItem({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;
}

class ToolboxMetricGrid extends StatelessWidget {
  const ToolboxMetricGrid({super.key, required this.items});

  final List<ToolboxMetricItem> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Card(
      radius: AppCorner.lg,
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 420 ? 3 : 2;
          const spacing = 12.0;
          final tileWidth =
              (constraints.maxWidth - spacing * (columns - 1)) / columns;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: [
              for (final item in items)
                SizedBox(
                  width: tileWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.caption1
                            .of(context)
                            .copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        item.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.title3
                            .of(context)
                            .copyWith(
                              color: item.color ?? colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
