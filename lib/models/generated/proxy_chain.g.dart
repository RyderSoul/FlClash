// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../proxy_chain.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProxyChain _$ProxyChainFromJson(Map<String, dynamic> json) => _ProxyChain(
  id: json['id'] as String,
  name: json['name'] as String,
  hops:
      (json['hops'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  enabled: json['enabled'] as bool? ?? true,
  hidden: json['hidden'] as bool? ?? false,
  targetGroup: json['targetGroup'] as String?,
);

Map<String, dynamic> _$ProxyChainToJson(_ProxyChain instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'hops': instance.hops,
      'enabled': instance.enabled,
      'hidden': instance.hidden,
      'targetGroup': instance.targetGroup,
    };
