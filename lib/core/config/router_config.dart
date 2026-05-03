import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/features/auth/data/auth_repository_provider.dart';
import 'package:tropicaguide/features/auth/presentation/forgot_password_screen.dart';
import 'package:tropicaguide/features/auth/presentation/sign_in_screen.dart';
import 'package:tropicaguide/features/auth/presentation/sign_up_screen.dart';
import 'package:tropicaguide/features/itinerary/presentation/add_edit_activity_screen.dart';
import 'package:tropicaguide/features/itinerary/presentation/itinerary_builder_screen.dart';
import 'package:tropicaguide/features/trips/presentation/create_trip_screen.dart';
import 'package:tropicaguide/features/trips/presentation/trip_dashboard_screen.dart';

/// Named route paths.
abstract final class AppRoutes {
  /// Sign-in screen.
  static const String signIn = '/sign-in';

  /// Sign-up screen.
  static const String signUp = '/sign-up';

  /// Forgot password screen.
  static const String forgotPassword = '/forgot-password';

  /// Main dashboard.
  static const String home = '/home';

  /// Create trip screen.
  static const String createTrip = '/create-trip';

  /// Itinerary builder — parameterised by tripId.
  static String itinerary(String tripId) => '/trips/$tripId/itinerary';

  /// Add activity screen — parameterised by tripId.
  static String addActivity(String tripId) => '/trips/$tripId/add-activity';
}

/// A [ChangeNotifier] that wraps the auth state stream.
///
/// GoRouter's refreshListenable accepts a [Listenable]. This notifier
/// subscribes to authStateChangesProvider and calls [notifyListeners]
/// on every emission so the router re-evaluates its redirect guard.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(this._ref) {
    _ref.listen(authStateChangesProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
}

/// Builds the app's [GoRouter] with a Riverpod-aware auth guard.
GoRouter buildRouter(Ref ref) {
  final notifier = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: notifier,
    redirect: (BuildContext context, GoRouterState state) {
      final authAsync = ref.read(authStateChangesProvider);
      if (authAsync.isLoading) return null;
      final signedIn = authAsync.valueOrNull != null;
      final goingToAuth = state.matchedLocation == AppRoutes.signIn ||
          state.matchedLocation == AppRoutes.signUp ||
          state.matchedLocation == AppRoutes.forgotPassword;
      if (!signedIn && !goingToAuth) return AppRoutes.signIn;
      if (signedIn && goingToAuth) return AppRoutes.home;
      return null;
    },
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const _NotFoundScreen(),
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (_, __) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (_, __) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, __) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const TripDashboardScreen(),
      ),
      GoRoute(
        path: '/create-trip',
        builder: (_, __) => const CreateTripScreen(),
      ),
      GoRoute(
        path: '/trips/:tripId/itinerary',
        builder: (_, state) => ItineraryBuilderScreen(
          tripId: state.pathParameters['tripId']!,
        ),
      ),
      GoRoute(
        path: '/trips/:tripId/add-activity',
        builder: (_, state) => AddEditActivityScreen(
          tripId: state.pathParameters['tripId']!,
        ),
      ),
    ],
  );
}

// ── 404 screen ────────────────────────────────────────────────────────────────

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.notFound,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.notFoundSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: AppStrings.goHome,
                onPressed: () => context.go(AppRoutes.home),
                fullWidth: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
