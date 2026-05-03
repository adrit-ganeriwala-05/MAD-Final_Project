import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/features/itinerary/data/activity_dto.dart';
import 'package:tropicaguide/features/itinerary/domain/activity.dart';

/// Handles all Firestore reads and writes for activities.
class ActivityRepository {
  /// Creates an [ActivityRepository].
  const ActivityRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _activities(String tripId) =>
      _firestore.collection('trips').doc(tripId).collection('activities');

  /// Real-time stream of activities for [tripId], ordered by position.
  Stream<List<Activity>> activitiesStream(String tripId) =>
      _activities(tripId).orderBy('position').snapshots().map(
            (snap) => snap.docs
                .map((doc) => _toDomain(ActivityDto.fromFirestore(doc)))
                .toList(),
          );

  /// Adds a new activity to a trip.
  Future<void> addActivity({
    required String tripId,
    required String title,
    required String category,
    required String locationName,
    required int estimatedCost,
    required int durationMinutes,
    required String userId,
    String? description,
    double? position,
  }) async {
    final ref = _activities(tripId).doc();
    final now = FieldValue.serverTimestamp();
    await ref.set({
      'title': title.trim(),
      'description': description?.trim(),
      'category': category,
      'locationName': locationName.trim(),
      'estimatedCost': estimatedCost,
      'durationMinutes': durationMinutes,
      'startTime': null,
      'imageAssetPath': null,
      'imageStorageUrl': null,
      'position': position ?? DateTime.now().millisecondsSinceEpoch.toDouble(),
      'scoreDistance': null,
      'scoreBudget': null,
      'scoreTimeFit': null,
      'proposedBy': userId,
      'createdBy': userId,
      'createdAt': now,
      'updatedAt': now,
    });
    appLogger.i('ActivityRepository: added activity → ${ref.id}');
  }

  /// Deletes an activity.
  Future<void> deleteActivity({
    required String tripId,
    required String activityId,
  }) async {
    await _activities(tripId).doc(activityId).delete();
    appLogger.i('ActivityRepository: deleted → $activityId');
  }

  /// Batch-updates positions after a drag-and-drop reorder.
  Future<void> reorderActivities({
    required String tripId,
    required List<Activity> activities,
  }) async {
    final batch = _firestore.batch();
    for (var i = 0; i < activities.length; i++) {
      batch.update(
        _activities(tripId).doc(activities[i].activityId),
        {'position': i.toDouble(), 'updatedAt': FieldValue.serverTimestamp()},
      );
    }
    await batch.commit();
    appLogger
        .i('ActivityRepository: reordered ${activities.length} activities');
  }

  /// Converts an [ActivityDto] to an [Activity] domain model.
  Activity _toDomain(ActivityDto dto) => Activity(
        activityId: dto.activityId,
        title: dto.title,
        description: dto.description,
        category: dto.category,
        locationName: dto.locationName,
        estimatedCost: dto.estimatedCost,
        durationMinutes: dto.durationMinutes,
        startTime: dto.startTime?.toDate(),
        imageAssetPath: dto.imageAssetPath,
        imageStorageUrl: dto.imageStorageUrl,
        position: dto.position,
        scoreDistance: dto.scoreDistance,
        scoreBudget: dto.scoreBudget,
        scoreTimeFit: dto.scoreTimeFit,
        proposedBy: dto.proposedBy,
        createdBy: dto.createdBy,
        createdAt: dto.createdAt.toDate(),
        updatedAt: dto.updatedAt.toDate(),
      );
}
