// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../core.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coreHandler)
final coreHandlerProvider = CoreHandlerProvider._();

final class CoreHandlerProvider
    extends $FunctionalProvider<CoreController, CoreController, CoreController>
    with $Provider<CoreController> {
  CoreHandlerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coreHandlerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coreHandlerHash();

  @$internal
  @override
  $ProviderElement<CoreController> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CoreController create(Ref ref) {
    return coreHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoreController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoreController>(value),
    );
  }
}

String _$coreHandlerHash() => r'b00cbd733d546e4edd1a0b9b98e9ace46da1eff2';

/// Kept apart from the state it feeds: the Core's stream moves it, and the
/// pages that show connections read it on their own cadence.

@ProviderFor(connectionBook)
final connectionBookProvider = ConnectionBookProvider._();

/// Kept apart from the state it feeds: the Core's stream moves it, and the
/// pages that show connections read it on their own cadence.

final class ConnectionBookProvider
    extends $FunctionalProvider<ConnectionBook, ConnectionBook, ConnectionBook>
    with $Provider<ConnectionBook> {
  /// Kept apart from the state it feeds: the Core's stream moves it, and the
  /// pages that show connections read it on their own cadence.
  ConnectionBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectionBookProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectionBookHash();

  @$internal
  @override
  $ProviderElement<ConnectionBook> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConnectionBook create(Ref ref) {
    return connectionBook(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConnectionBook value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConnectionBook>(value),
    );
  }
}

String _$connectionBookHash() => r'c084bac9d322cdd66b3e543b5a1766025705398c';

@ProviderFor(nodeTrafficBook)
final nodeTrafficBookProvider = NodeTrafficBookProvider._();

final class NodeTrafficBookProvider
    extends
        $FunctionalProvider<NodeTrafficBook, NodeTrafficBook, NodeTrafficBook>
    with $Provider<NodeTrafficBook> {
  NodeTrafficBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nodeTrafficBookProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nodeTrafficBookHash();

  @$internal
  @override
  $ProviderElement<NodeTrafficBook> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NodeTrafficBook create(Ref ref) {
    return nodeTrafficBook(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NodeTrafficBook value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NodeTrafficBook>(value),
    );
  }
}

String _$nodeTrafficBookHash() => r'753eb0d5af99f061673d1c7b543856401f6e8adf';

@ProviderFor(coreStateSync)
final coreStateSyncProvider = CoreStateSyncProvider._();

final class CoreStateSyncProvider
    extends $FunctionalProvider<CoreStateSync, CoreStateSync, CoreStateSync>
    with $Provider<CoreStateSync> {
  CoreStateSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coreStateSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coreStateSyncHash();

  @$internal
  @override
  $ProviderElement<CoreStateSync> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CoreStateSync create(Ref ref) {
    return coreStateSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CoreStateSync value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CoreStateSync>(value),
    );
  }
}

String _$coreStateSyncHash() => r'30a64c8adb4793928b90822af2fdde0bf69b631d';
