import 'package:firebase_auth/firebase_auth.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/features/auth/domain/app_user.dart';

/// Result type for auth operations.
sealed class AuthResult {
  const AuthResult();
}

/// Auth operation succeeded.
final class AuthSuccess extends AuthResult {
  /// Creates an [AuthSuccess].
  const AuthSuccess(this.user);

  /// The signed-in user.
  final AppUser user;
}

/// Auth operation failed with a user-friendly message.
final class AuthFailure extends AuthResult {
  /// Creates an [AuthFailure].
  const AuthFailure(this.message);

  /// The error message to display.
  final String message;
}

/// Wraps [FirebaseAuth] and exposes a clean API for auth operations.
///
/// All methods return [AuthResult] — callers never catch raw Firebase
/// exceptions. Error messages are mapped to user-friendly strings here.
class AuthRepository {
  /// Creates an [AuthRepository].
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;

  /// Stream of the current [AppUser], or `null` when signed out.
  Stream<AppUser?> get authStateChanges => _auth.authStateChanges().map(
        (user) => user == null ? null : AppUser.fromFirebase(user),
      );

  /// The currently signed-in [AppUser], or `null`.
  AppUser? get currentUser {
    final user = _auth.currentUser;
    return user == null ? null : AppUser.fromFirebase(user);
  }

  /// Signs in with [email] and [password].
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = AppUser.fromFirebase(credential.user!);
      appLogger.i('Auth: signed in → ${user.uid}');
      return AuthSuccess(user);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Auth: sign-in failed → ${e.code}');
      return AuthFailure(_mapError(e.code));
    }
  }

  /// Creates a new account with [email] and [password].
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user!.updateDisplayName(displayName.trim());
      await credential.user!.reload();
      final user = AppUser.fromFirebase(_auth.currentUser!);
      appLogger.i('Auth: signed up → ${user.uid}');
      return AuthSuccess(user);
    } on FirebaseAuthException catch (e) {
      appLogger.w('Auth: sign-up failed → ${e.code}');
      return AuthFailure(_mapError(e.code));
    }
  }

  /// Sends a password reset email to [email].
  Future<AuthResult> sendPasswordReset({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      appLogger.i('Auth: password reset sent → $email');
      return const AuthSuccess(AppUser(uid: '', email: ''));
    } on FirebaseAuthException catch (e) {
      appLogger.w('Auth: password reset failed → ${e.code}');
      return AuthFailure(_mapError(e.code));
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
    appLogger.i('Auth: signed out');
  }

  /// Maps a Firebase error code to a user-friendly message.
  String _mapError(String code) => switch (code) {
        'user-not-found' => 'No account found with that email.',
        'wrong-password' => 'Incorrect password. Please try again.',
        'invalid-credential' => 'Incorrect email or password.',
        'email-already-in-use' => 'An account with this email already exists.',
        'weak-password' => 'Password must be at least 6 characters.',
        'invalid-email' => 'Please enter a valid email address.',
        'too-many-requests' =>
          'Too many attempts. Please wait a moment and try again.',
        'network-request-failed' =>
          'Network error. Check your connection and try again.',
        _ => 'Something went wrong. Please try again.',
      };
}
