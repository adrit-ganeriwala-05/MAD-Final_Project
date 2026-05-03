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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
