// lib/core/firebase/firebase_providers.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tropicaguide/core/services/fcm_service.dart';

/// Provides the [FirebaseAuth] singleton.
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

/// Provides the [FirebaseFirestore] singleton.
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

/// Provides the [FirebaseStorage] singleton.
final firebaseStorageProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
);

/// Provides the [FirebaseFunctions] instance scoped to us-central1.
final firebaseFunctionsProvider = Provider<FirebaseFunctions>(
  (ref) => FirebaseFunctions.instanceFor(region: 'us-central1'),
);

/// Provides the [FirebaseMessaging] singleton.
final firebaseMessagingProvider = Provider<FirebaseMessaging>(
  (ref) => FirebaseMessaging.instance,
);

/// Provides the [FcmService] singleton.
final fcmServiceProvider = Provider<FcmService>(
  (ref) => FcmService(ref.watch(firebaseMessagingProvider)),
);
