/// Domain model for an activity.
class Activity {
  /// Creates an [Activity].
  const Activity({
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

  /// Firestore document ID.
  final String activityId;

  /// Activity title.
  final String title;

  /// Optional description.
  final String? description;

  /// Category.
  final String category;

  /// Venue or place name.
  final String locationName;

  /// Estimated cost in cents.
  final int estimatedCost;

  /// Duration in minutes.
  final int durationMinutes;

  /// Scheduled time if pinned.
  final DateTime? startTime;

  /// Seed asset image path.
  final String? imageAssetPath;

  /// Firebase Storage URL.
  final String? imageStorageUrl;

  /// Float position for ordering.
  final double position;

  /// Distance score 0–100.
  final int? scoreDistance;

  /// Budget score 0–100.
  final int? scoreBudget;

  /// Time-fit score 0–100.
  final int? scoreTimeFit;

  /// UID of proposer.
  final String proposedBy;

  /// UID of creator.
  final String createdBy;

  /// Creation time.
  final DateTime createdAt;

  /// Last updated time.
  final DateTime updatedAt;

  /// Formatted cost string.
  String get formattedCost => '\$${(estimatedCost / 100).toStringAsFixed(0)}';

  /// Formatted duration string.
  String get formattedDuration {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  /// Returns true if any optimiser score is available.
  bool get hasScores =>
      scoreDistance != null || scoreBudget != null || scoreTimeFit != null;

  /// Creates a copy with updated fields.
  Activity copyWith({double? position}) => Activity(
        activityId: activityId,
        title: title,
        description: description,
        category: category,
        locationName: locationName,
        estimatedCost: estimatedCost,
        durationMinutes: durationMinutes,
        startTime: startTime,
        imageAssetPath: imageAssetPath,
        imageStorageUrl: imageStorageUrl,
        position: position ?? this.position,
        scoreDistance: scoreDistance,
        scoreBudget: scoreBudget,
        scoreTimeFit: scoreTimeFit,
        proposedBy: proposedBy,
        createdBy: createdBy,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
