import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/core/config/app_config.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/theme/app_theme.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/firebase_options.dart';

part 'main.g.dart';

/// Provides the [GoRouter] instance with access to Riverpod [Ref].
@riverpod
GoRouter router(Ref ref) => buildRouter(ref);

/// Entry point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appLogger.i('Starting app — useEmulator: ${AppConfig.useEmulator}');

  // Guard against duplicate-app error on hot restart
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (AppConfig.useEmulator) {
    await _connectEmulators();
  }

  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(const ProviderScope(child: TropicaGuideApp()));
}

// Connects every Firebase SDK to the Local Emulator Suite.
// Each SDK is wrapped independently so an "already configured" throw on
// hot-restart (auth/storage) doesn't skip the Firestore connection.
Future<void> _connectEmulators() async {
  final host = AppConfig.emulatorHost;

  try {
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  } on Exception catch (e) {
    appLogger.w('⚠️ Auth emulator: $e');
  }

  try {
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  } on Exception catch (e) {
    appLogger.w('⚠️ Firestore emulator: $e');
  }

  try {
    await FirebaseStorage.instance.useStorageEmulator(host, 9199);
  } on Exception catch (e) {
    appLogger.w('⚠️ Storage emulator: $e');
  }

  appLogger.i('🔧 Firebase emulators connected → $host');
}

/// Root widget.
class TropicaGuideApp extends ConsumerWidget {
  /// Creates [TropicaGuideApp].
  const TropicaGuideApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}