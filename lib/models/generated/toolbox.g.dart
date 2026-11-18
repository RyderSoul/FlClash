// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../toolbox.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SpeedtestNetServer _$SpeedtestNetServerFromJson(Map<String, dynamic> json) =>
    _SpeedtestNetServer(
      host: json['host'] as String? ?? '',
      name: json['name'] as String? ?? '',
      cc: json['cc'] as String? ?? '',
      sponsor: json['sponsor'] as String? ?? '',
      latency: (json['latency'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$SpeedtestNetServerToJson(_SpeedtestNetServer instance) =>
    <String, dynamic>{
      'host': instance.host,
      'name': instance.name,
      'cc': instance.cc,
      'sponsor': instance.sponsor,
      'latency': instance.latency,
    };

_SpeedTestParams _$SpeedTestParamsFromJson(Map<String, dynamic> json) =>
    _SpeedTestParams(
      provider: json['provider'] as String? ?? 'apple',
      lang: json['lang'] as String? ?? '',
      proxy: json['proxy'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 10,
      protocol: json['protocol'] as String? ?? 'h1',
      streams: (json['streams'] as num?)?.toInt() ?? 8,
      useSystemDns: json['use-system-dns'] as bool? ?? false,
      server: json['server'] == null
          ? null
          : SpeedtestNetServer.fromJson(json['server'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SpeedTestParamsToJson(_SpeedTestParams instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'lang': instance.lang,
      'proxy': instance.proxy,
      'duration': instance.duration,
      'protocol': instance.protocol,
      'streams': instance.streams,
      'use-system-dns': instance.useSystemDns,
      'server': ?instance.server,
    };

_SpeedTestServersParams _$SpeedTestServersParamsFromJson(
  Map<String, dynamic> json,
) => _SpeedTestServersParams(
  proxy: json['proxy'] as String? ?? '',
  search: json['search'] as String? ?? '',
);

Map<String, dynamic> _$SpeedTestServersParamsToJson(
  _SpeedTestServersParams instance,
) => <String, dynamic>{'proxy': instance.proxy, 'search': instance.search};

_SpeedTestOutbound _$SpeedTestOutboundFromJson(Map<String, dynamic> json) =>
    _SpeedTestOutbound(
      chains:
          (json['chains'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      rule: json['rule'] as String? ?? '',
      rulePayload: json['rule-payload'] as String? ?? '',
    );

Map<String, dynamic> _$SpeedTestOutboundToJson(_SpeedTestOutbound instance) =>
    <String, dynamic>{
      'chains': instance.chains,
      'rule': instance.rule,
      'rule-payload': instance.rulePayload,
    };

_SpeedTestServer _$SpeedTestServerFromJson(Map<String, dynamic> json) =>
    _SpeedTestServer(
      ip: json['ip'] as String? ?? '',
      country: json['country'] as String? ?? '',
      city: json['city'] as String? ?? '',
      colo: json['colo'] as String? ?? '',
      host: json['host'] as String? ?? '',
      sponsor: json['sponsor'] as String? ?? '',
    );

Map<String, dynamic> _$SpeedTestServerToJson(_SpeedTestServer instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'country': instance.country,
      'city': instance.city,
      'colo': instance.colo,
      'host': instance.host,
      'sponsor': instance.sponsor,
    };

_SpeedTestState _$SpeedTestStateFromJson(Map<String, dynamic> json) =>
    _SpeedTestState(
      provider: json['provider'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      fallback: json['fallback'] as bool? ?? false,
      exitIp: json['exit-ip'] as String? ?? '',
      exitInfo: json['exit-info'] as Map<String, dynamic>?,
      streams: (json['streams'] as num?)?.toInt() ?? 0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      phase: json['phase'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      speed: (json['speed'] as num?)?.toDouble() ?? 0.0,
      direct: json['direct'] as bool? ?? false,
      outbound: json['outbound'] == null
          ? null
          : SpeedTestOutbound.fromJson(
              json['outbound'] as Map<String, dynamic>,
            ),
      server: json['server'] == null
          ? null
          : SpeedTestServer.fromJson(json['server'] as Map<String, dynamic>),
      latency: (json['latency'] as num?)?.toDouble() ?? 0.0,
      jitter: (json['jitter'] as num?)?.toDouble() ?? 0.0,
      download: (json['download'] as num?)?.toDouble() ?? 0.0,
      upload: (json['upload'] as num?)?.toDouble() ?? 0.0,
      downloadLatency: (json['download-latency'] as num?)?.toDouble() ?? 0.0,
      uploadLatency: (json['upload-latency'] as num?)?.toDouble() ?? 0.0,
      rpm: (json['rpm'] as num?)?.toInt() ?? 0,
      bytes: (json['bytes'] as num?)?.toInt() ?? 0,
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$SpeedTestStateToJson(_SpeedTestState instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'protocol': instance.protocol,
      'fallback': instance.fallback,
      'exit-ip': instance.exitIp,
      'exit-info': instance.exitInfo,
      'streams': instance.streams,
      'duration': instance.duration,
      'phase': instance.phase,
      'progress': instance.progress,
      'speed': instance.speed,
      'direct': instance.direct,
      'outbound': instance.outbound,
      'server': instance.server,
      'latency': instance.latency,
      'jitter': instance.jitter,
      'download': instance.download,
      'upload': instance.upload,
      'download-latency': instance.downloadLatency,
      'upload-latency': instance.uploadLatency,
      'rpm': instance.rpm,
      'bytes': instance.bytes,
      'error': instance.error,
    };

_RouteTraceParams _$RouteTraceParamsFromJson(Map<String, dynamic> json) =>
    _RouteTraceParams(
      target: json['target'] as String,
      network: json['network'] as String? ?? 'tcp',
      port: (json['port'] as num?)?.toInt() ?? 443,
    );

Map<String, dynamic> _$RouteTraceParamsToJson(_RouteTraceParams instance) =>
    <String, dynamic>{
      'target': instance.target,
      'network': instance.network,
      'port': instance.port,
    };

_RouteTraceStep _$RouteTraceStepFromJson(Map<String, dynamic> json) =>
    _RouteTraceStep(
      index: (json['index'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      payload: json['payload'] as String? ?? '',
      adapter: json['adapter'] as String? ?? '',
      matched: json['matched'] as bool? ?? false,
      resolve: json['resolve'] as bool? ?? false,
      skipped: json['skipped'] as String? ?? '',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RouteTraceStepToJson(_RouteTraceStep instance) =>
    <String, dynamic>{
      'index': instance.index,
      'type': instance.type,
      'payload': instance.payload,
      'adapter': instance.adapter,
      'matched': instance.matched,
      'resolve': instance.resolve,
      'skipped': instance.skipped,
      'duration': instance.duration,
    };

_RouteTraceChain _$RouteTraceChainFromJson(Map<String, dynamic> json) =>
    _RouteTraceChain(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );

Map<String, dynamic> _$RouteTraceChainToJson(_RouteTraceChain instance) =>
    <String, dynamic>{'name': instance.name, 'type': instance.type};

_RouteTraceResult _$RouteTraceResultFromJson(Map<String, dynamic> json) =>
    _RouteTraceResult(
      target: json['target'] as String? ?? '',
      host: json['host'] as String? ?? '',
      network: json['network'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      mode: json['mode'] as String? ?? '',
      dnsMode: json['dns-mode'] as String? ?? '',
      hostsIps:
          (json['hosts-ips'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      resolvedIps:
          (json['resolved-ips'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      resolveTime: (json['resolve-time'] as num?)?.toDouble() ?? 0.0,
      resolveError: json['resolve-error'] as String? ?? '',
      resolvedBy: (json['resolved-by'] as num?)?.toInt() ?? 0,
      dstIp: json['dst-ip'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      checked: (json['checked'] as num?)?.toInt() ?? 0,
      truncated: json['truncated'] as bool? ?? false,
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => RouteTraceStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      matched: json['matched'] == null
          ? null
          : RouteTraceStep.fromJson(json['matched'] as Map<String, dynamic>),
      chains:
          (json['chains'] as List<dynamic>?)
              ?.map((e) => RouteTraceChain.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      supportUdp: json['support-udp'] as bool? ?? false,
      matchTime: (json['match-time'] as num?)?.toDouble() ?? 0.0,
      error: json['error'] as String? ?? '',
      fallbackDirect: json['fallback-direct'] as bool? ?? false,
    );

Map<String, dynamic> _$RouteTraceResultToJson(_RouteTraceResult instance) =>
    <String, dynamic>{
      'target': instance.target,
      'host': instance.host,
      'network': instance.network,
      'port': instance.port,
      'mode': instance.mode,
      'dns-mode': instance.dnsMode,
      'hosts-ips': instance.hostsIps,
      'resolved-ips': instance.resolvedIps,
      'resolve-time': instance.resolveTime,
      'resolve-error': instance.resolveError,
      'resolved-by': instance.resolvedBy,
      'dst-ip': instance.dstIp,
      'total': instance.total,
      'checked': instance.checked,
      'truncated': instance.truncated,
      'steps': instance.steps,
      'matched': instance.matched,
      'chains': instance.chains,
      'support-udp': instance.supportUdp,
      'match-time': instance.matchTime,
      'error': instance.error,
      'fallback-direct': instance.fallbackDirect,
    };

_DnsQueryParams _$DnsQueryParamsFromJson(Map<String, dynamic> json) =>
    _DnsQueryParams(
      domain: json['domain'] as String,
      type: json['type'] as String? ?? 'A',
      mode: json['mode'] as String? ?? 'follow',
      server: json['server'] as String? ?? '',
    );

Map<String, dynamic> _$DnsQueryParamsToJson(_DnsQueryParams instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'type': instance.type,
      'mode': instance.mode,
      'server': instance.server,
    };

_DnsQueryRecord _$DnsQueryRecordFromJson(Map<String, dynamic> json) =>
    _DnsQueryRecord(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      ttl: (json['ttl'] as num?)?.toInt() ?? 0,
      data: json['data'] as String? ?? '',
    );

Map<String, dynamic> _$DnsQueryRecordToJson(_DnsQueryRecord instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'ttl': instance.ttl,
      'data': instance.data,
    };

_DnsQueryResult _$DnsQueryResultFromJson(Map<String, dynamic> json) =>
    _DnsQueryResult(
      domain: json['domain'] as String? ?? '',
      type: json['type'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      server: json['server'] as String? ?? '',
      rcode: json['rcode'] as String? ?? '',
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map((e) => DnsQueryRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      elapsed: (json['elapsed'] as num?)?.toDouble() ?? 0.0,
      route: json['route'] as String? ?? '',
      hosts:
          (json['hosts'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      fakeIpRange: json['fake-ip-range'] as String? ?? '',
      filterMode: json['filter-mode'] as String? ?? '',
      outbound: json['outbound'] as String? ?? '',
      outboundType: json['outbound-type'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$DnsQueryResultToJson(_DnsQueryResult instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'type': instance.type,
      'mode': instance.mode,
      'server': instance.server,
      'rcode': instance.rcode,
      'answers': instance.answers,
      'elapsed': instance.elapsed,
      'route': instance.route,
      'hosts': instance.hosts,
      'fake-ip-range': instance.fakeIpRange,
      'filter-mode': instance.filterMode,
      'outbound': instance.outbound,
      'outbound-type': instance.outboundType,
      'error': instance.error,
    };

_MrsPrepareResult _$MrsPrepareResultFromJson(Map<String, dynamic> json) =>
    _MrsPrepareResult(
      version: json['version'] as String? ?? '',
      geosite: (json['geosite'] as num?)?.toInt() ?? 0,
      geoip: (json['geoip'] as num?)?.toInt() ?? 0,
      extracted: json['extracted'] as bool? ?? false,
      elapsed: (json['elapsed'] as num?)?.toDouble() ?? 0.0,
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$MrsPrepareResultToJson(_MrsPrepareResult instance) =>
    <String, dynamic>{
      'version': instance.version,
      'geosite': instance.geosite,
      'geoip': instance.geoip,
      'extracted': instance.extracted,
      'elapsed': instance.elapsed,
      'error': instance.error,
    };

_MrsLookupParams _$MrsLookupParamsFromJson(Map<String, dynamic> json) =>
    _MrsLookupParams(
      target: json['target'] as String,
      resolve: json['resolve'] as bool? ?? true,
    );

Map<String, dynamic> _$MrsLookupParamsToJson(_MrsLookupParams instance) =>
    <String, dynamic>{'target': instance.target, 'resolve': instance.resolve};

_MrsMatch _$MrsMatchFromJson(Map<String, dynamic> json) => _MrsMatch(
  kind: json['kind'] as String? ?? '',
  name: json['name'] as String? ?? '',
  file: json['file'] as String? ?? '',
  count: (json['count'] as num?)?.toInt() ?? 0,
  via: json['via'] as String? ?? '',
  referenced: json['referenced'] as bool? ?? false,
);

Map<String, dynamic> _$MrsMatchToJson(_MrsMatch instance) => <String, dynamic>{
  'kind': instance.kind,
  'name': instance.name,
  'file': instance.file,
  'count': instance.count,
  'via': instance.via,
  'referenced': instance.referenced,
};

_MrsLookupResult _$MrsLookupResultFromJson(Map<String, dynamic> json) =>
    _MrsLookupResult(
      target: json['target'] as String? ?? '',
      host: json['host'] as String? ?? '',
      ips:
          (json['ips'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      matches:
          (json['matches'] as List<dynamic>?)
              ?.map((e) => MrsMatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      elapsed: (json['elapsed'] as num?)?.toDouble() ?? 0.0,
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$MrsLookupResultToJson(_MrsLookupResult instance) =>
    <String, dynamic>{
      'target': instance.target,
      'host': instance.host,
      'ips': instance.ips,
      'matches': instance.matches,
      'elapsed': instance.elapsed,
      'error': instance.error,
    };

_StunTestParams _$StunTestParamsFromJson(Map<String, dynamic> json) =>
    _StunTestParams(
      server: json['server'] as String? ?? '',
      proxy: json['proxy'] as String? ?? '',
    );

Map<String, dynamic> _$StunTestParamsToJson(_StunTestParams instance) =>
    <String, dynamic>{'server': instance.server, 'proxy': instance.proxy};

_StunTestState _$StunTestStateFromJson(Map<String, dynamic> json) =>
    _StunTestState(
      phase: json['phase'] as String? ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      server: json['server'] as String? ?? '',
      address: json['address'] as String? ?? '',
      direct: json['direct'] as bool? ?? false,
      outbound: json['outbound'] == null
          ? null
          : SpeedTestOutbound.fromJson(
              json['outbound'] as Map<String, dynamic>,
            ),
      natType: json['nat-type'] as String? ?? '',
      mapping: json['mapping'] as String? ?? '',
      filtering: json['filtering'] as String? ?? '',
      public: json['public'] as bool? ?? false,
      rfc5780: json['rfc5780'] as bool? ?? false,
      externalIp: json['external-ip'] as String? ?? '',
      externalPort: (json['external-port'] as num?)?.toInt() ?? 0,
      localIp: json['local-ip'] as String? ?? '',
      localPort: (json['local-port'] as num?)?.toInt() ?? 0,
      portPreserved: (json['port-preserved'] as num?)?.toInt() ?? 0,
      otherAddress: json['other-address'] as String? ?? '',
      software: json['software'] as String? ?? '',
      latency: (json['latency'] as num?)?.toDouble() ?? 0.0,
      jitter: (json['jitter'] as num?)?.toDouble() ?? 0.0,
      packetLoss: (json['packet-loss'] as num?)?.toDouble() ?? 0.0,
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$StunTestStateToJson(_StunTestState instance) =>
    <String, dynamic>{
      'phase': instance.phase,
      'progress': instance.progress,
      'server': instance.server,
      'address': instance.address,
      'direct': instance.direct,
      'outbound': instance.outbound,
      'nat-type': instance.natType,
      'mapping': instance.mapping,
      'filtering': instance.filtering,
      'public': instance.public,
      'rfc5780': instance.rfc5780,
      'external-ip': instance.externalIp,
      'external-port': instance.externalPort,
      'local-ip': instance.localIp,
      'local-port': instance.localPort,
      'port-preserved': instance.portPreserved,
      'other-address': instance.otherAddress,
      'software': instance.software,
      'latency': instance.latency,
      'jitter': instance.jitter,
      'packet-loss': instance.packetLoss,
      'error': instance.error,
    };

_LocalPingParams _$LocalPingParamsFromJson(Map<String, dynamic> json) =>
    _LocalPingParams(
      target: json['target'] as String,
      protocol: json['protocol'] as String? ?? 'icmp',
      port: (json['port'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 10,
      interval: (json['interval'] as num?)?.toInt() ?? 1000,
      size: (json['size'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LocalPingParamsToJson(_LocalPingParams instance) =>
    <String, dynamic>{
      'target': instance.target,
      'protocol': instance.protocol,
      'port': instance.port,
      'count': instance.count,
      'interval': instance.interval,
      'size': instance.size,
    };

_LocalPingReply _$LocalPingReplyFromJson(Map<String, dynamic> json) =>
    _LocalPingReply(
      seq: (json['seq'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      rtt: (json['rtt'] as num?)?.toDouble() ?? 0.0,
      ttl: (json['ttl'] as num?)?.toInt() ?? 0,
      bytes: (json['bytes'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LocalPingReplyToJson(_LocalPingReply instance) =>
    <String, dynamic>{
      'seq': instance.seq,
      'status': instance.status,
      'rtt': instance.rtt,
      'ttl': instance.ttl,
      'bytes': instance.bytes,
    };

_LocalPingState _$LocalPingStateFromJson(Map<String, dynamic> json) =>
    _LocalPingState(
      session: (json['session'] as num?)?.toInt() ?? 0,
      phase: json['phase'] as String? ?? '',
      target: json['target'] as String? ?? '',
      address: json['address'] as String? ?? '',
      protocol: json['protocol'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      size: (json['size'] as num?)?.toInt() ?? 0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      interval: (json['interval'] as num?)?.toInt() ?? 0,
      sent: (json['sent'] as num?)?.toInt() ?? 0,
      elapsed: (json['elapsed'] as num?)?.toDouble() ?? 0.0,
      reply: json['reply'] == null
          ? null
          : LocalPingReply.fromJson(json['reply'] as Map<String, dynamic>),
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => LocalPingReply.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$LocalPingStateToJson(_LocalPingState instance) =>
    <String, dynamic>{
      'session': instance.session,
      'phase': instance.phase,
      'target': instance.target,
      'address': instance.address,
      'protocol': instance.protocol,
      'port': instance.port,
      'size': instance.size,
      'count': instance.count,
      'interval': instance.interval,
      'sent': instance.sent,
      'elapsed': instance.elapsed,
      'reply': instance.reply,
      'replies': instance.replies,
      'error': instance.error,
    };

_AgeKeyPair _$AgeKeyPairFromJson(Map<String, dynamic> json) => _AgeKeyPair(
  publicKey: json['public-key'] as String? ?? '',
  secretKey: json['secret-key'] as String? ?? '',
);

Map<String, dynamic> _$AgeKeyPairToJson(_AgeKeyPair instance) =>
    <String, dynamic>{
      'public-key': instance.publicKey,
      'secret-key': instance.secretKey,
    };

_AgeCryptParams _$AgeCryptParamsFromJson(Map<String, dynamic> json) =>
    _AgeCryptParams(
      mode: json['mode'] as String,
      data: json['data'] as String,
      keys: (json['keys'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$AgeCryptParamsToJson(_AgeCryptParams instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'data': instance.data,
      'keys': instance.keys,
    };

_AgeCryptResult _$AgeCryptResultFromJson(Map<String, dynamic> json) =>
    _AgeCryptResult(
      data: json['data'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$AgeCryptResultToJson(_AgeCryptResult instance) =>
    <String, dynamic>{'data': instance.data, 'error': instance.error};
