// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checklistRepositoryHash() =>
    r'dd7f4ec1b8f114b088f4a7862164f5ff2109b1e3';

/// Provides the [ChecklistRepository] singleton.
///
/// Copied from [checklistRepository].
@ProviderFor(checklistRepository)
final checklistRepositoryProvider =
    AutoDisposeProvider<ChecklistRepository>.internal(
  checklistRepository,
  name: r'checklistRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checklistRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChecklistRepositoryRef = AutoDisposeProviderRef<ChecklistRepository>;
String _$checklistStreamHash() => r'a43f9212931a399c8882761d2aeee85158c7f087';

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

/// Real-time stream of checklist items for a trip.
///
/// Copied from [checklistStream].
@ProviderFor(checklistStream)
const checklistStreamProvider = ChecklistStreamFamily();

/// Real-time stream of checklist items for a trip.
///
/// Copied from [checklistStream].
class ChecklistStreamFamily extends Family<AsyncValue<List<ChecklistItem>>> {
  /// Real-time stream of checklist items for a trip.
  ///
  /// Copied from [checklistStream].
  const ChecklistStreamFamily();

  /// Real-time stream of checklist items for a trip.
  ///
  /// Copied from [checklistStream].
  ChecklistStreamProvider call(
    String tripId,
  ) {
    return ChecklistStreamProvider(
      tripId,
    );
  }

  @override
  ChecklistStreamProvider getProviderOverride(
    covariant ChecklistStreamProvider provider,
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
  String? get name => r'checklistStreamProvider';
}

/// Real-time stream of checklist items for a trip.
///
/// Copied from [checklistStream].
class ChecklistStreamProvider
    extends AutoDisposeStreamProvider<List<ChecklistItem>> {
  /// Real-time stream of checklist items for a trip.
  ///
  /// Copied from [checklistStream].
  ChecklistStreamProvider(
    String tripId,
  ) : this._internal(
          (ref) => checklistStream(
            ref as ChecklistStreamRef,
            tripId,
          ),
          from: checklistStreamProvider,
          name: r'checklistStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checklistStreamHash,
          dependencies: ChecklistStreamFamily._dependencies,
          allTransitiveDependencies:
              ChecklistStreamFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ChecklistStreamProvider._internal(
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
    Stream<List<ChecklistItem>> Function(ChecklistStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChecklistStreamProvider._internal(
        (ref) => create(ref as ChecklistStreamRef),
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
  AutoDisposeStreamProviderElement<List<ChecklistItem>> createElement() {
    return _ChecklistStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChecklistStreamProvider && other.tripId == tripId;
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
mixin ChecklistStreamRef on AutoDisposeStreamProviderRef<List<ChecklistItem>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ChecklistStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<ChecklistItem>>
    with ChecklistStreamRef {
  _ChecklistStreamProviderElement(super.provider);

  @override
  String get tripId => (origin as ChecklistStreamProvider).tripId;
}

String _$checklistNotifierHash() => r'cf646e5f98832a2cda41fdaa4c461e41e7e128dc';

abstract class _$ChecklistNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<void>> {
  late final String tripId;

  AsyncValue<void> build(
    String tripId,
  );
}

/// Notifier for checklist operations.
///
/// Copied from [ChecklistNotifier].
@ProviderFor(ChecklistNotifier)
const checklistNotifierProvider = ChecklistNotifierFamily();

/// Notifier for checklist operations.
///
/// Copied from [ChecklistNotifier].
class ChecklistNotifierFamily extends Family<AsyncValue<void>> {
  /// Notifier for checklist operations.
  ///
  /// Copied from [ChecklistNotifier].
  const ChecklistNotifierFamily();

  /// Notifier for checklist operations.
  ///
  /// Copied from [ChecklistNotifier].
  ChecklistNotifierProvider call(
    String tripId,
  ) {
    return ChecklistNotifierProvider(
      tripId,
    );
  }

  @override
  ChecklistNotifierProvider getProviderOverride(
    covariant ChecklistNotifierProvider provider,
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
  String? get name => r'checklistNotifierProvider';
}

/// Notifier for checklist operations.
///
/// Copied from [ChecklistNotifier].
class ChecklistNotifierProvider extends AutoDisposeNotifierProviderImpl<
    ChecklistNotifier, AsyncValue<void>> {
  /// Notifier for checklist operations.
  ///
  /// Copied from [ChecklistNotifier].
  ChecklistNotifierProvider(
    String tripId,
  ) : this._internal(
          () => ChecklistNotifier()..tripId = tripId,
          from: checklistNotifierProvider,
          name: r'checklistNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$checklistNotifierHash,
          dependencies: ChecklistNotifierFamily._dependencies,
          allTransitiveDependencies:
              ChecklistNotifierFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ChecklistNotifierProvider._internal(
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
    covariant ChecklistNotifier notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(ChecklistNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChecklistNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<ChecklistNotifier, AsyncValue<void>>
      createElement() {
    return _ChecklistNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChecklistNotifierProvider && other.tripId == tripId;
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
mixin ChecklistNotifierRef on AutoDisposeNotifierProviderRef<AsyncValue<void>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ChecklistNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ChecklistNotifier,
        AsyncValue<void>> with ChecklistNotifierRef {
  _ChecklistNotifierProviderElement(super.provider);

  @override
  String get tripId => (origin as ChecklistNotifierProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
