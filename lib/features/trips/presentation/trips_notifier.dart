// lib/features/trips/presentation/trips_notifier.dart

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/core/firebase/firebase_providers.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/trips/data/trip_repository.dart';
import 'package:tropicaguide/features/trips/domain/trip.dart';

part 'trips_notifier.g.dart';

/// Provides the [TripRepository] singleton.
@riverpod
TripRepository tripRepository(Ref ref) =>
    TripRepository(ref.watch(firestoreProvider));

/// Real-time stream of the current user's trips.
@riverpod
Stream<List<Trip>> tripsStream(Ref ref) {
  final user = ref.watch(authStateChangesProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref.watch(tripRepositoryProvider).tripsStream(user.uid);
}

/// Real-time stream of a single trip by [tripId].
@riverpod
Stream<Trip?> tripStream(Ref ref, String tripId) =>
    ref.watch(tripRepositoryProvider).tripStream(tripId);

/// Notifier for create-trip form state.
@riverpod
class CreateTripNotifier extends _$CreateTripNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Creates a trip and returns its ID on success.
  Future<String?> createTrip({
    required String title,
    required String destination,
    int totalBudget = 0,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = const AsyncLoading();
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) {
      state = AsyncError('Not signed in', StackTrace.current);
      return null;
    }
    try {
      final id = await ref.read(tripRepositoryProvider).createTrip(
            title: title,
            destination: destination,
            userId: user.uid,
            displayName: user.displayName ?? user.email,
            totalBudget: totalBudget,
            startDate: startDate,
            endDate: endDate,
          );
      state = const AsyncData(null);
      // Subscribe to FCM topic in background — don't block navigation
      ref.read(fcmServiceProvider).subscribeToTrip(id).ignore();
      return id;
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

/// Notifier for the join-trip-by-invite-code flow.
@riverpod
class JoinTripNotifier extends _$JoinTripNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Looks up the invite [code] and joins the trip.
  ///
  /// Returns the joined trip's ID on success, or `null` on failure.
  Future<String?> joinByCode(String code) async {
    state = const AsyncLoading();
    final user = ref.read(authStateChangesProvider).valueOrNull;
    if (user == null) {
      state = AsyncError('Not signed in', StackTrace.current);
      return null;
    }
    try {
      final tripId = await ref.read(tripRepositoryProvider).joinTripByCode(
            inviteCode: code,
            userId: user.uid,
            displayName: user.displayName ?? user.email,
          );
      if (tripId == null) {
        state = AsyncError(
          Exception('Invalid invite code. Please check and try again.'),
          StackTrace.current,
        );
        return null;
      }
      state = const AsyncData(null);
      // Subscribe to FCM topic in background — don't block navigation
      ref.read(fcmServiceProvider).subscribeToTrip(tripId).ignore();
      return tripId;
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

/// Notifier for uploading a trip cover image.
@riverpod
class TripCoverNotifier extends _$TripCoverNotifier {
  @override
  AsyncValue<void> build(String tripId) => const AsyncData(null);

  /// Uploads [imageFile] as the trip cover photo.
  Future<void> uploadCover(File imageFile) async {
    state = const AsyncLoading();
    try {
      await ref.read(tripRepositoryProvider).uploadCoverImage(
            tripId: tripId,
            imageFile: imageFile,
            storage: ref.read(firebaseStorageProvider),
          );
      state = const AsyncData(null);
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
