import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:tropicaguide/core/constants/spacing.dart';

/// Button style variant.
enum AppButtonVariant {
  /// Filled primary action button.
  primary,

  /// Outlined secondary action button.
  secondary,

  /// Flat text-only button.
  text,

  /// Filled destructive action button using the error colour.
  danger,
}

/// TropicaGuide design-system button.
///
/// Wraps the appropriate Material 3 button type based on [variant].
/// All variants fire [HapticFeedback.lightImpact] on press and support
/// a loading state that disables interaction and shows a spinner.
///
/// Example:
/// ```dart
/// AppButton(
///   label: 'Create Trip',
///   onPressed: () => ...,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = true,
  });

  /// The button label text.
  final String label;

  /// Callback fired on tap. Pass `null` to disable the button.
  final VoidCallback? onPressed;

  /// Visual style variant. Defaults to [AppButtonVariant.primary].
  final AppButtonVariant variant;

  /// Optional leading icon.
  final IconData? icon;

  /// When `true`, interaction is disabled and a spinner replaces the label.
  final bool isLoading;

  /// When `true` (default), the button stretches to fill available width.
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final child = _buildChild(context);

    void handlePress() {
      unawaited(HapticFeedback.lightImpact());
      onPressed?.call();
    }

    final effectiveOnPressed =
        (isLoading || onPressed == null) ? null : handlePress;

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          child: child,
        ),
      AppButtonVariant.danger => FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: effectiveOnPressed,
          child: child,
        ),
    };

    if (fullWidth) return SizedBox(width: double.infinity, child: button);
    return button;
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.primary
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const Gap(AppSpacing.sm),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
