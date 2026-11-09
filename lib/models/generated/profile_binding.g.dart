// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../profile_binding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroupAttachment _$GroupAttachmentFromJson(Map<String, dynamic> json) =>
    _GroupAttachment(
      target: json['target'] as String,
      mode:
          $enumDecodeNullable(_$SubscriptionAttachModeEnumMap, json['mode']) ??
          SubscriptionAttachMode.nodes,
    );

Map<String, dynamic> _$GroupAttachmentToJson(_GroupAttachment instance) =>
    <String, dynamic>{
      'target': instance.target,
      'mode': _$SubscriptionAttachModeEnumMap[instance.mode]!,
    };

const _$SubscriptionAttachModeEnumMap = {
  SubscriptionAttachMode.nodes: 'nodes',
  SubscriptionAttachMode.group: 'group',
};

_SubscriptionBinding _$SubscriptionBindingFromJson(Map<String, dynamic> json) =>
    _SubscriptionBinding(
      id: json['id'] as String,
      sourceId: (json['sourceId'] as num).toInt(),
      name: json['name'] as String,
      enabled: json['enabled'] as bool? ?? true,
      filter: json['filter'] as String? ?? '',
      groupType:
          $enumDecodeNullable(_$GroupTypeEnumMap, json['groupType']) ??
          GroupType.Selector,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => GroupAttachment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SubscriptionBindingToJson(
  _SubscriptionBinding instance,
) => <String, dynamic>{
  'id': instance.id,
  'sourceId': instance.sourceId,
  'name': instance.name,
  'enabled': instance.enabled,
  'filter': instance.filter,
  'groupType': _$GroupTypeEnumMap[instance.groupType]!,
  'attachments': instance.attachments,
};

const _$GroupTypeEnumMap = {
  GroupType.Selector: 'select',
  GroupType.URLTest: 'url-test',
  GroupType.Fallback: 'fallback',
  GroupType.LoadBalance: 'load-balance',
  GroupType.Smart: 'smart',
  GroupType.Relay: 'relay',
};

_RuleSetBinding _$RuleSetBindingFromJson(Map<String, dynamic> json) =>
    _RuleSetBinding(
      id: json['id'] as String,
      sourceId: (json['sourceId'] as num).toInt(),
      target: json['target'] as String,
      enabled: json['enabled'] as bool? ?? true,
    );

Map<String, dynamic> _$RuleSetBindingToJson(_RuleSetBinding instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceId': instance.sourceId,
      'target': instance.target,
      'enabled': instance.enabled,
    };
