import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/proxy_chain.freezed.dart';
part 'generated/proxy_chain.g.dart';

@freezed
abstract class ProxyChain with _$ProxyChain {
  const factory ProxyChain({
    required String id,
    required String name,
    @Default([]) List<String> hops,
    @Default(true) bool enabled,
    @Default(false) bool hidden,
    String? targetGroup,
    @Default([]) List<String> targetGroups,
  }) = _ProxyChain;

  factory ProxyChain.fromJson(Map<String, Object?> json) =>
      _$ProxyChainFromJson(json);
}

extension ProxyChainTargets on ProxyChain {
  Set<String> get targets => {
    if (targetGroup?.isNotEmpty == true) targetGroup!,
    ...targetGroups,
  };
}
