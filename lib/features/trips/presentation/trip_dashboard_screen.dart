import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/app_card.dart';
import 'package:tropicaguide/core/ui/empty_state.dart';
import 'package:tropicaguide/core/ui/error_state.dart';
import 'package:tropicaguide/core/ui/loading_state.dart';
import 'package:tropicaguide/core/utils/extensions.dart';
import 'package:tropicaguide/features/auth/presentation/auth_notifier.dart';
import 'package:tropicaguide/features/trips/domain/trip.dart';
import 'package:tropicaguide/features/trips/presentation/trips_notifier.dart';

/// The main trip dashboard screen.
class TripDashboardScreen extends ConsumerWidget {
  /// Creates a [TripDashboardScreen].
  const TripDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            tooltip: 'Discover activities',
            icon: const Icon(Icons.explore_outlined),
            onPressed: () => context.push(AppRoutes.discover),
          ),
          IconButton(
            tooltip: AppStrings.signOut,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () =>
                ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createTrip),
        icon: const Icon(Icons.add_rounded),
        label: const Text(AppStrings.createTrip),
      ),
      body: tripsAsync.when(
        loading: () => const LoadingState(),
        error: (e, __) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(tripsStreamProvider),
        ),
        data: (trips) => trips.isEmpty
            ? EmptyState(
                title: AppStrings.noTripsYet,
                subtitle: AppStrings.noTripsSubtitle,
                ctaLabel: AppStrings.createTrip,
                onCtaTap: () => context.push(AppRoutes.createTrip),
              )
            : _TripList(trips: trips),
      ),
    );
  }
}

class _TripList extends StatelessWidget {
  const _TripList({required this.trips});
  final List<Trip> trips;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: trips.length,
      separatorBuilder: (_, __) => const Gap(AppSpacing.md),
      itemBuilder: (_, i) => _TripCard(trip: trips[i]),
    );
  }
}

class _TripCard extends StatelessWidget {
  const _TripCard({required this.trip});
  final Trip trip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AppCard(
      semanticLabel: 'Trip: ${trip.title}',
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.lg),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.flight_takeoff_rounded,
                size: 48,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(trip.title, style: textTheme.titleLarge),
                const Gap(AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const Gap(AppSpacing.xs),
                    Text(
                      trip.destination,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                if (trip.startDate != null && trip.endDate != null) ...[
                  const Gap(AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const Gap(AppSpacing.xs),
                      Text(
                        trip.startDate!.toDateRange(trip.endDate!),
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
                const Gap(AppSpacing.sm),
                Row(
                  children: [
                    _StatusChip(status: trip.status),
                    const Spacer(),
                    // Checklist button
                    IconButton(
                      tooltip: 'Packing list',
                      icon: const Icon(Icons.checklist_rounded),
                      onPressed: () => context.push(
                        AppRoutes.checklist(trip.tripId),
                      ),
                    ),
                    // Itinerary button
                    IconButton(
                      tooltip: 'Itinerary',
                      icon: const Icon(Icons.map_outlined),
                      onPressed: () => context.push(
                        AppRoutes.itinerary(trip.tripId),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (status) {
      'active' => Colors.green,
      'completed' => colorScheme.outline,
      _ => colorScheme.primary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
