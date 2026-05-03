// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityRepositoryHash() =>
    r'50cfc4278867460d8feca18cc1ed9bf8d2416791';

/// Provides the [ActivityRepository] singleton.
///
/// Copied from [activityRepository].
@ProviderFor(activityRepository)
final activityRepositoryProvider =
    AutoDisposeProvider<ActivityRepository>.internal(
  activityRepository,
  name: r'activityRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activityRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivityRepositoryRef = AutoDisposeProviderRef<ActivityRepository>;
String _$activitiesStreamHash() => r'e2c6264ace08ef08f04dd48123e3997b87656671';

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

/// Real-time stream of activities for a given trip.
///
/// Copied from [activitiesStream].
@ProviderFor(activitiesStream)
const activitiesStreamProvider = ActivitiesStreamFamily();

/// Real-time stream of activities for a given trip.
///
/// Copied from [activitiesStream].
class ActivitiesStreamFamily extends Family<AsyncValue<List<Activity>>> {
  /// Real-time stream of activities for a given trip.
  ///
  /// Copied from [activitiesStream].
  const ActivitiesStreamFamily();

  /// Real-time stream of activities for a given trip.
  ///
  /// Copied from [activitiesStream].
  ActivitiesStreamProvider call(
    String tripId,
  ) {
    return ActivitiesStreamProvider(
      tripId,
    );
  }

  @override
  ActivitiesStreamProvider getProviderOverride(
    covariant ActivitiesStreamProvider provider,
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
  String? get name => r'activitiesStreamProvider';
}

/// Real-time stream of activities for a given trip.
///
/// Copied from [activitiesStream].
class ActivitiesStreamProvider
    extends AutoDisposeStreamProvider<List<Activity>> {
  /// Real-time stream of activities for a given trip.
  ///
  /// Copied from [activitiesStream].
  ActivitiesStreamProvider(
    String tripId,
  ) : this._internal(
          (ref) => activitiesStream(
            ref as ActivitiesStreamRef,
            tripId,
          ),
          from: activitiesStreamProvider,
          name: r'activitiesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activitiesStreamHash,
          dependencies: ActivitiesStreamFamily._dependencies,
          allTransitiveDependencies:
              ActivitiesStreamFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ActivitiesStreamProvider._internal(
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
    Stream<List<Activity>> Function(ActivitiesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActivitiesStreamProvider._internal(
        (ref) => create(ref as ActivitiesStreamRef),
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
  AutoDisposeStreamProviderElement<List<Activity>> createElement() {
    return _ActivitiesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivitiesStreamProvider && other.tripId == tripId;
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
mixin ActivitiesStreamRef on AutoDisposeStreamProviderRef<List<Activity>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ActivitiesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Activity>>
    with ActivitiesStreamRef {
  _ActivitiesStreamProviderElement(super.provider);

  @override
  String get tripId => (origin as ActivitiesStreamProvider).tripId;
}

String _$itineraryNotifierHash() => r'495debdd328ebc9aef91aac322472884040e3ace';

abstract class _$ItineraryNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<void>> {
  late final String tripId;

  AsyncValue<void> build(
    String tripId,
  );
}

/// Notifier for itinerary builder operations.
///
/// Copied from [ItineraryNotifier].
@ProviderFor(ItineraryNotifier)
const itineraryNotifierProvider = ItineraryNotifierFamily();

/// Notifier for itinerary builder operations.
///
/// Copied from [ItineraryNotifier].
class ItineraryNotifierFamily extends Family<AsyncValue<void>> {
  /// Notifier for itinerary builder operations.
  ///
  /// Copied from [ItineraryNotifier].
  const ItineraryNotifierFamily();

  /// Notifier for itinerary builder operations.
  ///
  /// Copied from [ItineraryNotifier].
  ItineraryNotifierProvider call(
    String tripId,
  ) {
    return ItineraryNotifierProvider(
      tripId,
    );
  }

  @override
  ItineraryNotifierProvider getProviderOverride(
    covariant ItineraryNotifierProvider provider,
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
  String? get name => r'itineraryNotifierProvider';
}

/// Notifier for itinerary builder operations.
///
/// Copied from [ItineraryNotifier].
class ItineraryNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ItineraryNotifier, AsyncValue<void>> {
  /// Notifier for itinerary builder operations.
  ///
  /// Copied from [ItineraryNotifier].
  ItineraryNotifierProvider(
    String tripId,
  ) : this._internal(
          () => ItineraryNotifier()..tripId = tripId,
          from: itineraryNotifierProvider,
          name: r'itineraryNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$itineraryNotifierHash,
          dependencies: ItineraryNotifierFamily._dependencies,
          allTransitiveDependencies:
              ItineraryNotifierFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ItineraryNotifierProvider._internal(
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
    covariant ItineraryNotifier notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(ItineraryNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ItineraryNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<ItineraryNotifier, AsyncValue<void>>
      createElement() {
    return _ItineraryNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ItineraryNotifierProvider && other.tripId == tripId;
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
mixin ItineraryNotifierRef on AutoDisposeNotifierProviderRef<AsyncValue<void>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ItineraryNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ItineraryNotifier,
        AsyncValue<void>> with ItineraryNotifierRef {
  _ItineraryNotifierProviderElement(super.provider);

  @override
  String get tripId => (origin as ItineraryNotifierProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
