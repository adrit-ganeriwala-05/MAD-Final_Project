import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/theme/app_colors.dart';
import 'package:tropicaguide/core/ui/app_card.dart';

/// A static seed activity model for the discovery screen.
class _SeedActivity {
  const _SeedActivity({
    required this.title,
    required this.category,
    required this.location,
    required this.estimatedCost,
    required this.durationMinutes,
    required this.description,
  });

  final String title;
  final String category;
  final String location;
  final int estimatedCost;
  final int durationMinutes;
  final String description;

  String get formattedCost => '\$${(estimatedCost / 100).toStringAsFixed(0)}';
  String get formattedDuration {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }
}

/// Curated seed activities for the discovery screen.
const _seedActivities = [
  _SeedActivity(
    title: 'Snorkelling at Isla Mujeres',
    category: 'adventure',
    location: 'Cancún, Mexico',
    estimatedCost: 8000,
    durationMinutes: 240,
    description: 'Crystal clear waters with stunning coral reefs.',
  ),
  _SeedActivity(
    title: 'Street Tacos Tour',
    category: 'food',
    location: 'Cancún, Mexico',
    estimatedCost: 2000,
    durationMinutes: 90,
    description: 'Local taco crawl through downtown Cancún.',
  ),
  _SeedActivity(
    title: 'Chichen Itza Day Trip',
    category: 'sightseeing',
    location: 'Yucatán, Mexico',
    estimatedCost: 12000,
    durationMinutes: 480,
    description: 'UNESCO world heritage site with guided tour.',
  ),
  _SeedActivity(
    title: 'Ubud Rice Terraces Walk',
    category: 'adventure',
    location: 'Bali, Indonesia',
    estimatedCost: 3000,
    durationMinutes: 180,
    description: 'Scenic walk through iconic Tegallalang rice terraces.',
  ),
  _SeedActivity(
    title: 'Balinese Cooking Class',
    category: 'food',
    location: 'Bali, Indonesia',
    estimatedCost: 5000,
    durationMinutes: 240,
    description: 'Learn to cook traditional Balinese dishes.',
  ),
  _SeedActivity(
    title: 'Tanah Lot Temple Visit',
    category: 'sightseeing',
    location: 'Bali, Indonesia',
    estimatedCost: 2500,
    durationMinutes: 120,
    description: 'Iconic sea temple perched on a rocky outcrop.',
  ),
  _SeedActivity(
    title: 'Sunset Sailing Cruise',
    category: 'rest',
    location: 'Bali, Indonesia',
    estimatedCost: 9000,
    durationMinutes: 180,
    description: 'Relaxing sunset cruise along the Bali coastline.',
  ),
  _SeedActivity(
    title: 'Airport Transfer',
    category: 'transport',
    location: 'Cancún, Mexico',
    estimatedCost: 2500,
    durationMinutes: 45,
    description: 'Private transfer from CUN airport to hotel zone.',
  ),
];

/// Activity discovery screen.
///
/// Displays a searchable, filterable grid of curated seed activities.
/// Users can browse activities to add to their itineraries.
class ActivityDiscoveryScreen extends ConsumerStatefulWidget {
  /// Creates an [ActivityDiscoveryScreen].
  const ActivityDiscoveryScreen({super.key});

  @override
  ConsumerState<ActivityDiscoveryScreen> createState() =>
      _ActivityDiscoveryScreenState();
}

class _ActivityDiscoveryScreenState
    extends ConsumerState<ActivityDiscoveryScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'all';

  static const _categories = [
    'all',
    'adventure',
    'food',
    'sightseeing',
    'rest',
    'transport',
  ];

  List<_SeedActivity> get _filtered => _seedActivities.where((a) {
        final matchesSearch = _searchQuery.isEmpty ||
            a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            a.location.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory =
            _selectedCategory == 'all' || a.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover Activities')),
      body: Column(
        children: [
          // ── Search bar ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: SearchBar(
              hintText: 'Search activities...',
              leading: const Icon(Icons.search_rounded),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          const Gap(AppSpacing.md),
          // ── Category filter chips ─────────────────────────────────────────
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const Gap(AppSpacing.sm),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return FilterChip(
                  label: Text(cat[0].toUpperCase() + cat.substring(1)),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = cat),
                );
              },
            ),
          ),
          const Gap(AppSpacing.md),
          // ── Activity grid ────────────────────────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const Center(child: Text('No activities found.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const Gap(AppSpacing.md),
                    itemBuilder: (_, i) =>
                        _ActivityDiscoveryCard(activity: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _ActivityDiscoveryCard extends StatelessWidget {
  const _ActivityDiscoveryCard({required this.activity});
  final _SeedActivity activity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category + duration row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Text(
                  activity.category.toUpperCase(),
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSecondaryContainer,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.schedule_outlined,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const Gap(AppSpacing.xs),
              Text(
                activity.formattedDuration,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Gap(AppSpacing.sm),
          Text(activity.title, style: textTheme.titleMedium),
          const Gap(AppSpacing.xs),
          Text(
            activity.description,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(AppSpacing.sm),
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
                  activity.location,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.scoreHigh.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                ),
                child: Text(
                  activity.formattedCost,
                  style: textTheme.labelMedium?.copyWith(
                    color: AppColors.scoreHigh,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
