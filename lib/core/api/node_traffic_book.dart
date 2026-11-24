import 'dart:math' as math;

import 'package:fl_clash/models/node_traffic.dart';

import 'core_api.dart';
import 'dto.dart';

const _builtinOutbounds = {
  'DIRECT',
  'REJECT',
  'REJECT-DROP',
  'PASS',
  'COMPATIBLE',
};

class _TrackedNodeConnection {
  String name;
  String provider;
  int up;
  int down;

  _TrackedNodeConnection({
    required this.name,
    required this.provider,
    required this.up,
    required this.down,
  });
}

/// Aggregates per-node session traffic from `connection.watch` using
/// per-connection high-water marks so overlapping snapshots or counters never
/// double-count.
class NodeTrafficBook {
  final _tracked = <int, _TrackedNodeConnection>{};
  final _totals = <(String, String), ({int up, int down})>{};
  int _revision = 0;

  int get revision => _revision;

  ({String name, String provider})? _extractNode(ConnectionInfo info) {
    final name = info.chains.firstOrNull ?? '';
    if (name.isEmpty || _builtinOutbounds.contains(name.toUpperCase())) {
      return null;
    }
    return (name: name, provider: info.providerChains.firstOrNull ?? '');
  }

  void _book(String name, String provider, int upDelta, int downDelta) {
    if (upDelta <= 0 && downDelta <= 0) {
      return;
    }
    final key = (name, provider);
    final current = _totals[key] ?? (up: 0, down: 0);
    _totals[key] = (
      up: current.up + math.max(0, upDelta),
      down: current.down + math.max(0, downDelta),
    );
    _revision++;
  }

  void _upsert(ConnectionInfo info) {
    final node = _extractNode(info);
    if (node == null) {
      _tracked.remove(info.id);
      return;
    }
    final upload = math.max(0, info.upload);
    final download = math.max(0, info.download);
    final existing = _tracked[info.id];
    if (existing != null) {
      final upDelta = math.max(0, upload - existing.up);
      final downDelta = math.max(0, download - existing.down);
      existing
        ..name = node.name
        ..provider = node.provider
        ..up = math.max(existing.up, upload)
        ..down = math.max(existing.down, download);
      _book(node.name, node.provider, upDelta, downDelta);
      return;
    }
    _tracked[info.id] = _TrackedNodeConnection(
      name: node.name,
      provider: node.provider,
      up: upload,
      down: download,
    );
    _book(node.name, node.provider, upload, download);
  }

  void _applyCounter(int id, int upload, int download) {
    final existing = _tracked[id];
    if (existing == null) {
      return;
    }
    final safeUp = math.max(0, upload);
    final safeDown = math.max(0, download);
    final upDelta = math.max(0, safeUp - existing.up);
    final downDelta = math.max(0, safeDown - existing.down);
    existing
      ..up = math.max(existing.up, safeUp)
      ..down = math.max(existing.down, safeDown);
    _book(existing.name, existing.provider, upDelta, downDelta);
  }

  void applyConnections(ConnectionUpdate update) {
    switch (update) {
      case ConnectionsReset(:final snapshot):
        final liveIds = <int>{};
        for (final info in snapshot.connections) {
          liveIds.add(info.id);
          _upsert(info);
        }
        _tracked.removeWhere((id, _) => !liveIds.contains(id));
      case ConnectionsChanged(:final delta):
        for (final info in delta.opened) {
          _upsert(info);
        }
        for (final counter in delta.counters) {
          _applyCounter(counter.id, counter.upload, counter.download);
        }
        for (final id in delta.closed) {
          _tracked.remove(id);
        }
    }
  }

  void applyCounters(ConnectionUpdate update) {
    switch (update) {
      case ConnectionsReset(:final snapshot):
        for (final info in snapshot.connections) {
          _applyCounter(info.id, info.upload, info.download);
        }
      case ConnectionsChanged(:final delta):
        for (final counter in delta.counters) {
          _applyCounter(counter.id, counter.upload, counter.download);
        }
    }
  }

  void clear() {
    _tracked.clear();
    if (_totals.isNotEmpty) {
      _totals.clear();
      _revision++;
    }
  }

  void resetTotals() {
    if (_totals.isNotEmpty) {
      _totals.clear();
      _revision++;
    }
  }

  List<NodeTraffic> snapshot() {
    final result = [
      for (final MapEntry(key: (name, provider), value: (:up, :down))
          in _totals.entries)
        if (up + down > 0)
          NodeTraffic(name: name, provider: provider, up: up, down: down),
    ];
    result.sort((a, b) {
      final byTotal = b.total.compareTo(a.total);
      if (byTotal != 0) {
        return byTotal;
      }
      final byName = a.name.compareTo(b.name);
      if (byName != 0) {
        return byName;
      }
      return a.provider.compareTo(b.provider);
    });
    return result;
  }
}
