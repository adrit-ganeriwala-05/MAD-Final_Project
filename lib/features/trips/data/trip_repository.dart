// lib/features/trips/data/trip_repository.dart

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  static const _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Generates a random 6-character uppercase invite code.
  static String generateInviteCode() {
    final rng = Random.secure();
    return List.generate(
      6,
      (_) => _codeChars[rng.nextInt(_codeChars.length)],
    ).join();
  }

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

  /// Real-time stream of a single trip by [tripId].
  Stream<Trip?> tripStream(String tripId) =>
      _trips.doc(tripId).snapshots().map((doc) {
        if (!doc.exists) return null;
        return _toDomain(TripDto.fromFirestore(doc));
      });

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
    final code = generateInviteCode();
    await ref.set({
      'tripId': ref.id,
      'title': title.trim(),
      'destination': destination.trim(),
      'totalBudget': totalBudget,
      'currency': 'USD',
      'memberIds': <String>[userId],
      'memberProfiles': {
        userId: {'displayName': displayName, 'photoUrl': null},
      },
      'createdBy': userId,
      'inviteCode': code,
      'optimisedOrder': <String>[],
      'status': 'planning',
      'coverImagePath': null,
      'startDate': startDate != null ? Timestamp.fromDate(startDate) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate) : null,
      'createdAt': now,
      'updatedAt': now,
    });
    appLogger.i('TripRepository: created trip → ${ref.id} (code: $code)');
    return ref.id;
  }

  /// Finds a trip by its [inviteCode] and adds [userId] as a member.
  ///
  /// Returns the joined trip ID, or `null` if the code is invalid.
  Future<String?> joinTripByCode({
    required String inviteCode,
    required String userId,
    required String displayName,
  }) async {
    final snap = await _trips
        .where('inviteCode', isEqualTo: inviteCode.toUpperCase().trim())
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      appLogger.w('TripRepository: no trip found for code $inviteCode');
      return null;
    }

    final doc = snap.docs.first;
    final tripId = doc.id;
    final memberIds = List<String>.from(
      doc.data()['memberIds'] as List? ?? [],
    );

    if (memberIds.contains(userId)) {
      appLogger.i('TripRepository: $userId already in trip $tripId');
      return tripId;
    }

    await _trips.doc(tripId).update({
      'memberIds': FieldValue.arrayUnion([userId]),
      'memberProfiles.$userId': {
        'displayName': displayName,
        'photoUrl': null,
      },
      'updatedAt': FieldValue.serverTimestamp(),
    });

    appLogger.i('TripRepository: $userId joined trip $tripId');
    return tripId;
  }

  /// Uploads [imageFile] as the trip cover and writes the URL to Firestore.
  Future<String> uploadCoverImage({
    required String tripId,
    required File imageFile,
    required FirebaseStorage storage,
  }) async {
    final ref = storage.ref('trips/$tripId/cover.jpg');
    await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final url = await ref.getDownloadURL();
    await _trips.doc(tripId).update({
      'coverImagePath': url,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    appLogger.i('TripRepository: uploaded cover → $tripId');
    return url;
  }

  /// Converts a [TripDto] to a [Trip] domain model.
  Trip _toDomain(TripDto dto) => Trip(
        tripId: dto.tripId,
        title: dto.title,
        destination: dto.destination,
        coverImagePath: dto.coverImagePath,
        inviteCode: dto.inviteCode,
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
