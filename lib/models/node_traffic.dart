import 'package:flutter/foundation.dart';

@immutable
class NodeTraffic {
  const NodeTraffic({
    required this.name,
    this.provider = '',
    required this.up,
    required this.down,
  });

  final String name;
  final String provider;
  final int up;
  final int down;

  int get total => up + down;

  @override
  bool operator ==(Object other) =>
      other is NodeTraffic &&
      other.name == name &&
      other.provider == provider &&
      other.up == up &&
      other.down == down;

  @override
  int get hashCode => Object.hash(name, provider, up, down);
}
