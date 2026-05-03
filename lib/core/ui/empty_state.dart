import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/app_button.dart';

/// A centred empty-state view: icon container, heading, subheading, and CTA.
///
/// Use on any screen that may have zero items.
///
/// Example:
/// ```dart
/// EmptyState(
///   title: 'No trips yet',
///   subtitle: 'Create your first adventure.',
///   ctaLabel: 'Create Trip',
///   onCtaTap: () => context.push('/create-trip'),
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// Creates an [EmptyState].
  const EmptyState({
    required this.title,
    required this.subtitle,
    super.key,
    this.ctaLabel,
    this.onCtaTap,
    this.icon = Icons.explore_outlined,
  });

  /// Heading text.
  final String title;

  /// Body / subheading text.
  final String subtitle;

  /// CTA button label. If `null`, no button is shown.
  final String? ctaLabel;

  /// CTA button callback.
  final VoidCallback? onCtaTap;

  /// Icon displayed inside the circular container.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 44,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const Gap(AppSpacing.xl),
            Text(
              title,
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.sm),
            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null) ...[
              const Gap(AppSpacing.xl),
              AppButton(
                label: ctaLabel!,
                onPressed: onCtaTap,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
