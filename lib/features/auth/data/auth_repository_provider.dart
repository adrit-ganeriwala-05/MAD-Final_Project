import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/core/firebase/firebase_providers.dart';
import 'package:tropicaguide/features/auth/data/auth_repository.dart';
import 'package:tropicaguide/features/auth/domain/app_user.dart';

part 'auth_repository_provider.g.dart';

/// Provides the singleton [AuthRepository].
@riverpod
AuthRepository authRepository(Ref ref) =>
    AuthRepository(ref.watch(firebaseAuthProvider));

/// Stream provider that emits the current [AppUser] or `null`.
///
/// GoRouter's refreshListenable listens to a ChangeNotifier wrapping
/// this stream — see router_config.dart.
@riverpod
Stream<AppUser?> authStateChanges(Ref ref) =>
    ref.watch(authRepositoryProvider).authStateChanges;
