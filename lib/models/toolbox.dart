import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/toolbox.freezed.dart';
part 'generated/toolbox.g.dart';

@freezed
abstract class SpeedtestNetServer with _$SpeedtestNetServer {
  const factory SpeedtestNetServer({
    @Default('') String host,
    @Default('') String name,
    @Default('') String cc,
    @Default('') String sponsor,
    @Default(0.0) double latency,
  }) = _SpeedtestNetServer;

  factory SpeedtestNetServer.fromJson(Map<String, Object?> json) =>
      _$SpeedtestNetServerFromJson(json);
}

@freezed
abstract class SpeedTestParams with _$SpeedTestParams {
  const factory SpeedTestParams({
    @Default('apple') String provider,
    @Default('') String lang,
    @Default('') String proxy,
    @Default(10) int duration,
    @Default('h1') String protocol,
    @Default(8) int streams,
    @Default(false) @JsonKey(name: 'use-system-dns') bool useSystemDns,
    @JsonKey(includeIfNull: false) SpeedtestNetServer? server,
  }) = _SpeedTestParams;

  factory SpeedTestParams.fromJson(Map<String, Object?> json) =>
      _$SpeedTestParamsFromJson(json);
}

@freezed
abstract class SpeedTestServersParams with _$SpeedTestServersParams {
  const factory SpeedTestServersParams({
    @Default('') String proxy,
    @Default('') String search,
  }) = _SpeedTestServersParams;

  factory SpeedTestServersParams.fromJson(Map<String, Object?> json) =>
      _$SpeedTestServersParamsFromJson(json);
}

@freezed
abstract class SpeedTestOutbound with _$SpeedTestOutbound {
  const factory SpeedTestOutbound({
    @Default([]) List<String> chains,
    @Default('') String rule,
    @Default('') @JsonKey(name: 'rule-payload') String rulePayload,
  }) = _SpeedTestOutbound;

  factory SpeedTestOutbound.fromJson(Map<String, Object?> json) =>
      _$SpeedTestOutboundFromJson(json);
}

@freezed
abstract class SpeedTestServer with _$SpeedTestServer {
  const factory SpeedTestServer({
    @Default('') String ip,
    @Default('') String country,
    @Default('') String city,
    @Default('') String colo,
    @Default('') String host,
    @Default('') String sponsor,
  }) = _SpeedTestServer;

  factory SpeedTestServer.fromJson(Map<String, Object?> json) =>
      _$SpeedTestServerFromJson(json);
}

@freezed
abstract class SpeedTestState with _$SpeedTestState {
  const factory SpeedTestState({
    @Default('') String provider,
    @Default('') String protocol,
    @Default(false) bool fallback,
    @Default('') @JsonKey(name: 'exit-ip') String exitIp,
    @JsonKey(name: 'exit-info') Map<String, dynamic>? exitInfo,
    @Default(0) int streams,
    @Default(0) int duration,
    @Default('') String phase,
    @Default(0.0) double progress,
    @Default(0.0) double speed,
    @Default(false) bool direct,
    SpeedTestOutbound? outbound,
    SpeedTestServer? server,
    @Default(0.0) double latency,
    @Default(0.0) double jitter,
    @Default(0.0) double download,
    @Default(0.0) double upload,
    @Default(0.0) @JsonKey(name: 'download-latency') double downloadLatency,
    @Default(0.0) @JsonKey(name: 'upload-latency') double uploadLatency,
    @Default(0) int rpm,
    @Default(0) int bytes,
    @Default('') String error,
  }) = _SpeedTestState;

  factory SpeedTestState.fromJson(Map<String, Object?> json) =>
      _$SpeedTestStateFromJson(json);
}

@freezed
abstract class RouteTraceParams with _$RouteTraceParams {
  const factory RouteTraceParams({
    required String target,
    @Default('tcp') String network,
    @Default(443) int port,
  }) = _RouteTraceParams;

  factory RouteTraceParams.fromJson(Map<String, Object?> json) =>
      _$RouteTraceParamsFromJson(json);
}

@freezed
abstract class RouteTraceStep with _$RouteTraceStep {
  const factory RouteTraceStep({
    @Default(0) int index,
    @Default('') String type,
    @Default('') String payload,
    @Default('') String adapter,
    @Default(false) bool matched,
    @Default(false) bool resolve,
    @Default('') String skipped,
    @Default(0) int duration,
  }) = _RouteTraceStep;

  factory RouteTraceStep.fromJson(Map<String, Object?> json) =>
      _$RouteTraceStepFromJson(json);
}

@freezed
abstract class RouteTraceChain with _$RouteTraceChain {
  const factory RouteTraceChain({
    @Default('') String name,
    @Default('') String type,
  }) = _RouteTraceChain;

  factory RouteTraceChain.fromJson(Map<String, Object?> json) =>
      _$RouteTraceChainFromJson(json);
}

@freezed
abstract class RouteTraceResult with _$RouteTraceResult {
  const factory RouteTraceResult({
    @Default('') String target,
    @Default('') String host,
    @Default('') String network,
    @Default(0) int port,
    @Default('') String mode,
    @Default('') @JsonKey(name: 'dns-mode') String dnsMode,
    @Default([]) @JsonKey(name: 'hosts-ips') List<String> hostsIps,
    @Default([]) @JsonKey(name: 'resolved-ips') List<String> resolvedIps,
    @Default(0.0) @JsonKey(name: 'resolve-time') double resolveTime,
    @Default('') @JsonKey(name: 'resolve-error') String resolveError,
    @Default(0) @JsonKey(name: 'resolved-by') int resolvedBy,
    @Default('') @JsonKey(name: 'dst-ip') String dstIp,
    @Default(0) int total,
    @Default(0) int checked,
    @Default(false) bool truncated,
    @Default([]) List<RouteTraceStep> steps,
    RouteTraceStep? matched,
    @Default([]) List<RouteTraceChain> chains,
    @Default(false) @JsonKey(name: 'support-udp') bool supportUdp,
    @Default(0.0) @JsonKey(name: 'match-time') double matchTime,
    @Default('') String error,
    @Default(false) @JsonKey(name: 'fallback-direct') bool fallbackDirect,
  }) = _RouteTraceResult;

  factory RouteTraceResult.fromJson(Map<String, Object?> json) =>
      _$RouteTraceResultFromJson(json);
}

@freezed
abstract class DnsQueryParams with _$DnsQueryParams {
  const factory DnsQueryParams({
    required String domain,
    @Default('A') String type,
    @Default('follow') String mode,
    @Default('') String server,
  }) = _DnsQueryParams;

  factory DnsQueryParams.fromJson(Map<String, Object?> json) =>
      _$DnsQueryParamsFromJson(json);
}

@freezed
abstract class DnsQueryRecord with _$DnsQueryRecord {
  const factory DnsQueryRecord({
    @Default('') String name,
    @Default('') String type,
    @Default(0) int ttl,
    @Default('') String data,
  }) = _DnsQueryRecord;

  factory DnsQueryRecord.fromJson(Map<String, Object?> json) =>
      _$DnsQueryRecordFromJson(json);
}

@freezed
abstract class DnsQueryResult with _$DnsQueryResult {
  const factory DnsQueryResult({
    @Default('') String domain,
    @Default('') String type,
    @Default('') String mode,
    @Default('') String server,
    @Default('') String rcode,
    @Default([]) List<DnsQueryRecord> answers,
    @Default(0.0) double elapsed,
    @Default('') String route,
    @Default([]) List<String> hosts,
    @Default('') @JsonKey(name: 'fake-ip-range') String fakeIpRange,
    @Default('') @JsonKey(name: 'filter-mode') String filterMode,
    @Default('') String outbound,
    @Default('') @JsonKey(name: 'outbound-type') String outboundType,
    @Default('') String error,
  }) = _DnsQueryResult;

  factory DnsQueryResult.fromJson(Map<String, Object?> json) =>
      _$DnsQueryResultFromJson(json);
}

@freezed
abstract class MrsPrepareResult with _$MrsPrepareResult {
  const factory MrsPrepareResult({
    @Default('') String version,
    @Default(0) int geosite,
    @Default(0) int geoip,
    @Default(false) bool extracted,
    @Default(0.0) double elapsed,
    @Default('') String error,
  }) = _MrsPrepareResult;

  factory MrsPrepareResult.fromJson(Map<String, Object?> json) =>
      _$MrsPrepareResultFromJson(json);
}

@freezed
abstract class MrsLookupParams with _$MrsLookupParams {
  const factory MrsLookupParams({
    required String target,
    @Default(true) bool resolve,
  }) = _MrsLookupParams;

  factory MrsLookupParams.fromJson(Map<String, Object?> json) =>
      _$MrsLookupParamsFromJson(json);
}

@freezed
abstract class MrsMatch with _$MrsMatch {
  const factory MrsMatch({
    @Default('') String kind,
    @Default('') String name,
    @Default('') String file,
    @Default(0) int count,
    @Default('') String via,
    @Default(false) bool referenced,
  }) = _MrsMatch;

  factory MrsMatch.fromJson(Map<String, Object?> json) =>
      _$MrsMatchFromJson(json);
}

@freezed
abstract class MrsLookupResult with _$MrsLookupResult {
  const factory MrsLookupResult({
    @Default('') String target,
    @Default('') String host,
    @Default([]) List<String> ips,
    @Default([]) List<MrsMatch> matches,
    @Default(0.0) double elapsed,
    @Default('') String error,
  }) = _MrsLookupResult;

  factory MrsLookupResult.fromJson(Map<String, Object?> json) =>
      _$MrsLookupResultFromJson(json);
}

@freezed
abstract class StunTestParams with _$StunTestParams {
  const factory StunTestParams({
    @Default('') String server,
    @Default('') String proxy,
  }) = _StunTestParams;

  factory StunTestParams.fromJson(Map<String, Object?> json) =>
      _$StunTestParamsFromJson(json);
}

@freezed
abstract class StunTestState with _$StunTestState {
  const factory StunTestState({
    @Default('') String phase,
    @Default(0.0) double progress,
    @Default('') String server,
    @Default('') String address,
    @Default(false) bool direct,
    SpeedTestOutbound? outbound,
    @Default('') @JsonKey(name: 'nat-type') String natType,
    @Default('') String mapping,
    @Default('') String filtering,
    @Default(false) bool public,
    @Default(false) @JsonKey(name: 'rfc5780') bool rfc5780,
    @Default('') @JsonKey(name: 'external-ip') String externalIp,
    @Default(0) @JsonKey(name: 'external-port') int externalPort,
    @Default('') @JsonKey(name: 'local-ip') String localIp,
    @Default(0) @JsonKey(name: 'local-port') int localPort,
    @Default(0) @JsonKey(name: 'port-preserved') int portPreserved,
    @Default('') @JsonKey(name: 'other-address') String otherAddress,
    @Default('') String software,
    @Default(0.0) double latency,
    @Default(0.0) double jitter,
    @Default(0.0) @JsonKey(name: 'packet-loss') double packetLoss,
    @Default('') String error,
  }) = _StunTestState;

  factory StunTestState.fromJson(Map<String, Object?> json) =>
      _$StunTestStateFromJson(json);
}

@freezed
abstract class LocalPingParams with _$LocalPingParams {
  const factory LocalPingParams({
    required String target,
    @Default('icmp') String protocol,
    @Default(0) int port,
    @Default(10) int count,
    @Default(1000) int interval,
    @Default(0) int size,
  }) = _LocalPingParams;

  factory LocalPingParams.fromJson(Map<String, Object?> json) =>
      _$LocalPingParamsFromJson(json);
}

@freezed
abstract class LocalPingReply with _$LocalPingReply {
  const factory LocalPingReply({
    @Default(0) int seq,
    @Default('') String status,
    @Default(0.0) double rtt,
    @Default(0) int ttl,
    @Default(0) int bytes,
  }) = _LocalPingReply;

  factory LocalPingReply.fromJson(Map<String, Object?> json) =>
      _$LocalPingReplyFromJson(json);
}

@freezed
abstract class LocalPingState with _$LocalPingState {
  const factory LocalPingState({
    @Default(0) int session,
    @Default('') String phase,
    @Default('') String target,
    @Default('') String address,
    @Default('') String protocol,
    @Default(0) int port,
    @Default(0) int size,
    @Default(0) int count,
    @Default(0) int interval,
    @Default(0) int sent,
    @Default(0.0) double elapsed,
    LocalPingReply? reply,
    @Default([]) List<LocalPingReply> replies,
    @Default('') String error,
  }) = _LocalPingState;

  factory LocalPingState.fromJson(Map<String, Object?> json) =>
      _$LocalPingStateFromJson(json);
}

@freezed
abstract class AgeKeyPair with _$AgeKeyPair {
  const factory AgeKeyPair({
    @Default('') @JsonKey(name: 'public-key') String publicKey,
    @Default('') @JsonKey(name: 'secret-key') String secretKey,
  }) = _AgeKeyPair;

  factory AgeKeyPair.fromJson(Map<String, Object?> json) =>
      _$AgeKeyPairFromJson(json);
}

@freezed
abstract class AgeCryptParams with _$AgeCryptParams {
  const factory AgeCryptParams({
    required String mode,
    required String data,
    required List<String> keys,
  }) = _AgeCryptParams;

  factory AgeCryptParams.fromJson(Map<String, Object?> json) =>
      _$AgeCryptParamsFromJson(json);
}

@freezed
abstract class AgeCryptResult with _$AgeCryptResult {
  const factory AgeCryptResult({
    @Default('') String data,
    @Default('') String error,
  }) = _AgeCryptResult;

  factory AgeCryptResult.fromJson(Map<String, Object?> json) =>
      _$AgeCryptResultFromJson(json);
}
