import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tropicaguide/features/auth/data/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    late MockFirebaseAuth mockAuth;
    late AuthRepository repo;

    setUp(() {
      mockAuth = MockFirebaseAuth();
      repo = AuthRepository(mockAuth);
    });

    test('signIn returns AuthSuccess for valid credentials', () async {
      final result = await repo.signIn(
        email: 'test@example.com',
        password: 'password123',
      );
      expect(result, isA<AuthSuccess>());
    });

    test('authStateChanges emits null when signed out', () async {
      expect(repo.authStateChanges, emits(null));
    });

    test('currentUser returns null before sign-in', () {
      expect(repo.currentUser, isNull);
    });
  });
}
