
// ignore_for_file: avoid_catches_without_on_clauses

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/core/firebase/firebase_providers.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/itinerary/data/activity_repository.dart';
import 'package:tropicaguide/features/itinerary/domain/activity.dart';

part 'itinerary_notifier.g.dart';

/// Provides the [ActivityRepository] singleton.
@riverpod
ActivityRepository activityRepository(Ref ref) =>
    ActivityRepository(ref.watch(firestoreProvider));

/// Real-time stream of activities for a given trip.
@riverpod
Stream<List<Activity>> activitiesStream(Ref ref, String tripId) =>
    ref.watch(activityRepositoryProvider).activitiesStream(tripId);

/// Notifier for itinerary builder operations.
@riverpod
class ItineraryNotifier extends _$ItineraryNotifier {
  @override
  AsyncValue<void> build(String tripId) => const AsyncData(null);

  /// Adds a new activity to the trip.
  Future<void> addActivity({
    required String title,
    required String category,
    required String locationName,
    required int estimatedCost,
    required int durationMinutes,
    String? description,
  }) async {
    state = const AsyncLoading();
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) return;
    try {
      await ref.read(activityRepositoryProvider).addActivity(
            tripId: tripId,
            title: title,
            category: category,
            locationName: locationName,
            estimatedCost: estimatedCost,
            durationMinutes: durationMinutes,
            userId: user.uid,
            description: description,
          );
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Deletes an activity.
  Future<void> deleteActivity(String activityId) async {
    try {
      await ref.read(activityRepositoryProvider).deleteActivity(
            tripId: tripId,
            activityId: activityId,
          );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Reorders activities after a drag-and-drop interaction.
  Future<void> reorder(List<Activity> activities) async {
    try {
      await ref.read(activityRepositoryProvider).reorderActivities(
            tripId: tripId,
            activities: activities,
          );
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
