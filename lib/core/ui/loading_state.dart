import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tropicaguide/core/constants/spacing.dart';

/// A shimmer skeleton loading state.
///
/// Renders [itemCount] skeleton cards. Place this wherever a list or grid
/// would appear — it mirrors the approximate shape of real content.
/// Never show a bare [CircularProgressIndicator] on an empty screen.
///
/// Example:
/// ```dart
/// if (tripsAsync.isLoading) return const LoadingState();
/// ```
class LoadingState extends StatelessWidget {
  /// Creates a [LoadingState].
  const LoadingState({super.key, this.itemCount = 3});

  /// Number of skeleton card items to display.
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF3E3E3E) : const Color(0xFFF5F5F5),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: itemCount,
        separatorBuilder: (_, __) => const Gap(AppSpacing.md),
        itemBuilder: (_, __) => const _SkeletonCard(),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title line
          Container(
            height: 16,
            width: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Gap(AppSpacing.sm),
          // Subtitle line
          Container(
            height: 12,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Gap(AppSpacing.sm),
          // Third line
          Container(
            height: 12,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
