import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/empty_state.dart';
import 'package:tropicaguide/features/auth/presentation/auth_notifier.dart';

/// The trip dashboard — the app's home screen after sign-in.
///
/// Phase 1: Empty state placeholder with sign-out.
/// Phase 5: Real-time list of trips from Firestore.
class TripDashboardScreen extends ConsumerWidget {
  /// Creates a [TripDashboardScreen].
  const TripDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            tooltip: AppStrings.signOut,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () =>
                ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
      body: EmptyState(
        title: AppStrings.noTripsYet,
        subtitle: AppStrings.noTripsSubtitle,
        ctaLabel: AppStrings.createTrip,
        onCtaTap: () {
          // Phase 5: context.push(AppRoutes.createTrip)
        },
      ),
    );
  }
}
