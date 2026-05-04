// lib/features/profile/presentation/profile_notifier.dart

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/core/firebase/firebase_providers.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/profile/data/user_repository.dart';
import 'package:tropicaguide/features/profile/domain/user_profile.dart';

part 'profile_notifier.g.dart';

/// Provides the [UserRepository] singleton.
@riverpod
UserRepository userRepository(Ref ref) => UserRepository(
      ref.watch(firestoreProvider),
      ref.watch(firebaseStorageProvider),
    );

/// Real-time stream of the user's Firestore profile.
@riverpod
Stream<UserProfile?> userProfile(Ref ref, String uid) =>
    ref.watch(userRepositoryProvider).userStream(uid);

/// Bootstraps the user profile document on first sign-in.
@riverpod
Future<void> userBootstrap(Ref ref) async {
  final user = await ref.watch(authStateChangesProvider.future);
  if (user == null) return;
  await ref.read(userRepositoryProvider).bootstrapUser(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName ?? user.email,
      );
}

/// Notifier for profile edit operations.
@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Saves updated profile fields to Firestore.
  Future<void> updateProfile({
    required String uid,
    required String displayName,
    required int defaultDailyBudget,
    required String pace,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(userRepositoryProvider).updateProfile(
            uid: uid,
            displayName: displayName,
            defaultDailyBudget: defaultDailyBudget,
            pace: pace,
          );
      state = const AsyncData(null);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  /// Uploads a profile photo and updates Firestore.
  Future<void> uploadPhoto({
    required String uid,
    required File imageFile,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(userRepositoryProvider).uploadProfilePhoto(
            uid: uid,
            imageFile: imageFile,
          );
      state = const AsyncData(null);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
