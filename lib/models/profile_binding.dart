import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:fl_clash/enum/enum.dart';

part 'generated/profile_binding.freezed.dart';
part 'generated/profile_binding.g.dart';

enum SubscriptionAttachMode { nodes, group }

@freezed
abstract class GroupAttachment with _$GroupAttachment {
  const factory GroupAttachment({
    required String target,
    @Default(SubscriptionAttachMode.nodes) SubscriptionAttachMode mode,
  }) = _GroupAttachment;

  factory GroupAttachment.fromJson(Map<String, Object?> json) =>
      _$GroupAttachmentFromJson(json);
}

@freezed
abstract class SubscriptionBinding with _$SubscriptionBinding {
  const factory SubscriptionBinding({
    required String id,
    required int sourceId,
    required String name,
    @Default(true) bool enabled,
    @Default('') String filter,
    @Default(GroupType.Selector) GroupType groupType,
    @Default([]) List<GroupAttachment> attachments,
  }) = _SubscriptionBinding;

  factory SubscriptionBinding.fromJson(Map<String, Object?> json) =>
      _$SubscriptionBindingFromJson(json);
}

@freezed
abstract class RuleSetBinding with _$RuleSetBinding {
  const factory RuleSetBinding({
    required String id,
    required int sourceId,
    required String target,
    @Default(true) bool enabled,
  }) = _RuleSetBinding;

  factory RuleSetBinding.fromJson(Map<String, Object?> json) =>
      _$RuleSetBindingFromJson(json);
}
