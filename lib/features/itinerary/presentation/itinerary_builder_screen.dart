import 'package:flutter/material.dart';
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

/// The drag-and-drop itinerary builder screen.
///
/// Shows a real-time ordered list of activities for a trip.
/// Users can reorder via drag-and-drop — positions are batch-written
/// to Firestore on drop. Explainable score chips appear when the
/// Cloud Function optimiser has run.
class ItineraryBuilderScreen extends ConsumerWidget {
  /// Creates an [ItineraryBuilderScreen].
  const ItineraryBuilderScreen({required this.tripId, super.key});

  /// The trip whose activities are displayed.
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(activitiesStreamProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Itinerary'),
        actions: [
          IconButton(
            tooltip: 'Add activity',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push(
              AppRoutes.addActivity(tripId),
            ),
          ),
        ],
      ),
      body: activitiesAsync.when(
        loading: () => const LoadingState(),
        error: (e, __) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(activitiesStreamProvider(tripId)),
        ),
        data: (activities) => activities.isEmpty
            ? EmptyState(
                title: 'No activities yet',
                subtitle: 'Tap + to add your first activity.',
                ctaLabel: 'Add Activity',
                onCtaTap: () => context.push(AppRoutes.addActivity(tripId)),
              )
            : _ActivityList(tripId: tripId, activities: activities),
      ),
    );
  }
}

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
    // Only sync from Firestore when not actively dragging
    _activities = List.of(widget.activities);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Score legend banner — shown only when scores are present
        if (_activities.any((a) => a.hasScores)) _ScoreLegendBanner(),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: _activities.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                final adjustedIndex =
                    newIndex > oldIndex ? newIndex - 1 : newIndex;
                final item = _activities.removeAt(oldIndex);
                _activities.insert(adjustedIndex, item);
              });
              ref
                  .read(itineraryNotifierProvider(widget.tripId).notifier)
                  .reorder(_activities);
            },
            itemBuilder: (context, index) {
              final activity = _activities[index];
              return Padding(
                key: ValueKey(activity.activityId),
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: ActivityCard(
                  activity: activity,
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

class _ScoreLegendBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      color: colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            size: 14,
            color: colorScheme.primary,
          ),
          const Gap(AppSpacing.sm),
          Text(
            'Optimiser scores: ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const _LegendDot(color: Color(0xFF43A047), label: '≥75'),
          const Gap(AppSpacing.sm),
          const _LegendDot(color: Color(0xFFFFB300), label: '50–74'),
          const Gap(AppSpacing.sm),
          const _LegendDot(color: Color(0xFFE53935), label: '<50'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const Gap(4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
