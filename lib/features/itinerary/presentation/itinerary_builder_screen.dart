// lib/features/itinerary/presentation/itinerary_builder_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/empty_state.dart';
import 'package:tropicaguide/core/ui/error_state.dart';
import 'package:tropicaguide/core/ui/loading_state.dart';
import 'package:tropicaguide/features/itinerary/domain/activity.dart';
import 'package:tropicaguide/features/itinerary/presentation/activity_card.dart';
import 'package:tropicaguide/features/itinerary/presentation/itinerary_notifier.dart';
import 'package:tropicaguide/features/trips/presentation/trips_notifier.dart';

/// The drag-and-drop itinerary builder screen.
///
/// Features a Hero SliverAppBar cover image, real-time activity list,
/// drag-and-drop reorder, invite code sharing, and trip chat navigation.
class ItineraryBuilderScreen extends ConsumerWidget {
  /// Creates an [ItineraryBuilderScreen].
  const ItineraryBuilderScreen({required this.tripId, super.key});

  /// The trip whose activities are displayed.
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesStreamProvider(tripId));
    final tripAsync = ref.watch(tripStreamProvider(tripId));
    final trip = tripAsync.valueOrNull;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            forceElevated: innerBoxIsScrolled,
            title: Text(trip?.title ?? 'Itinerary'),
            actions: [
              // ── Invite code share ────────────────────────────────────
              IconButton(
                tooltip: 'Share invite code',
                icon: const Icon(Icons.share_outlined),
                onPressed: trip == null
                    ? null
                    : () => _showInviteCodeSheet(context, trip.inviteCode),
              ),
              // ── Chat ──────────────────────────────────────────────────
              IconButton(
                tooltip: 'Trip chat',
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                onPressed: () => context.push(AppRoutes.chat(tripId)),
              ),
              // ── Add activity ──────────────────────────────────────────
              IconButton(
                tooltip: 'Add activity',
                icon: const Icon(Icons.add_rounded),
                onPressed: () => context.push(AppRoutes.addActivity(tripId)),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'trip-cover-$tripId',
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.flight_takeoff_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: activitiesAsync.when(
          loading: () => const LoadingState(),
          error: (e, __) {
            if (e.toString().contains('permission-denied')) {
              // Show loader and auto-retry — auth token race condition on first load
              Future.delayed(const Duration(seconds: 2), () {
                ref.invalidate(activitiesStreamProvider(tripId));
              });
              return const LoadingState();
            }
            return ErrorState(
              message: e.toString(),
              onRetry: () =>
                  ref.invalidate(activitiesStreamProvider(tripId)),
            );
          },
          data: (activities) => activities.isEmpty
              ? EmptyState(
                  title: 'No activities yet',
                  subtitle: 'Tap + to add your first activity.',
                  ctaLabel: 'Add Activity',
                  onCtaTap: () =>
                      context.push(AppRoutes.addActivity(tripId)),
                )
              : _ActivityList(tripId: tripId, activities: activities),
        ),
      ),
    );
  }

  void _showInviteCodeSheet(BuildContext context, String? code) {
    if (code == null) return;
    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Invite Code',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const Gap(AppSpacing.lg),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.lg,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Text(
                  code,
                  style: Theme.of(ctx).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 8,
                        color: Theme.of(ctx).colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
              const Gap(AppSpacing.lg),
              Text(
                'Share this code with friends so they can join your trip.',
                style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.lg),
              FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invite code copied!'),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Copy Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Activity list with drag-and-drop ─────────────────────────────────────────

class _ActivityList extends ConsumerStatefulWidget {
  const _ActivityList({
    required this.tripId,
    required this.activities,
  });

  final String tripId;
  final List<Activity> activities;

  @override
  ConsumerState<_ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends ConsumerState<_ActivityList> {
  late List<Activity> _activities;

  @override
  void initState() {
    super.initState();
    _activities = List.of(widget.activities);
  }

  @override
  void didUpdateWidget(_ActivityList old) {
    super.didUpdateWidget(old);
    _activities = List.of(widget.activities);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: _activities.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final adjusted =
                    newIndex > oldIndex ? newIndex - 1 : newIndex;
                final item = _activities.removeAt(oldIndex);
                _activities.insert(adjusted, item);
              });
              ref
                  .read(
                    itineraryNotifierProvider(widget.tripId).notifier,
                  )
                  .reorder(_activities);
            },
            itemBuilder: (context, index) {
              final activity = _activities[index];
              return Padding(
                key: ValueKey(activity.activityId),
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ActivityCard(
                  activity: activity,
                  tripId: widget.tripId,
                  onDelete: () => ref
                      .read(
                        itineraryNotifierProvider(widget.tripId).notifier,
                      )
                      .deleteActivity(activity.activityId),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}