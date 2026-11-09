class NodeTraffic {
  const NodeTraffic({
    required this.name,
    this.provider = '',
    required this.up,
    required this.down,
  });

  factory NodeTraffic.fromJson(Map<String, Object?> json) => NodeTraffic(
    name: json['name'] as String,
    provider: json['provider'] as String? ?? '',
    up: (json['up'] as num).toInt(),
    down: (json['down'] as num).toInt(),
  );

  final String name;
  final String provider;
  final int up;
  final int down;

  int get total => up + down;
}
