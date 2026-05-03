/// UI string constants.
///
/// All user-visible strings live here in Phase 1.
/// Phase 7 migrates these to ARB files for i18n.
abstract final class AppStrings {
  /// The product name.
  static const String appName = 'TropicaGuide';

  /// Short marketing tagline.
  static const String tagline = 'Plan together, travel better.';

  // ── Auth ───────────────────────────────────────────────────────────────────

  /// Label for the sign-in action.
  static const String signIn = 'Sign In';

  /// Label for the sign-up action.
  static const String signUp = 'Create Account';

  /// Label for the sign-out action.
  static const String signOut = 'Sign Out';

  /// Label for the email field.
  static const String email = 'Email';

  /// Label for the password field.
  static const String password = 'Password';

  /// Label for the confirm password field.
  static const String confirmPassword = 'Confirm Password';

  /// Link text for password reset.
  static const String forgotPassword = 'Forgot password?';

  // ── Trips ─────────────────────────────────────────────────────────────────

  /// Screen title for the dashboard.
  static const String myTrips = 'My Trips';

  /// CTA label to start a new trip.
  static const String createTrip = 'Create Trip';

  /// Empty-state heading on the dashboard.
  static const String noTripsYet = 'No trips yet';

  /// Empty-state subheading on the dashboard.
  static const String noTripsSubtitle =
      'Create your first adventure and start planning together.';

  // ── Generic ───────────────────────────────────────────────────────────────

  /// Generic error message body.
  static const String genericError =
      'Something went wrong. Please try again.';

  /// Retry button label.
  static const String retry = 'Try Again';

  /// 404 screen heading.
  static const String notFound = 'Page not found';

  /// 404 screen body.
  static const String notFoundSubtitle =
      'The page you are looking for does not exist.';

  /// Back-to-home label.
  static const String goHome = 'Go Home';
}
