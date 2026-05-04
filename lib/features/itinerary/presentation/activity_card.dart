// lib/features/itinerary/presentation/activity_card.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/app_card.dart';
import 'package:tropicaguide/features/itinerary/domain/activity.dart';
import 'package:tropicaguide/features/itinerary/presentation/itinerary_notifier.dart';
import 'package:tropicaguide/features/trips/presentation/trips_notifier.dart';

/// Card displayed in the itinerary builder for a single activity.
///
/// Shows a tappable cover image, category, title, location, duration,
/// cost, and trip member avatars.
class ActivityCard extends ConsumerWidget {
  /// Creates an [ActivityCard].
  const ActivityCard({
    required this.activity,
    required this.onDelete,
    required this.tripId,
    super.key,
    this.isDragging = false,
  });

  /// The activity to display.
  final Activity activity;

  /// The trip this activity belongs to.
  final String tripId;

  /// Called when the user confirms deletion.
  final VoidCallback onDelete;

  /// When `true`, the card renders in a slightly elevated dragging state.
  final bool isDragging;

  Future<void> _pickImage(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1024,
    );
    if (picked == null) return;
    await ref
        .read(itineraryNotifierProvider(tripId).notifier)
        .uploadActivityImage(
          activityId: activity.activityId,
          imageFile: File(picked.path),
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Activity photo updated!')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Tappable cover image ───────────────────────────────────
            GestureDetector(
              onTap: () => _pickImage(context, ref),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.lg),
                ),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    image: activity.imageStorageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(activity.imageStorageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: activity.imageStorageUrl == null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _categoryIcon(activity.category),
                                size: 32,
                                color: colorScheme.onSecondaryContainer
                                    .withValues(alpha: 0.6),
                              ),
                              const Gap(AppSpacing.xs),
                              Text(
                                'Tap to add photo',
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSecondaryContainer
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Container(
                              padding: const EdgeInsets.all(AppSpacing.xs),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.xs),
                              ),
                              child: const Icon(
                                Icons.edit_outlined,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),

            // ── Content ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const Gap(AppSpacing.sm),
                        // ── Member avatars ─────────────────────────────
                        _MemberAvatarStack(tripId: tripId),
                      ],
                    ),
                  ),
                  // Delete button
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
          ],
        ),
      ),
    );
  }

  IconData _categoryIcon(String category) => switch (category) {
        'food' => Icons.restaurant_outlined,
        'adventure' => Icons.hiking_outlined,
        'sightseeing' => Icons.photo_camera_outlined,
        'rest' => Icons.hotel_outlined,
        'transport' => Icons.directions_car_outlined,
        _ => Icons.place_outlined,
      };

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

/// Shows circular avatars for all members of the trip.
class _MemberAvatarStack extends ConsumerWidget {
  const _MemberAvatarStack({required this.tripId});
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trip = ref.watch(tripStreamProvider(tripId)).valueOrNull;
    if (trip == null) return const SizedBox.shrink();

    final profiles = trip.memberProfiles;
    if (profiles.isEmpty) return const SizedBox.shrink();

    final members = profiles.entries.toList();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(
          height: 24,
          width: (members.length * 18 + 6).toDouble(),
          child: Stack(
            children: List.generate(members.length, (i) {
              final profile =
                  members[i].value as Map<String, dynamic>? ?? {};
              final displayName =
                  profile['displayName'] as String? ?? '?';
              final photoUrl = profile['photoUrl'] as String?;
              final initials = displayName.isNotEmpty
                  ? displayName[0].toUpperCase()
                  : '?';

              return Positioned(
                left: i * 18.0,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl)
                      : null,
                  child: photoUrl == null
                      ? Text(
                          initials,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
        ),
        const Gap(AppSpacing.sm),
        Text(
          members.length == 1
              ? '1 member'
              : '${members.length} members',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
