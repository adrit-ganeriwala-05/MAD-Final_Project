// lib/features/chat/domain/message.dart

/// Domain model for a single chat message in a trip.
class Message {
  /// Creates a [Message].
  const Message({
    required this.messageId,
    required this.text,
    required this.senderUid,
    required this.senderName,
    required this.createdAt,
  });

  /// Firestore document ID.
  final String messageId;

  /// Message body.
  final String text;

  /// UID of the sender.
  final String senderUid;

  /// Display name of the sender.
  final String senderName;

  /// When the message was sent.
  final DateTime createdAt;
}
