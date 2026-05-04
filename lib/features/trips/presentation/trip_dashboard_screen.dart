// lib/features/trips/presentation/trip_dashboard_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tropicaguide/core/config/app_config.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/theme/app_colors.dart';
import 'package:tropicaguide/core/ui/app_card.dart';
import 'package:tropicaguide/core/ui/empty_state.dart';
import 'package:tropicaguide/core/ui/error_state.dart';
import 'package:tropicaguide/core/ui/loading_state.dart';
import 'package:tropicaguide/core/utils/extensions.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/itinerary/domain/activity.dart';
import 'package:tropicaguide/features/itinerary/presentation/itinerary_notifier.dart';
import 'package:tropicaguide/features/profile/presentation/profile_notifier.dart';
import 'package:tropicaguide/features/trips/domain/trip.dart';
import 'package:tropicaguide/features/trips/presentation/trips_notifier.dart';

/// The main trip dashboard screen.
class TripDashboardScreen extends ConsumerWidget {
  /// Creates a [TripDashboardScreen].
  const TripDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userBootstrapProvider);

    final tripsAsync = ref.watch(tripsStreamProvider);
    final user = ref.watch(authStateChangesProvider).valueOrNull;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(switch (themeMode) {
              ThemeMode.light => Icons.light_mode_outlined,
              ThemeMode.dark => Icons.dark_mode_outlined,
              ThemeMode.system => Icons.brightness_auto_outlined,
            }),
            onPressed: () =>
                ref.read(themeModeProvider.notifier).toggle(),
          ),
          IconButton(
            tooltip: 'Discover activities',
            icon: const Icon(Icons.explore_outlined),
            onPressed: () => context.push(AppRoutes.discover),
          ),
          IconButton(
            tooltip: 'Join a trip',
            icon: const Icon(Icons.group_add_outlined),
            onPressed: () => context.push(AppRoutes.joinTrip),
          ),
          if (user != null)
            IconButton(
              tooltip: 'My Profile',
              icon: const Icon(Icons.person_outline_rounded),
              onPressed: () => context.push(AppRoutes.profile),
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
        error: (e, __) {
          if (e.toString().contains('permission-denied')) {
            Future.delayed(const Duration(seconds: 2), () {
              ref.invalidate(tripsStreamProvider);
            });
            return const LoadingState();
          }
          return ErrorState(
            message: e.toString(),
            onRetry: () => ref.invalidate(tripsStreamProvider),
          );
        },
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

class _TripCard extends ConsumerWidget {
  const _TripCard({required this.trip});
  final Trip trip;

  Future<void> _pickCoverImage(
    BuildContext context,
    WidgetRef ref,
    String tripId,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked == null) return;
    await ref
        .read(tripCoverNotifierProvider(tripId).notifier)
        .uploadCover(File(picked.path));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cover photo updated!')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete trip?'),
        content: Text(
          'Delete "${trip.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await ref.read(tripRepositoryProvider).deleteTrip(trip.tripId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${trip.title}" deleted.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final activitiesAsync = ref.watch(activitiesStreamProvider(trip.tripId));
    final activities = activitiesAsync.valueOrNull ?? <Activity>[];
    final totalSpent =
        activities.fold<int>(0, (sum, a) => sum + a.estimatedCost);

    return AppCard(
      semanticLabel: 'Trip: ${trip.title}',
      padding: EdgeInsets.zero,
      onTap: () => context.push(AppRoutes.itinerary(trip.tripId)),
      onLongPress: () => _confirmDelete(context, ref),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero cover image ───────────────────────────────────────────
          Hero(
            tag: 'trip-cover-${trip.tripId}',
            child: GestureDetector(
              onTap: () => _pickCoverImage(context, ref, trip.tripId),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.lg),
                  ),
                  image: trip.coverImagePath != null
                      ? DecorationImage(
                          image: NetworkImage(trip.coverImagePath!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: trip.coverImagePath == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 36,
                              color: colorScheme.onPrimaryContainer,
                            ),
                            const Gap(AppSpacing.xs),
                            Text(
                              'Add cover photo',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.title,
                  style: textTheme.headlineSmall,
                ),
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
                if (trip.totalBudget > 0) ...[
                  _BudgetBar(
                    totalSpent: totalSpent,
                    totalBudget: trip.totalBudget,
                  ),
                  const Gap(AppSpacing.sm),
                ],
                Row(
                  children: [
                    _StatusChip(status: trip.status),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Packing list',
                      icon: const Icon(Icons.checklist_rounded),
                      onPressed: () =>
                          context.push(AppRoutes.checklist(trip.tripId)),
                    ),
                    IconButton(
                      tooltip: 'Trip chat',
                      icon: const Icon(Icons.chat_bubble_outline_rounded),
                      onPressed: () =>
                          context.push(AppRoutes.chat(trip.tripId)),
                    ),
                    IconButton(
                      tooltip: 'Itinerary',
                      icon: const Icon(Icons.map_outlined),
                      onPressed: () =>
                          context.push(AppRoutes.itinerary(trip.tripId)),
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

// ── Budget bar ────────────────────────────────────────────────────────────────

class _BudgetBar extends StatelessWidget {
  const _BudgetBar({
    required this.totalSpent,
    required this.totalBudget,
  });

  final int totalSpent;
  final int totalBudget;

  @override
  Widget build(BuildContext context) {
    final ratio =
        totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;
    final color = ratio < 0.7
        ? AppColors.scoreHigh
        : ratio < 0.9
            ? AppColors.scoreMid
            : AppColors.scoreLow;
    final spentStr = '\$${(totalSpent / 100).toStringAsFixed(0)}';
    final budgetStr = '\$${(totalBudget / 100).toStringAsFixed(0)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: ratio,
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          minHeight: 6,
        ),
        const Gap(AppSpacing.xs),
        Text(
          '$spentStr spent of $budgetStr',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

// ── Status chip ───────────────────────────────────────────────────────────────

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