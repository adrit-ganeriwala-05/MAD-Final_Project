import 'package:flutter/material.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/empty_state.dart';

/// The trip dashboard — the app's home screen after sign-in.
///
/// **Phase 1 (current):** Empty state placeholder with a sign-out stub.
///
/// **Phase 5:** Real-time list of trips from Firestore.
class TripDashboardScreen extends StatelessWidget {
  /// Creates a [TripDashboardScreen].
  const TripDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          // Phase 1 sign-out stub — tests the reverse auth redirect
          IconButton(
            tooltip: AppStrings.signOut,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () => authStateNotifier.value = false,
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
