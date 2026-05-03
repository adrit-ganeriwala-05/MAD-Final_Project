import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/features/checklist/data/checklist_item_dto.dart';
import 'package:tropicaguide/features/checklist/domain/checklist_item.dart';

/// Handles all Firestore reads and writes for checklist items.
///
/// All toggle operations use Firestore transactions to prevent
/// concurrent write conflicts — this is the proposal's key evidence requirement.
class ChecklistRepository {
  /// Creates a [ChecklistRepository].
  const ChecklistRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _checklist(String tripId) =>
      _firestore
          .collection('trips')
          .doc(tripId)
          .collection('checklist');

  /// Real-time stream of checklist items for [tripId].
  Stream<List<ChecklistItem>> checklistStream(String tripId) =>
      _checklist(tripId)
          .orderBy('position')
          .snapshots()
          .map(
            (snap) => snap.docs
                .map((doc) => _toDomain(ChecklistItemDto.fromFirestore(doc)))
                .toList(),
          );

  /// Toggles isChecked using a Firestore transaction.
  ///
  /// The transaction reads the current value before writing, preventing
  /// lost updates when multiple users toggle simultaneously.
  Future<void> toggleItem({
    required String tripId,
    required String itemId,
  }) async {
    final ref = _checklist(tripId).doc(itemId);
    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) return;
      final current = snapshot.data()!['isChecked'] as bool? ?? false;
      transaction.update(ref, {
        'isChecked': !current,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
    appLogger.i('ChecklistRepository: toggled $itemId');
  }

  /// Adds a new checklist item.
  Future<void> addItem({
    required String tripId,
    required String label,
    required String category,
    required String userId,
  }) async {
    final ref = _checklist(tripId).doc();
    final now = FieldValue.serverTimestamp();
    await ref.set({
      'label': label.trim(),
      'isChecked': false,
      'category': category,
      'position': DateTime.now().millisecondsSinceEpoch.toDouble(),
      'assignedTo': null,
      'dueDate': null,
      'createdBy': userId,
      'createdAt': now,
      'updatedAt': now,
    });
    appLogger.i('ChecklistRepository: added item → ${ref.id}');
  }

  /// Deletes a checklist item.
  Future<void> deleteItem({
    required String tripId,
    required String itemId,
  }) async {
    await _checklist(tripId).doc(itemId).delete();
    appLogger.i('ChecklistRepository: deleted $itemId');
  }

  /// Converts a [ChecklistItemDto] to a [ChecklistItem] domain model.
  ChecklistItem _toDomain(ChecklistItemDto dto) => ChecklistItem(
        itemId: dto.itemId,
        label: dto.label,
        isChecked: dto.isChecked,
        category: dto.category,
        position: dto.position,
        createdBy: dto.createdBy,
        assignedTo: dto.assignedTo,
        dueDate: dto.dueDate,
        createdAt: dto.createdAt.toDate(),
        updatedAt: dto.updatedAt.toDate(),
      );
}
