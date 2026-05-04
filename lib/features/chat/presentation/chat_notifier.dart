// lib/features/chat/presentation/chat_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/core/firebase/firebase_providers.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/chat/data/chat_repository.dart';
import 'package:tropicaguide/features/chat/domain/message.dart';

part 'chat_notifier.g.dart';

/// Provides the [ChatRepository] singleton.
@riverpod
ChatRepository chatRepository(Ref ref) =>
    ChatRepository(ref.watch(firestoreProvider));

/// Real-time stream of messages for [tripId], ordered oldest-first.
@riverpod
Stream<List<Message>> messagesStream(Ref ref, String tripId) =>
    ref.watch(chatRepositoryProvider).messagesStream(tripId);

/// Notifier for sending chat messages.
@riverpod
class ChatNotifier extends _$ChatNotifier {
  @override
  AsyncValue<void> build(String tripId) => const AsyncData(null);

  /// Sends [text] as a message from the current user.
  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) return;
    state = const AsyncLoading();
    try {
      await ref.read(chatRepositoryProvider).sendMessage(
            tripId: tripId,
            text: text.trim(),
            senderUid: user.uid,
            senderName: user.displayName ?? user.email,
          );
      state = const AsyncData(null);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
