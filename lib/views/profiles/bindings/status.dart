import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/providers/providers.dart';
import 'package:fl_clash/ui/icons/icons.dart';
import 'package:fl_clash/widgets/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileBindingApplyStatus extends ConsumerWidget {
  const ProfileBindingApplyStatus({super.key, required this.profileId});

  final int profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = context.appLocalizations;
    final status = ref.watch(
      bindingsAppliedProvider(
        profileId,
      ).select((state) => (state.value, state.hasError)),
    );
    final applied = status.$1 == true && !status.$2;
    final color = applied
        ? context.colorScheme.success
        : context.colorScheme.onSurfaceVariant;
    final text = status.$2
        ? labels.bindingStatusUnavailable
        : status.$1 == null
        ? labels.loading
        : applied
        ? labels.applied
        : labels.bindingPendingApply;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        GlyphIcon(
          applied ? AppGlyphs.checkCircle : AppGlyphs.clock,
          size: 16,
          color: color,
        ),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.caption1.of(context).copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
