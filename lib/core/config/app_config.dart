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
  ///
  /// Phase 2 reads this flag to call useFirestoreEmulator() etc.
  static bool get useEmulator => environment == AppEnvironment.dev;
}
