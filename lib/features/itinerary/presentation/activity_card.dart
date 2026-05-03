import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/theme/app_colors.dart';
import 'package:tropicaguide/core/ui/app_card.dart';
import 'package:tropicaguide/features/itinerary/domain/activity.dart';

/// Card displayed in the itinerary builder for a single activity.
///
/// Shows the activity title, location, duration, cost, and — when available —
/// explainable score chips (distance / budget / time-fit) written by the
/// Cloud Function optimiser.
class ActivityCard extends StatelessWidget {
  /// Creates an [ActivityCard].
  const ActivityCard({
    required this.activity,
    required this.onDelete,
    super.key,
    this.isDragging = false,
  });

  /// The activity to display.
  final Activity activity;

  /// Called when the user confirms deletion.
  final VoidCallback onDelete;

  /// When `true`, the card renders in a slightly elevated dragging state.
  final bool isDragging;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        boxShadow: isDragging
            ? [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Drag handle ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(
                right: AppSpacing.md,
                top: AppSpacing.xs,
              ),
              child: Icon(
                Icons.drag_handle_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            // ── Content ───────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  _CategoryChip(category: activity.category),
                  const Gap(AppSpacing.xs),
                  Text(
                    activity.title,
                    style: textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                      Expanded(
                        child: Text(
                          activity.locationName,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpacing.sm),
                  // Meta row: duration + cost
                  Row(
                    children: [
                      _MetaChip(
                        icon: Icons.schedule_outlined,
                        label: activity.formattedDuration,
                      ),
                      const Gap(AppSpacing.sm),
                      _MetaChip(
                        icon: Icons.attach_money_rounded,
                        label: activity.formattedCost,
                      ),
                    ],
                  ),
                  // Score chips — only shown when optimiser has run
                  if (activity.hasScores) ...[
                    const Gap(AppSpacing.sm),
                    _ScoreRow(activity: activity),
                  ],
                ],
              ),
            ),
            // ── Delete ────────────────────────────────────────────────────
            IconButton(
              tooltip: 'Remove activity',
              icon: Icon(
                Icons.delete_outline_rounded,
                color: colorScheme.error,
              ),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove activity?'),
        content: Text('Remove "${activity.title}" from the itinerary?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed ?? false) onDelete();
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(
        category.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const Gap(2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

/// Explainable score row — the proposal's key evidence requirement.
///
/// Shows distance, budget, and time-fit scores as colour-coded chips.
/// Green ≥ 75, Amber 50–74, Red < 50.
class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: [
        if (activity.scoreDistance != null)
          _ScoreChip(label: 'Distance', score: activity.scoreDistance!),
        if (activity.scoreBudget != null)
          _ScoreChip(label: 'Budget', score: activity.scoreBudget!),
        if (activity.scoreTimeFit != null)
          _ScoreChip(label: 'Time fit', score: activity.scoreTimeFit!),
      ],
    );
  }
}

class _ScoreChip extends StatelessWidget {
  const _ScoreChip({required this.label, required this.score});
  final String label;
  final int score;

  Color _color() {
    if (score >= 75) return AppColors.scoreHigh;
    if (score >= 50) return AppColors.scoreMid;
    return AppColors.scoreLow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _color().withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
        border: Border.all(color: _color().withValues(alpha: 0.4)),
      ),
      child: Text(
        '$label: $score',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _color(),
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
