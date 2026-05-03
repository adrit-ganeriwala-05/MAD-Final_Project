import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/app_button.dart';

/// A centred error-state view with a retry action.
///
/// Example:
/// ```dart
/// ErrorState(
///   message: 'Could not load trips.',
///   onRetry: ref.invalidate(tripsProvider),
/// )
/// ```
class ErrorState extends StatelessWidget {
  /// Creates an [ErrorState].
  const ErrorState({
    required this.onRetry,
    super.key,
    this.message = AppStrings.genericError,
  });

  /// The error message shown to the user.
  final String message;

  /// Callback invoked when the user taps the retry button.
  final VoidCallback onRetry;

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
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 44,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const Gap(AppSpacing.xl),
            Text(
              'Oops!',
              style: textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.sm),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(AppSpacing.xl),
            AppButton(
              label: AppStrings.retry,
              onPressed: onRetry,
              fullWidth: false,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
