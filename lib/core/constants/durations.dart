/// Animation duration constants used throughout the app.
abstract final class AppDurations {
  /// 150 ms — micro interactions: button press, checkbox toggle.
  static const Duration quick = Duration(milliseconds: 150);

  /// 250 ms — standard transitions: fade, slide.
  static const Duration standard = Duration(milliseconds: 250);

  /// 400 ms — elaborate transitions: page push, hero expand.
  static const Duration elaborate = Duration(milliseconds: 400);

  /// 600 ms — slow reveals: onboarding, empty-state illustration.
  static const Duration slow = Duration(milliseconds: 600);
}
