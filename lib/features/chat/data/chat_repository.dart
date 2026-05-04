// lib/features/chat/data/chat_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/features/chat/domain/message.dart';

/// Handles Firestore reads and writes for trip chat messages.
class ChatRepository {
  /// Creates a [ChatRepository].
  const ChatRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messages(String tripId) =>
      _firestore.collection('trips').doc(tripId).collection('messages');

  /// Real-time stream of messages for [tripId], ordered oldest-first.
  Stream<List<Message>> messagesStream(String tripId) =>
      _messages(tripId)
          .orderBy('createdAt')
          .snapshots()
          .map(
            (snap) => snap.docs.map(_toDomain).toList(),
          );

  /// Sends a new message to the trip chat.
  Future<void> sendMessage({
    required String tripId,
    required String text,
    required String senderUid,
    required String senderName,
  }) async {
    final ref = _messages(tripId).doc();
    await ref.set({
      'text': text.trim(),
      'senderUid': senderUid,
      'senderName': senderName,
      'createdAt': FieldValue.serverTimestamp(),
    });
    appLogger.i('ChatRepository: sent message → ${ref.id}');
  }

  Message _toDomain(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Message(
      messageId: doc.id,
      text: data['text'] as String? ?? '',
      senderUid: data['senderUid'] as String? ?? '',
      senderName: data['senderName'] as String? ?? 'Unknown',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
