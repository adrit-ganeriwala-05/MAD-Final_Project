// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trips_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$tripRepositoryHash() => r'161d9509eea9af04d1faa2b39e6e93cb6b1d70ea';

/// Provides the [TripRepository] singleton.
///
/// Copied from [tripRepository].
@ProviderFor(tripRepository)
final tripRepositoryProvider = AutoDisposeProvider<TripRepository>.internal(
  tripRepository,
  name: r'tripRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tripRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripRepositoryRef = AutoDisposeProviderRef<TripRepository>;
String _$tripsStreamHash() => r'65ee93204d1f74060c913987dc425b1cf999a1bc';

/// Real-time stream of the current user's trips.
///
/// Copied from [tripsStream].
@ProviderFor(tripsStream)
final tripsStreamProvider = AutoDisposeStreamProvider<List<Trip>>.internal(
  tripsStream,
  name: r'tripsStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tripsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TripsStreamRef = AutoDisposeStreamProviderRef<List<Trip>>;
String _$tripStreamHash() => r'956fbdc1601f4a054bd7e09ab6564d0caf776173';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Real-time stream of a single trip by [tripId].
///
/// Copied from [tripStream].
@ProviderFor(tripStream)
const tripStreamProvider = TripStreamFamily();

/// Real-time stream of a single trip by [tripId].
///
/// Copied from [tripStream].
class TripStreamFamily extends Family<AsyncValue<Trip?>> {
  /// Real-time stream of a single trip by [tripId].
  ///
  /// Copied from [tripStream].
  const TripStreamFamily();

  /// Real-time stream of a single trip by [tripId].
  ///
  /// Copied from [tripStream].
  TripStreamProvider call(
    String tripId,
  ) {
    return TripStreamProvider(
      tripId,
    );
  }

  @override
  TripStreamProvider getProviderOverride(
    covariant TripStreamProvider provider,
  ) {
    return call(
      provider.tripId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tripStreamProvider';
}

/// Real-time stream of a single trip by [tripId].
///
/// Copied from [tripStream].
class TripStreamProvider extends AutoDisposeStreamProvider<Trip?> {
  /// Real-time stream of a single trip by [tripId].
  ///
  /// Copied from [tripStream].
  TripStreamProvider(
    String tripId,
  ) : this._internal(
          (ref) => tripStream(
            ref as TripStreamRef,
            tripId,
          ),
          from: tripStreamProvider,
          name: r'tripStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripStreamHash,
          dependencies: TripStreamFamily._dependencies,
          allTransitiveDependencies:
              TripStreamFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripStreamProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
  }) : super.internal();

  final String tripId;

  @override
  Override overrideWith(
    Stream<Trip?> Function(TripStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TripStreamProvider._internal(
        (ref) => create(ref as TripStreamRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Trip?> createElement() {
    return _TripStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripStreamProvider && other.tripId == tripId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TripStreamRef on AutoDisposeStreamProviderRef<Trip?> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripStreamProviderElement extends AutoDisposeStreamProviderElement<Trip?>
    with TripStreamRef {
  _TripStreamProviderElement(super.provider);

  @override
  String get tripId => (origin as TripStreamProvider).tripId;
}

String _$createTripNotifierHash() =>
    r'5d8e54e85baa639ecc7bd3c58e8785dd6c75c9da';

/// Notifier for create-trip form state.
///
/// Copied from [CreateTripNotifier].
@ProviderFor(CreateTripNotifier)
final createTripNotifierProvider =
    AutoDisposeNotifierProvider<CreateTripNotifier, AsyncValue<void>>.internal(
  CreateTripNotifier.new,
  name: r'createTripNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createTripNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreateTripNotifier = AutoDisposeNotifier<AsyncValue<void>>;
String _$joinTripNotifierHash() => r'ad1337e6f52620585a0c2d9a4ae1862a968ef6ae';

/// Notifier for the join-trip-by-invite-code flow.
///
/// Copied from [JoinTripNotifier].
@ProviderFor(JoinTripNotifier)
final joinTripNotifierProvider =
    AutoDisposeNotifierProvider<JoinTripNotifier, AsyncValue<void>>.internal(
  JoinTripNotifier.new,
  name: r'joinTripNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$joinTripNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JoinTripNotifier = AutoDisposeNotifier<AsyncValue<void>>;
String _$tripCoverNotifierHash() => r'32f98924a236b26ab728348af1461f4845445f8c';

abstract class _$TripCoverNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<void>> {
  late final String tripId;

  AsyncValue<void> build(
    String tripId,
  );
}

/// Notifier for uploading a trip cover image.
///
/// Copied from [TripCoverNotifier].
@ProviderFor(TripCoverNotifier)
const tripCoverNotifierProvider = TripCoverNotifierFamily();

/// Notifier for uploading a trip cover image.
///
/// Copied from [TripCoverNotifier].
class TripCoverNotifierFamily extends Family<AsyncValue<void>> {
  /// Notifier for uploading a trip cover image.
  ///
  /// Copied from [TripCoverNotifier].
  const TripCoverNotifierFamily();

  /// Notifier for uploading a trip cover image.
  ///
  /// Copied from [TripCoverNotifier].
  TripCoverNotifierProvider call(
    String tripId,
  ) {
    return TripCoverNotifierProvider(
      tripId,
    );
  }

  @override
  TripCoverNotifierProvider getProviderOverride(
    covariant TripCoverNotifierProvider provider,
  ) {
    return call(
      provider.tripId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'tripCoverNotifierProvider';
}

/// Notifier for uploading a trip cover image.
///
/// Copied from [TripCoverNotifier].
class TripCoverNotifierProvider extends AutoDisposeNotifierProviderImpl<
    TripCoverNotifier, AsyncValue<void>> {
  /// Notifier for uploading a trip cover image.
  ///
  /// Copied from [TripCoverNotifier].
  TripCoverNotifierProvider(
    String tripId,
  ) : this._internal(
          () => TripCoverNotifier()..tripId = tripId,
          from: tripCoverNotifierProvider,
          name: r'tripCoverNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tripCoverNotifierHash,
          dependencies: TripCoverNotifierFamily._dependencies,
          allTransitiveDependencies:
              TripCoverNotifierFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  TripCoverNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.tripId,
  }) : super.internal();

  final String tripId;

  @override
  AsyncValue<void> runNotifierBuild(
    covariant TripCoverNotifier notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(TripCoverNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: TripCoverNotifierProvider._internal(
        () => create()..tripId = tripId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        tripId: tripId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<TripCoverNotifier, AsyncValue<void>>
      createElement() {
    return _TripCoverNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TripCoverNotifierProvider && other.tripId == tripId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tripId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TripCoverNotifierRef on AutoDisposeNotifierProviderRef<AsyncValue<void>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _TripCoverNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<TripCoverNotifier,
        AsyncValue<void>> with TripCoverNotifierRef {
  _TripCoverNotifierProviderElement(super.provider);

  @override
  String get tripId => (origin as TripCoverNotifierProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
