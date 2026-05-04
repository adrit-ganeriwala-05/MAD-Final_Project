// lib/features/profile/data/user_repository.dart

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/features/profile/domain/user_profile.dart';

/// Handles all Firestore reads and writes for user profiles.
class UserRepository {
  /// Creates a [UserRepository].
  const UserRepository(this._firestore, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  DocumentReference<Map<String, dynamic>> _userRef(String uid) =>
      _firestore.collection('users').doc(uid);

  /// Real-time stream of the user's profile document.
  Stream<UserProfile?> userStream(String uid) =>
      _userRef(uid).snapshots().map((doc) {
        if (!doc.exists) return null;
        return _toDomain(doc);
      });

  /// Creates the users/{uid} document if it does not already exist.
  Future<void> bootstrapUser({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    final doc = await _userRef(uid).get();
    if (doc.exists) return;
    final now = FieldValue.serverTimestamp();
    await _userRef(uid).set({
      'uid': uid,
      'email': email,
      'displayName': displayName.isNotEmpty ? displayName : email,
      'photoUrl': null,
      'budgetCurrency': 'USD',
      'defaultDailyBudget': 20000,
      'travelPreferences': {'pace': 'moderate', 'interests': <String>[]},
      'createdAt': now,
      'updatedAt': now,
    });
    appLogger.i('UserRepository: bootstrapped profile → $uid');
  }

  /// Writes updated profile fields to Firestore.
  Future<void> updateProfile({
    required String uid,
    required String displayName,
    required int defaultDailyBudget,
    required String pace,
  }) async {
    await _userRef(uid).update({
      'displayName': displayName.trim(),
      'defaultDailyBudget': defaultDailyBudget,
      'travelPreferences.pace': pace,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    appLogger.i('UserRepository: updated profile → $uid');
  }

  /// Uploads [imageFile] to Firebase Storage and writes the URL to Firestore.
  ///
  /// Returns the download URL on success.
  Future<String> uploadProfilePhoto({
    required String uid,
    required File imageFile,
  }) async {
    final ref = _storage.ref('avatars/$uid/profile.jpg');
    await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final url = await ref.getDownloadURL();
    await _userRef(uid).update({
      'photoUrl': url,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    appLogger.i('UserRepository: uploaded profile photo → $uid');
    return url;
  }

  UserProfile _toDomain(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserProfile(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      defaultDailyBudget:
          (data['defaultDailyBudget'] as num?)?.toInt() ?? 20000,
      travelPreferences: Map<String, dynamic>.from(
        data['travelPreferences'] as Map? ??
            {'pace': 'moderate', 'interests': <String>[]},
      ),
    );
  }
}
