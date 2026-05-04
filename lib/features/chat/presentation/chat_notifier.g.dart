// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRepositoryHash() => r'91bf3bc9d3b382427c8a11749047886a65a15f8c';

/// Provides the [ChatRepository] singleton.
///
/// Copied from [chatRepository].
@ProviderFor(chatRepository)
final chatRepositoryProvider = AutoDisposeProvider<ChatRepository>.internal(
  chatRepository,
  name: r'chatRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRepositoryRef = AutoDisposeProviderRef<ChatRepository>;
String _$messagesStreamHash() => r'7a50e242f267a88049edd1e410c3d53e215dcbf3';

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

/// Real-time stream of messages for [tripId], ordered oldest-first.
///
/// Copied from [messagesStream].
@ProviderFor(messagesStream)
const messagesStreamProvider = MessagesStreamFamily();

/// Real-time stream of messages for [tripId], ordered oldest-first.
///
/// Copied from [messagesStream].
class MessagesStreamFamily extends Family<AsyncValue<List<Message>>> {
  /// Real-time stream of messages for [tripId], ordered oldest-first.
  ///
  /// Copied from [messagesStream].
  const MessagesStreamFamily();

  /// Real-time stream of messages for [tripId], ordered oldest-first.
  ///
  /// Copied from [messagesStream].
  MessagesStreamProvider call(
    String tripId,
  ) {
    return MessagesStreamProvider(
      tripId,
    );
  }

  @override
  MessagesStreamProvider getProviderOverride(
    covariant MessagesStreamProvider provider,
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
  String? get name => r'messagesStreamProvider';
}

/// Real-time stream of messages for [tripId], ordered oldest-first.
///
/// Copied from [messagesStream].
class MessagesStreamProvider extends AutoDisposeStreamProvider<List<Message>> {
  /// Real-time stream of messages for [tripId], ordered oldest-first.
  ///
  /// Copied from [messagesStream].
  MessagesStreamProvider(
    String tripId,
  ) : this._internal(
          (ref) => messagesStream(
            ref as MessagesStreamRef,
            tripId,
          ),
          from: messagesStreamProvider,
          name: r'messagesStreamProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$messagesStreamHash,
          dependencies: MessagesStreamFamily._dependencies,
          allTransitiveDependencies:
              MessagesStreamFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  MessagesStreamProvider._internal(
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
    Stream<List<Message>> Function(MessagesStreamRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MessagesStreamProvider._internal(
        (ref) => create(ref as MessagesStreamRef),
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
  AutoDisposeStreamProviderElement<List<Message>> createElement() {
    return _MessagesStreamProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MessagesStreamProvider && other.tripId == tripId;
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
mixin MessagesStreamRef on AutoDisposeStreamProviderRef<List<Message>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _MessagesStreamProviderElement
    extends AutoDisposeStreamProviderElement<List<Message>>
    with MessagesStreamRef {
  _MessagesStreamProviderElement(super.provider);

  @override
  String get tripId => (origin as MessagesStreamProvider).tripId;
}

String _$chatNotifierHash() => r'01cd8ef0652c9585fe7489984f76dc7f6e3db65b';

abstract class _$ChatNotifier
    extends BuildlessAutoDisposeNotifier<AsyncValue<void>> {
  late final String tripId;

  AsyncValue<void> build(
    String tripId,
  );
}

/// Notifier for sending chat messages.
///
/// Copied from [ChatNotifier].
@ProviderFor(ChatNotifier)
const chatNotifierProvider = ChatNotifierFamily();

/// Notifier for sending chat messages.
///
/// Copied from [ChatNotifier].
class ChatNotifierFamily extends Family<AsyncValue<void>> {
  /// Notifier for sending chat messages.
  ///
  /// Copied from [ChatNotifier].
  const ChatNotifierFamily();

  /// Notifier for sending chat messages.
  ///
  /// Copied from [ChatNotifier].
  ChatNotifierProvider call(
    String tripId,
  ) {
    return ChatNotifierProvider(
      tripId,
    );
  }

  @override
  ChatNotifierProvider getProviderOverride(
    covariant ChatNotifierProvider provider,
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
  String? get name => r'chatNotifierProvider';
}

/// Notifier for sending chat messages.
///
/// Copied from [ChatNotifier].
class ChatNotifierProvider
    extends AutoDisposeNotifierProviderImpl<ChatNotifier, AsyncValue<void>> {
  /// Notifier for sending chat messages.
  ///
  /// Copied from [ChatNotifier].
  ChatNotifierProvider(
    String tripId,
  ) : this._internal(
          () => ChatNotifier()..tripId = tripId,
          from: chatNotifierProvider,
          name: r'chatNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$chatNotifierHash,
          dependencies: ChatNotifierFamily._dependencies,
          allTransitiveDependencies:
              ChatNotifierFamily._allTransitiveDependencies,
          tripId: tripId,
        );

  ChatNotifierProvider._internal(
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
    covariant ChatNotifier notifier,
  ) {
    return notifier.build(
      tripId,
    );
  }

  @override
  Override overrideWith(ChatNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ChatNotifierProvider._internal(
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
  AutoDisposeNotifierProviderElement<ChatNotifier, AsyncValue<void>>
      createElement() {
    return _ChatNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatNotifierProvider && other.tripId == tripId;
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
mixin ChatNotifierRef on AutoDisposeNotifierProviderRef<AsyncValue<void>> {
  /// The parameter `tripId` of this provider.
  String get tripId;
}

class _ChatNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<ChatNotifier, AsyncValue<void>>
    with ChatNotifierRef {
  _ChatNotifierProviderElement(super.provider);

  @override
  String get tripId => (origin as ChatNotifierProvider).tripId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
