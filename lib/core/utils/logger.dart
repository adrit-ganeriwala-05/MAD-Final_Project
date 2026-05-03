import 'package:logger/logger.dart';

/// Global logger instance.
///
/// Usage: `appLogger.d('debug message')`, `.i()`, `.w()`, `.e()`.
/// Never use `print()` — this instance controls log level per environment.
final Logger appLogger = Logger(
  printer: PrettyPrinter(
    lineLength: 80,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  // Phase 2: set to Level.warning in prod via AppConfig.environment check
  level: Level.debug,
);
