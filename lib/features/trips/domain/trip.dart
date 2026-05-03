/// Domain model for a trip.
///
/// Derived from TripDto in the repository layer.
/// Uses plain Dart types — no Firebase SDK types leak into domain.
class Trip {
  /// Creates a Trip.
  const Trip({
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
    this.startDate,
    this.endDate,
    this.memberProfiles = const {},
    this.optimisedOrder = const [],
  });

  /// Firestore document ID.
  final String tripId;

  /// Trip title.
  final String title;

  /// Destination free-text.
  final String destination;

  /// Optional cover image asset path.
  final String? coverImagePath;

  /// Trip start date.
  final DateTime? startDate;

  /// Trip end date.
  final DateTime? endDate;

  /// Total budget in cents.
  final int totalBudget;

  /// ISO 4217 currency code.
  final String currency;

  /// UIDs of all trip members.
  final List<String> memberIds;

  /// Denormalized member display info.
  final Map<String, dynamic> memberProfiles;

  /// UID of the trip creator.
  final String createdBy;

  /// Ordered activity IDs from the optimiser.
  final List<String> optimisedOrder;

  /// Trip status.
  final String status;

  /// Creation timestamp.
  final DateTime createdAt;

  /// Last updated timestamp.
  final DateTime updatedAt;

  /// Formatted budget string (dollars).
  String get formattedBudget => '\$${(totalBudget / 100).toStringAsFixed(0)}';
}
