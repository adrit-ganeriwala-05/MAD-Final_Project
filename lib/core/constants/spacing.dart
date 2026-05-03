/// Spacing constants — the only values allowed for margins, paddings, and gaps.
///
/// Do not use magic numbers elsewhere. Import this file and use [AppSpacing].
abstract final class AppSpacing {
  /// 4 dp — micro spacing, icon internal padding.
  static const double xs = 4;

  /// 8 dp — tight spacing between related items.
  static const double sm = 8;

  /// 12 dp — compact group separation.
  static const double md = 12;

  /// 16 dp — standard screen/card padding.
  static const double lg = 16;

  /// 24 dp — section-level spacing.
  static const double xl = 24;

  /// 32 dp — screen-level separation.
  static const double xxl = 32;

  /// 48 dp — hero / onboarding spacing.
  static const double xxxl = 48;
}
