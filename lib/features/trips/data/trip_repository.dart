import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/features/trips/data/trip_dto.dart';
import 'package:tropicaguide/features/trips/domain/trip.dart';

/// Handles all Firestore reads and writes for trips.
class TripRepository {
  /// Creates a [TripRepository].
  const TripRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _trips =>
      _firestore.collection('trips');

  /// Real-time stream of all trips where [userId] is a member.
  Stream<List<Trip>> tripsStream(String userId) => _trips
      .where('memberIds', arrayContains: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map(
        (snap) => snap.docs
            .map((doc) => _toDomain(TripDto.fromFirestore(doc)))
            .toList(),
      );

  /// Creates a new trip and returns its document ID.
  Future<String> createTrip({
    required String title,
    required String destination,
    required String userId,
    required String displayName,
    int totalBudget = 0,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final ref = _trips.doc();
    final now = FieldValue.serverTimestamp();
    await ref.set({
      'tripId': ref.id,
      'title': title.trim(),
      'destination': destination.trim(),
      'totalBudget': totalBudget,
      'currency': 'USD',
      'memberIds': [userId],
      'memberProfiles': {
        userId: {'displayName': displayName, 'photoUrl': null},
      },
      'createdBy': userId,
      'optimisedOrder': <String>[],
      'status': 'planning',
      'coverImagePath': null,
      'startDate': startDate != null ? Timestamp.fromDate(startDate) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
      'createdAt': now,
      'updatedAt': now,
    });
    appLogger.i('TripRepository: created trip → ${ref.id}');
    return ref.id;
  }

  /// Converts a [TripDto] to a [Trip] domain model.
  Trip _toDomain(TripDto dto) => Trip(
        tripId: dto.tripId,
        title: dto.title,
        destination: dto.destination,
        coverImagePath: dto.coverImagePath,
        startDate: dto.startDate?.toDate(),
        endDate: dto.endDate?.toDate(),
        totalBudget: dto.totalBudget,
        currency: dto.currency,
        memberIds: dto.memberIds,
        memberProfiles: dto.memberProfiles,
        createdBy: dto.createdBy,
        optimisedOrder: dto.optimisedOrder,
        status: dto.status,
        createdAt: dto.createdAt.toDate(),
        updatedAt: dto.updatedAt.toDate(),
      );
}
