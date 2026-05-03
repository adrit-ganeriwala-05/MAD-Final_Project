import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The app's [TextTheme].
///
/// Display and headline roles use **Fraunces** (expressive serif, hero use).
/// Title, body, and label roles use **Inter** (clean, highly legible UI font).
///
/// All sizes follow the Material 3 type scale exactly.
abstract final class AppTextStyles {
  /// Builds and returns the full [TextTheme].
  static TextTheme get textTheme => TextTheme(
        // ── Display (Fraunces) ────────────────────────────────────────────
        displayLarge: GoogleFonts.fraunces(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: GoogleFonts.fraunces(
          fontSize: 45,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: GoogleFonts.fraunces(
          fontSize: 36,
          fontWeight: FontWeight.w400,
        ),
        // ── Headline (Fraunces) ───────────────────────────────────────────
        headlineLarge: GoogleFonts.fraunces(
          fontSize: 32,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 28,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: GoogleFonts.fraunces(
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
        // ── Title (Inter) ─────────────────────────────────────────────────
        titleLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        // ── Body (Inter) ──────────────────────────────────────────────────
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        // ── Label (Inter) ─────────────────────────────────────────────────
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      );
}
