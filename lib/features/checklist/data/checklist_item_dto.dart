import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore DTO for a checklist item document.
class ChecklistItemDto {
  /// Creates a [ChecklistItemDto].
  const ChecklistItemDto({
    required this.itemId,
    required this.label,
    required this.isChecked,
    required this.category,
    required this.position,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.assignedTo,
    this.dueDate,
  });

  /// Creates a [ChecklistItemDto] from a Firestore document snapshot.
  factory ChecklistItemDto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return ChecklistItemDto(
      itemId: doc.id,
      label: d['label'] as String? ?? '',
      isChecked: d['isChecked'] as bool? ?? false,
      category: d['category'] as String? ?? 'packing',
      position: (d['position'] as num?)?.toDouble() ?? 0,
      createdBy: d['createdBy'] as String? ?? '',
      assignedTo: d['assignedTo'] as String?,
      dueDate: (d['dueDate'] as Timestamp?)?.toDate(),
      createdAt: d['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: d['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  /// Firestore document ID.
  final String itemId;

  /// Display label.
  final String label;

  /// Whether the item is checked.
  final bool isChecked;

  /// Category.
  final String category;

  /// Display order position.
  final double position;

  /// UID of creator.
  final String createdBy;

  /// UID of assignee.
  final String? assignedTo;

  /// Optional due date.
  final DateTime? dueDate;

  /// Server timestamp.
  final Timestamp createdAt;

  /// Server timestamp.
  final Timestamp updatedAt;
}
