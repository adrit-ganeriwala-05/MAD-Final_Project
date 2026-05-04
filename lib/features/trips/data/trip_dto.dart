import 'package:cloud_firestore/cloud_firestore.dart';

//// Firestore DTO for a trip document.
///
/// Handles serialization to/from Firestore maps.
/// Domain model Trip is derived from this in the repository.
class TripDto {
  /// Creates a [TripDto].
  const TripDto({
    required this.tripId,
    required this.title,
    required this.destination,
    required this.memberIds,
    required this.createdBy,
    required this.status,
    required this.totalBudget,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    this.coverImagePath,
    this.inviteCode,
    this.startDate,
    this.endDate,
    this.memberProfiles = const {},
    this.optimisedOrder = const [],
  });

  /// Creates a [TripDto] from a Firestore document snapshot.
  factory TripDto.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TripDto(
      tripId: doc.id,
      title: data['title'] as String? ?? '',
      destination: data['destination'] as String? ?? '',
      coverImagePath: data['coverImagePath'] as String?,
      inviteCode: data['inviteCode'] as String?,
      startDate: data['startDate'] as Timestamp?,
      endDate: data['endDate'] as Timestamp?,
      totalBudget: (data['totalBudget'] as num?)?.toInt() ?? 0,
      currency: data['currency'] as String? ?? 'USD',
      memberIds: List<String>.from(data['memberIds'] as List? ?? []),
      memberProfiles: Map<String, dynamic>.from(
        data['memberProfiles'] as Map? ?? {},
      ),
      createdBy: data['createdBy'] as String? ?? '',
      optimisedOrder: List<String>.from(
        data['optimisedOrder'] as List? ?? [],
      ),
      status: data['status'] as String? ?? 'planning',
      createdAt: data['createdAt'] as Timestamp? ?? Timestamp.now(),
      updatedAt: data['updatedAt'] as Timestamp? ?? Timestamp.now(),
    );
  }

  /// Converts this DTO to a Firestore-compatible map.
  Map<String, dynamic> toFirestore() => {
        'tripId': tripId,
        'title': title,
        'destination': destination,
        'coverImagePath': coverImagePath,
        'inviteCode': inviteCode,
        'startDate': startDate,
        'endDate': endDate,
        'totalBudget': totalBudget,
        'currency': currency,
        'memberIds': memberIds,
        'memberProfiles': memberProfiles,
        'createdBy': createdBy,
        'optimisedOrder': optimisedOrder,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  /// Firestore document ID.
  final String tripId;

  /// Trip title.
  final String title;

  /// Destination free-text.
  final String destination;

  /// Optional cover image asset path.
  final String? coverImagePath;

  /// 6-character uppercase invite code.
  final String? inviteCode;

  /// Trip start date.
  final Timestamp? startDate;

  /// Trip end date.
  final Timestamp? endDate;

  /// Total budget in cents.
  final int totalBudget;

  /// ISO 4217 currency code.
  final String currency;

  /// UIDs of all trip members.
  final List<String> memberIds;

  /// Denormalized member display info for list rendering.
  final Map<String, dynamic> memberProfiles;

  /// UID of the trip creator.
  final String createdBy;

  /// Ordered activity IDs written by the Cloud Function optimiser.
  final List<String> optimisedOrder;

  /// Trip status: planning | active | completed.
  final String status;

  /// Server timestamp.
  final Timestamp createdAt;

  /// Server timestamp.
  final Timestamp updatedAt;
}
