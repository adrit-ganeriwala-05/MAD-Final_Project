// lib/features/profile/domain/user_profile.dart

/// Domain model for a user's Firestore profile.
///
/// Decoupled from the Firebase SDK — use plain Dart types only.
class UserProfile {
  /// Creates a [UserProfile].
  const UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.defaultDailyBudget,
    required this.travelPreferences,
    this.photoUrl,
  });

  /// Firebase UID.
  final String uid;

  /// Email address.
  final String email;

  /// Display name shown in the UI.
  final String displayName;

  /// Optional avatar URL.
  final String? photoUrl;

  /// Default daily budget in cents (e.g. 20000 = $200).
  final int defaultDailyBudget;

  /// Raw travel preferences map stored in Firestore.
  final Map<String, dynamic> travelPreferences;

  /// Travel pace extracted from [travelPreferences].
  String get pace =>
      travelPreferences['pace'] as String? ?? 'moderate';

  /// Formatted daily budget string in dollars.
  String get formattedDailyBudget =>
      '\$${(defaultDailyBudget / 100).toStringAsFixed(0)}';

  /// Initials derived from [displayName] for the avatar placeholder.
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || displayName.trim().isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }
}
