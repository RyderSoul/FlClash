import 'package:fl_clash/core/core.dart';
import 'package:fl_clash/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

ConnectionInfo _conn(
  int id, {
  List<String> chains = const ['HK-1', 'Auto', 'Proxy'],
  List<String> providerChains = const [],
  int upload = 0,
  int download = 0,
}) => ConnectionInfo(
  id: id,
  start: 1000,
  network: 'tcp',
  sourceIp: '127.0.0.1',
  sourcePort: 10000 + id,
  destinationPort: 443,
  inboundType: 'tun',
  chains: chains,
  providerChains: providerChains,
  rule: 'MATCH',
  upload: upload,
  download: download,
);

void main() {
  group('NodeTrafficBook', () {
    test('tracks exit-first chains and excludes builtin outbounds', () {
      final book = NodeTrafficBook();

      book.applyConnections(
        ConnectionsChanged(
          ConnectionDelta(
            opened: [
              _conn(
                1,
                chains: const ['HK-1', 'Auto', 'Proxy'],
                upload: 10,
                download: 20,
              ),
              _conn(2, chains: const ['DIRECT'], upload: 500, download: 500),
              _conn(3, chains: const ['reject'], upload: 100, download: 100),
              _conn(
                4,
                chains: const ['REJECT-DROP'],
                upload: 100,
                download: 100,
              ),
              _conn(5, chains: const ['PASS'], upload: 100, download: 100),
              _conn(
                6,
                chains: const ['COMPATIBLE'],
                upload: 100,
                download: 100,
              ),
              _conn(7, chains: const [], upload: 100, download: 100),
            ],
            counters: const [
              ConnectionCounter(id: 1, upload: 40, download: 80),
              ConnectionCounter(id: 2, upload: 900, download: 900),
            ],
            closed: const [1, 2],
          ),
        ),
      );

      expect(book.snapshot(), const [
        NodeTraffic(name: 'HK-1', up: 40, down: 80),
      ]);
    });

    test(
      'deduplicates overlapping updates across connections and counters',
      () {
        final book = NodeTrafficBook();

        book.applyConnections(
          ConnectionsChanged(
            ConnectionDelta(
              opened: [
                _conn(1, chains: const ['JP-1'], upload: 10, download: 20),
              ],
            ),
          ),
        );
        book.applyCounters(
          const ConnectionsChanged(
            ConnectionDelta(
              counters: [ConnectionCounter(id: 1, upload: 30, download: 50)],
            ),
          ),
        );
        // Duplicate or older values must not double-count or decrease totals.
        book.applyCounters(
          const ConnectionsChanged(
            ConnectionDelta(
              counters: [
                ConnectionCounter(id: 1, upload: 25, download: 40),
                ConnectionCounter(id: 1, upload: 30, download: 50),
                ConnectionCounter(id: 99, upload: 999, download: 999),
              ],
            ),
          ),
        );
        book.applyConnections(
          const ConnectionsChanged(
            ConnectionDelta(
              counters: [ConnectionCounter(id: 1, upload: 60, download: 100)],
              closed: [1],
            ),
          ),
        );

        expect(book.snapshot(), const [
          NodeTraffic(name: 'JP-1', up: 60, down: 100),
        ]);
      },
    );

    test('resync snapshot preserves closed totals without recounting open', () {
      final book = NodeTrafficBook();

      book.applyConnections(
        ConnectionsChanged(
          ConnectionDelta(
            opened: [
              _conn(1, chains: const ['US-1'], upload: 100, download: 200),
              _conn(2, chains: const ['SG-1'], upload: 50, download: 50),
            ],
            closed: const [2],
          ),
        ),
      );
      book.applyConnections(
        ConnectionsReset(
          ConnectionSnapshot([
            _conn(1, chains: const ['US-1'], upload: 150, download: 260),
            _conn(3, chains: const ['US-1'], upload: 10, download: 20),
          ]),
        ),
      );

      expect(book.snapshot(), const [
        NodeTraffic(name: 'US-1', up: 160, down: 280),
        NodeTraffic(name: 'SG-1', up: 50, down: 50),
      ]);
    });

    test('resetTotals zeroes totals while keeping open baselines', () {
      final book = NodeTrafficBook();

      book.applyConnections(
        ConnectionsChanged(
          ConnectionDelta(
            opened: [
              _conn(1, chains: const ['HK-1'], upload: 100, download: 300),
            ],
          ),
        ),
      );
      final beforeRev = book.revision;
      book.resetTotals();
      expect(book.revision, greaterThan(beforeRev));
      expect(book.snapshot(), isEmpty);

      book.applyCounters(
        const ConnectionsChanged(
          ConnectionDelta(
            counters: [ConnectionCounter(id: 1, upload: 130, download: 370)],
          ),
        ),
      );
      expect(book.snapshot(), const [
        NodeTraffic(name: 'HK-1', up: 30, down: 70),
      ]);

      book.clear();
      expect(book.snapshot(), isEmpty);
      book.applyCounters(
        const ConnectionsChanged(
          ConnectionDelta(
            counters: [ConnectionCounter(id: 1, upload: 200, download: 500)],
          ),
        ),
      );
      expect(book.snapshot(), isEmpty);
    });

    test(
      'sorts by total desc, name asc, provider asc and drops zero traffic',
      () {
        final book = NodeTrafficBook();

        book.applyConnections(
          ConnectionsChanged(
            ConnectionDelta(
              opened: [
                _conn(1, chains: const ['Zero'], upload: 0, download: 0),
                _conn(
                  2,
                  chains: const ['Beta'],
                  providerChains: const ['p2'],
                  upload: 10,
                  download: 20,
                ),
                _conn(
                  3,
                  chains: const ['Alpha'],
                  providerChains: const ['p2'],
                  upload: 10,
                  download: 20,
                ),
                _conn(
                  4,
                  chains: const ['Alpha'],
                  providerChains: const ['p1'],
                  upload: 10,
                  download: 20,
                ),
                _conn(5, chains: const ['Top'], upload: 40, download: 60),
              ],
            ),
          ),
        );

        expect(book.snapshot(), const [
          NodeTraffic(name: 'Top', up: 40, down: 60),
          NodeTraffic(name: 'Alpha', provider: 'p1', up: 10, down: 20),
          NodeTraffic(name: 'Alpha', provider: 'p2', up: 10, down: 20),
          NodeTraffic(name: 'Beta', provider: 'p2', up: 10, down: 20),
        ]);
      },
    );
  });
}
