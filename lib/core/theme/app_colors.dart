import 'package:flutter/material.dart';

/// Static color tokens that do not depend on the current [ColorScheme].
///
/// For theme-aware colors (primary, surface, etc.) use
/// `Theme.of(context).colorScheme` directly in widgets — do not add them here.
abstract final class AppColors {
  /// The Material 3 seed color.
  ///
  /// Warm terracotta-amber: evokes travel and adventure without
  /// defaulting to the clichéd tropical teal used by most travel apps.
  /// Material 3 derives the full tonal palette from this single value.
  static const Color seed = Color(0xFFD97B4B);

  // ── Score chip colors (used in itinerary builder — Phase 5) ───────────────

  /// High score indicator (green).
  static const Color scoreHigh = Color(0xFF43A047);

  /// Mid score indicator (amber).
  static const Color scoreMid = Color(0xFFFFB300);

  /// Low score indicator (red).
  static const Color scoreLow = Color(0xFFE53935);
}
