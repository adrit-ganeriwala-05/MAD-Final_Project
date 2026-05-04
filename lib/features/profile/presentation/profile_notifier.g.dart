// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'39cd4fc6c58f14c281418bc3321d1520df650306';

/// Provides the [UserRepository] singleton.
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider = AutoDisposeProvider<UserRepository>.internal(
  userRepository,
  name: r'userRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserRepositoryRef = AutoDisposeProviderRef<UserRepository>;
String _$userProfileHash() => r'3d33c12cbee77b4fa05460cc8e58fd81e1d2c780';

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

/// Real-time stream of the user's Firestore profile.
///
/// Copied from [userProfile].
@ProviderFor(userProfile)
const userProfileProvider = UserProfileFamily();

/// Real-time stream of the user's Firestore profile.
///
/// Copied from [userProfile].
class UserProfileFamily extends Family<AsyncValue<UserProfile?>> {
  /// Real-time stream of the user's Firestore profile.
  ///
  /// Copied from [userProfile].
  const UserProfileFamily();

  /// Real-time stream of the user's Firestore profile.
  ///
  /// Copied from [userProfile].
  UserProfileProvider call(
    String uid,
  ) {
    return UserProfileProvider(
      uid,
    );
  }

  @override
  UserProfileProvider getProviderOverride(
    covariant UserProfileProvider provider,
  ) {
    return call(
      provider.uid,
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
  String? get name => r'userProfileProvider';
}

/// Real-time stream of the user's Firestore profile.
///
/// Copied from [userProfile].
class UserProfileProvider extends AutoDisposeStreamProvider<UserProfile?> {
  /// Real-time stream of the user's Firestore profile.
  ///
  /// Copied from [userProfile].
  UserProfileProvider(
    String uid,
  ) : this._internal(
          (ref) => userProfile(
            ref as UserProfileRef,
            uid,
          ),
          from: userProfileProvider,
          name: r'userProfileProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$userProfileHash,
          dependencies: UserProfileFamily._dependencies,
          allTransitiveDependencies:
              UserProfileFamily._allTransitiveDependencies,
          uid: uid,
        );

  UserProfileProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String uid;

  @override
  Override overrideWith(
    Stream<UserProfile?> Function(UserProfileRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserProfileProvider._internal(
        (ref) => create(ref as UserProfileRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<UserProfile?> createElement() {
    return _UserProfileProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserProfileProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserProfileRef on AutoDisposeStreamProviderRef<UserProfile?> {
  /// The parameter `uid` of this provider.
  String get uid;
}

class _UserProfileProviderElement
    extends AutoDisposeStreamProviderElement<UserProfile?> with UserProfileRef {
  _UserProfileProviderElement(super.provider);

  @override
  String get uid => (origin as UserProfileProvider).uid;
}

String _$userBootstrapHash() => r'19c52298f3008c1b27d29465002b40e9315fc213';

/// Bootstraps the user profile document on first sign-in.
///
/// Copied from [userBootstrap].
@ProviderFor(userBootstrap)
final userBootstrapProvider = AutoDisposeFutureProvider<void>.internal(
  userBootstrap,
  name: r'userBootstrapProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userBootstrapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserBootstrapRef = AutoDisposeFutureProviderRef<void>;
String _$profileNotifierHash() => r'1822a1b8a75c0033bcdab6c31795797a3657f1ba';

/// Notifier for profile edit operations.
///
/// Copied from [ProfileNotifier].
@ProviderFor(ProfileNotifier)
final profileNotifierProvider =
    AutoDisposeNotifierProvider<ProfileNotifier, AsyncValue<void>>.internal(
  ProfileNotifier.new,
  name: r'profileNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
