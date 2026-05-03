import 'package:flutter/material.dart';
import 'package:tropicaguide/core/constants/spacing.dart';

/// TropicaGuide design-system card.
///
/// Renders a borderless Material 3 card with consistent corner radius and
/// optional tap handling. Elevation is expressed via surface tint, not shadow.
///
/// Example:
/// ```dart
/// AppCard(
///   onTap: () => ...,
///   child: Text('Hello'),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// Creates an [AppCard].
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.semanticLabel,
  });

  /// Content of the card.
  final Widget child;

  /// Optional tap callback. When provided, the card becomes tappable.
  final VoidCallback? onTap;

  /// Inner padding. Defaults to [AppSpacing.lg] on all sides.
  final EdgeInsetsGeometry? padding;

  /// Accessibility label for the card container.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.lg),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }
}
