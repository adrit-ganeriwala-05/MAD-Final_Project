// lib/features/discovery/presentation/activity_discovery_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/theme/app_colors.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/core/ui/app_card.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/discovery/data/ai_suggestions_repository.dart';
import 'package:tropicaguide/features/itinerary/presentation/itinerary_notifier.dart';
import 'package:tropicaguide/features/trips/presentation/trips_notifier.dart';

/// Activity discovery screen — AI-powered suggestions only.
class ActivityDiscoveryScreen extends ConsumerStatefulWidget {
  /// Creates an [ActivityDiscoveryScreen].
  const ActivityDiscoveryScreen({super.key});

  @override
  ConsumerState<ActivityDiscoveryScreen> createState() =>
      _ActivityDiscoveryScreenState();
}

class _ActivityDiscoveryScreenState
    extends ConsumerState<ActivityDiscoveryScreen> {
  final _destinationController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';
  List<SuggestedActivity>? _aiSuggestions;
  bool _aiLoading = false;
  String? _aiError;

  static const _categories = [
    'all',
    'adventure',
    'food',
    'sightseeing',
    'rest',
    'transport',
  ];

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  List<SuggestedActivity> get _filteredAi =>
      (_aiSuggestions ?? []).where((a) {
        final matchesSearch = _searchQuery.isEmpty ||
            a.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            a.locationName.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory =
            _selectedCategory == 'all' || a.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();

  Future<void> _fetchAiSuggestions() async {
    final destination = _destinationController.text.trim();
    if (destination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a destination first.')),
      );
      return;
    }
    setState(() {
      _aiLoading = true;
      _aiError = null;
      _aiSuggestions = null;
    });
    try {
      final results =
          await const AiSuggestionsRepository().fetchSuggestions(destination);
      setState(() {
        _aiSuggestions = results;
        _aiLoading = false;
      });
    } on Exception catch (e) {
      setState(() {
        _aiError = e.toString();
        _aiLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discover Activities')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      labelText: 'Destination',
                      hintText: 'e.g. Tokyo, Japan',
                      prefixIcon: Icon(Icons.travel_explore_rounded),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _fetchAiSuggestions(),
                  ),
                ),
                const Gap(AppSpacing.sm),
                FilledButton.tonal(
                  onPressed: _aiLoading ? null : _fetchAiSuggestions,
                  child: _aiLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Get AI\nSuggestions',
                          textAlign: TextAlign.center,
                        ),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.md),
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
                  onSelected: (_) => setState(() => _selectedCategory = cat),
                );
              },
            ),
          ),
          const Gap(AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SearchBar(
              hintText: 'Search activities…',
              leading: const Icon(Icons.search_rounded),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          const Gap(AppSpacing.md),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_aiLoading) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _SectionHeader(
            title: 'Finding activities in "${_destinationController.text}"…',
          ),
          const Gap(AppSpacing.sm),
          ..._skeletonCards(),
        ],
      );
    }

    if (_aiError != null) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const _SectionHeader(title: 'AI Suggestions'),
          const Gap(AppSpacing.sm),
          _AiErrorCard(error: _aiError!, onRetry: _fetchAiSuggestions),
        ],
      );
    }

    if (_aiSuggestions != null) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _SectionHeader(
            title: 'Activities in "${_destinationController.text}"',
          ),
          const Gap(AppSpacing.sm),
          if (_filteredAi.isEmpty)
            const Center(child: Text('No matching activities.'))
          else
            ...List.generate(
              _filteredAi.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _SuggestedActivityCard(activity: _filteredAi[i]),
              ),
            ),
        ],
      );
    }

    // Default empty state
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.travel_explore_rounded,
              size: 72,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.3),
            ),
            const Gap(AppSpacing.lg),
            Text(
              'Enter a destination above\nto get AI activity suggestions',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _skeletonCards() => List.generate(
        5,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppSpacing.lg),
              ),
            ),
          ),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _AiErrorCard extends StatelessWidget {
  const _AiErrorCard({required this.error, required this.onRetry});
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppCard(
      child: Column(
        children: [
          Icon(Icons.error_outline_rounded, color: colorScheme.error),
          const Gap(AppSpacing.sm),
          Text(
            'Could not load suggestions.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(AppSpacing.xs),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(AppSpacing.sm),
          AppButton(
            label: 'Retry',
            onPressed: onRetry,
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}

Future<void> _showTripPicker(
  BuildContext context,
  WidgetRef ref, {
  required String title,
  required String category,
  required String locationName,
  required int estimatedCost,
  required int durationMinutes,
  required String description,
}) async {
  final trips = ref.read(tripsStreamProvider).valueOrNull ?? [];
  if (trips.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create a trip first.')),
    );
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add to which trip?',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const Gap(AppSpacing.md),
            ...trips.map(
              (trip) => ListTile(
                leading: const Icon(Icons.flight_takeoff_rounded),
                title: Text(trip.title),
                subtitle: Text(trip.destination),
                onTap: () async {
                  Navigator.pop(ctx);
                  final user = ref.read(authStateChangesProvider).valueOrNull;
                  if (user == null) return;
                  await ref.read(activityRepositoryProvider).addActivity(
                        tripId: trip.tripId,
                        title: title,
                        category: category,
                        locationName: locationName,
                        estimatedCost: estimatedCost,
                        durationMinutes: durationMinutes,
                        userId: user.uid,
                        description: description,
                      );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"$title" added to ${trip.title}.'),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SuggestedActivityCard extends ConsumerWidget {
  const _SuggestedActivityCard({required this.activity});
  final SuggestedActivity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CategoryBadge(category: activity.category),
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
                  activity.locationName,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              _CostBadge(label: activity.formattedCost),
            ],
          ),
          const Gap(AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              onPressed: () => _showTripPicker(
                context,
                ref,
                title: activity.title,
                category: activity.category,
                locationName: activity.locationName,
                estimatedCost: activity.estimatedCostUSD * 100,
                durationMinutes: activity.durationMinutes,
                description: activity.description,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 16),
                  Gap(AppSpacing.xs),
                  Text('Add to Trip'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(
        category.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSecondaryContainer,
              letterSpacing: 0.8,
            ),
      ),
    );
  }
}

class _CostBadge extends StatelessWidget {
  const _CostBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.scoreHigh.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.scoreHigh,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
