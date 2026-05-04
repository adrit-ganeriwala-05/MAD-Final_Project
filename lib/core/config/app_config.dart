// lib/core/config/app_config.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application environment.
enum AppEnvironment {
  /// Local development — uses Firebase Local Emulator Suite.
  dev,

  /// Production Firebase project.
  prod,
}

/// Application-wide static configuration.
///
/// The environment is set at build time via `--dart-define`:
/// ```sh
/// flutter run --dart-define=ENVIRONMENT=prod
/// ```
/// Defaults to [AppEnvironment.dev] when the flag is absent.
abstract final class AppConfig {
  static const String _envValue = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  /// The active [AppEnvironment].
  static AppEnvironment get environment =>
      _envValue == 'prod' ? AppEnvironment.prod : AppEnvironment.dev;

  /// Whether to point Firebase SDKs at the Local Emulator Suite.
  static bool get useEmulator => environment == AppEnvironment.dev;

  /// The emulator host address.
  ///
  /// Android emulators reach the host machine via 10.0.2.2.
  /// iOS simulators and desktop use localhost.
  static String get emulatorHost =>
      Platform.isAndroid ? '10.0.2.2' : 'localhost';
}

/// Manages the app's [ThemeMode] — system, light, or dark.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  /// Cycles through system → light → dark → system.
  void toggle() {
    state = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
  }

  /// Updates the active [ThemeMode].
  // ignore: avoid_setters_without_getters
  set themeMode(ThemeMode mode) => state = mode;
}

/// Provider for the current [ThemeMode].
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
    
