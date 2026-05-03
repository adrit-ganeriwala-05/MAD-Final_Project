import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/theme/app_theme.dart';

/// Entry point.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Phase 2 adds: await Firebase.initializeApp(...)
  runApp(const ProviderScope(child: TropicaGuideApp()));
}

/// Root widget. Wires theme and routing; no business logic lives here.
class TropicaGuideApp extends StatelessWidget {
  /// Creates [TropicaGuideApp].
  const TropicaGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
