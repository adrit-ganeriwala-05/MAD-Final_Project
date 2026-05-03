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
      return id;
    } on Exception catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
