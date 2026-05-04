// lib/main.dart

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tropicaguide/core/config/app_config.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/firebase/firebase_providers.dart';
import 'package:tropicaguide/core/theme/app_theme.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/firebase_options.dart';

part 'main.g.dart';

/// Must be a top-level function for background FCM handling.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  appLogger.i('FCM: background message → ${message.notification?.title}');
}

/// Provides the [GoRouter] instance with access to Riverpod [Ref].
@riverpod
GoRouter router(Ref ref) => buildRouter(ref);

/// Entry point.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  appLogger.i('Starting app — useEmulator: ${AppConfig.useEmulator}');

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Register background FCM handler before any other Firebase calls
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

/// Connects every Firebase SDK to the Local Emulator Suite.
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
    final themeMode = ref.watch(themeModeProvider);

    // Initialise FCM once on app start
    ref.watch(fcmServiceProvider).init();

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
