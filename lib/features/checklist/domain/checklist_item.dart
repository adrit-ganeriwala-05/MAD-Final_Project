/// Domain model for a checklist item.
class ChecklistItem {
  /// Creates a [ChecklistItem].
  const ChecklistItem({
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

  /// Firestore document ID.
  final String itemId;

  /// Display label.
  final String label;

  /// Whether the item is checked.
  final bool isChecked;

  /// Category: packing | todo | document.
  final String category;

  /// Display order position.
  final double position;

  /// UID of the user who created this item.
  final String createdBy;

  /// UID of the user this item is assigned to.
  final String? assignedTo;

  /// Optional due date for todo items.
  final DateTime? dueDate;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last updated timestamp.
  final DateTime updatedAt;

  /// Creates a copy with updated fields.
  ChecklistItem copyWith({bool? isChecked}) => ChecklistItem(
        itemId: itemId,
        label: label,
        isChecked: isChecked ?? this.isChecked,
        category: category,
        position: position,
        createdBy: createdBy,
        assignedTo: assignedTo,
        dueDate: dueDate,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
