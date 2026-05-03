import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore DTO for an activity document.
class ActivityDto {
  /// Creates an [ActivityDto].
  const ActivityDto({
    required this.activityId,
    required this.title,
    required this.category,
    required this.locationName,
    required this.estimatedCost,
    required this.durationMinutes,
    required this.position,
    required this.proposedBy,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.startTime,
    this.imageAssetPath,
    this.imageStorageUrl,
    this.scoreDistance,
    this.scoreBudget,
    this.scoreTimeFit,
  });

  /// Creates an [ActivityDto] from a Firestore document snapshot.
  factory ActivityDto.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data()!;
    return ActivityDto(
      activityId: doc.id,
      title: d['title'] as String? ?? '',
      description: d['description'] as String?,
      category: d['category'] as String? ?? 'sightseeing',
      locationName: d['locationName'] as String? ?? '',
      estimatedCost: (d['estimatedCost'] as num?)?.toInt() ?? 0,
      durationMinutes: (d['durationMinutes'] as num?)?.toInt() ?? 60,
      startTime: d['startTime'] as Timestamp?,
      imageAssetPath: d['imageAssetPath'] as String?,
      imageStorageUrl: d['imageStorageUrl'] as String?,
      position: (d['position'] as num?)?.toDouble() ?? 0,
      scoreDistance: (d['scoreDistance'] as num?)?.toInt(),
      scoreBudget: (d['scoreBudget'] as num?)?.toInt(),
      scoreTimeFit: (d['scoreTimeFit'] as num?)?.toInt(),
      proposedBy: d['proposedBy'] as String? ?? '',
      createdBy: d['createdBy'] as String? ?? '',
      createdAt: d['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: d['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  /// Converts this DTO to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() => {
        'title': title,
        'description': description,
        'category': category,
        'locationName': locationName,
        'estimatedCost': estimatedCost,
        'durationMinutes': durationMinutes,
        'startTime': startTime,
        'imageAssetPath': imageAssetPath,
        'imageStorageUrl': imageStorageUrl,
        'position': position,
        'scoreDistance': scoreDistance,
        'scoreBudget': scoreBudget,
        'scoreTimeFit': scoreTimeFit,
        'proposedBy': proposedBy,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  /// Firestore document ID.
  final String activityId;

  /// Activity title.
  final String title;

  /// Optional description.
  final String? description;

  /// Category: food | sightseeing | adventure | rest | transport.
  final String category;

  /// Venue or place name.
  final String locationName;

  /// Estimated cost in cents.
  final int estimatedCost;

  /// Duration in minutes.
  final int durationMinutes;

  /// Scheduled time if pinned.
  final Timestamp? startTime;

  /// Seed asset image path.
  final String? imageAssetPath;

  /// Firebase Storage URL.
  final String? imageStorageUrl;

  /// Float position for drag-and-drop ordering.
  final double position;

  /// Distance score 0–100 from optimiser.
  final int? scoreDistance;

  /// Budget score 0–100 from optimiser.
  final int? scoreBudget;

  /// Time-fit score 0–100 from optimiser.
  final int? scoreTimeFit;

  /// UID of the user who proposed this activity.
  final String proposedBy;

  /// UID of the document creator.
  final String createdBy;

  /// Server timestamp.
  final Timestamp createdAt;

  /// Server timestamp.
  final Timestamp updatedAt;
}
