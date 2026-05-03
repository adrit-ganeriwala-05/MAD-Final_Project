import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/core/firebase/firebase_providers.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/checklist/data/checklist_repository.dart';
import 'package:tropicaguide/features/checklist/domain/checklist_item.dart';

part 'checklist_notifier.g.dart';

/// Provides the [ChecklistRepository] singleton.
@riverpod
ChecklistRepository checklistRepository(Ref ref) =>
    ChecklistRepository(ref.watch(firestoreProvider));

/// Real-time stream of checklist items for a trip.
@riverpod
Stream<List<ChecklistItem>> checklistStream(Ref ref, String tripId) =>
    ref.watch(checklistRepositoryProvider).checklistStream(tripId);

/// Notifier for checklist operations.
@riverpod
class ChecklistNotifier extends _$ChecklistNotifier {
  @override
  AsyncValue<void> build(String tripId) => const AsyncData(null);

  /// Toggles a checklist item using a Firestore transaction.
  Future<void> toggle(String itemId) async {
    try {
      await ref.read(checklistRepositoryProvider).toggleItem(
            tripId: tripId,
            itemId: itemId,
          );
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Adds a new checklist item.
  Future<void> addItem({
    required String label,
    required String category,
  }) async {
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) return;
    try {
      await ref.read(checklistRepositoryProvider).addItem(
            tripId: tripId,
            label: label,
            category: category,
            userId: user.uid,
          );
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Deletes a checklist item.
  Future<void> deleteItem(String itemId) async {
    try {
      await ref.read(checklistRepositoryProvider).deleteItem(
            tripId: tripId,
            itemId: itemId,
          );
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
