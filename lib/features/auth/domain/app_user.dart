import 'package:firebase_auth/firebase_auth.dart';

/// Domain model representing a signed-in user.
///
/// Wraps [User] from Firebase Auth and exposes only the fields
/// the app cares about, keeping feature code decoupled from the SDK.
class AppUser {
  /// Creates an [AppUser].
  const AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  /// Creates an [AppUser] from a Firebase [User].
  factory AppUser.fromFirebase(User user) => AppUser(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );

  /// Firebase UID.
  final String uid;

  /// Email address.
  final String email;

  /// Display name, set after profile bootstrap.
  final String? displayName;

  /// Avatar URL from Firebase Storage or a social provider.
  final String? photoUrl;

  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, displayName: $displayName)';
}
