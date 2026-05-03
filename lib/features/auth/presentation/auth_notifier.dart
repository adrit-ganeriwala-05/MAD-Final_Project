import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/features/auth/data/auth_repository.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';

part 'auth_notifier.g.dart';

/// State for auth form operations.
sealed class AuthState {
  const AuthState();
}

/// No operation in progress.
final class AuthIdle extends AuthState {
  /// Creates an [AuthIdle].
  const AuthIdle();
}

/// An auth operation is in progress.
final class AuthLoading extends AuthState {
  /// Creates an [AuthLoading].
  const AuthLoading();
}

/// An auth operation succeeded.
final class AuthDone extends AuthState {
  /// Creates an [AuthDone].
  const AuthDone();
}

/// An auth operation failed.
final class AuthError extends AuthState {
  /// Creates an [AuthError].
  const AuthError(this.message);

  /// The error message to display.
  final String message;
}

/// Manages auth form state and delegates to [AuthRepository].
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthIdle();

  /// Signs in with email and password.
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthLoading();
    final result = await ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: password);
    state = switch (result) {
      AuthSuccess() => const AuthDone(),
      AuthFailure(:final message) => AuthError(message),
    };
  }

  /// Creates a new account.
  Future<void> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AuthLoading();
    final result = await ref.read(authRepositoryProvider).signUp(
          email: email,
          password: password,
          displayName: displayName,
        );
    state = switch (result) {
      AuthSuccess() => const AuthDone(),
      AuthFailure(:final message) => AuthError(message),
    };
  }

  /// Sends a password reset email.
  Future<void> sendPasswordReset({required String email}) async {
    state = const AuthLoading();
    final result =
        await ref.read(authRepositoryProvider).sendPasswordReset(email: email);
    state = switch (result) {
      AuthSuccess() => const AuthDone(),
      AuthFailure(:final message) => AuthError(message),
    };
  }

  /// Signs out and resets state.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AuthIdle();
  }

  /// Resets to idle — call when navigating away from an error screen.
  void reset() => state = const AuthIdle();
}
