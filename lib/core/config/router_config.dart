import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/features/auth/presentation/sign_in_screen.dart';
import 'package:tropicaguide/features/trips/presentation/trip_dashboard_screen.dart';

// ── Phase 1 auth stub ─────────────────────────────────────────────────────────
// Replaced in Phase 3 with a Riverpod StreamProvider wrapping FirebaseAuth.
// Sign-in screen writes `true`; sign-out writes `false`.
// GoRouter's refreshListenable reacts to every change.
/// Auth state stub used by the router in Phase 1.
///
/// Phase 3 replaces this with a Riverpod provider backed by FirebaseAuth.
final ValueNotifier<bool> authStateNotifier = ValueNotifier<bool>(false);

// ── Route path constants ──────────────────────────────────────────────────────

/// Named path constants — use these everywhere instead of raw strings.
abstract final class AppRoutes {
  /// Sign-in screen.
  static const String signIn = '/sign-in';

  /// Main dashboard.
  static const String home = '/home';
}

// ── Router instance ───────────────────────────────────────────────────────────

/// The app's singleton [GoRouter] instance.
///
/// Created once at startup. All navigation goes through this object.
final GoRouter appRouter = _buildRouter();

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authStateNotifier,
    redirect: (BuildContext context, GoRouterState state) {
      final signedIn = authStateNotifier.value;
      final goingToAuth = state.matchedLocation.startsWith('/sign-in');

      if (!signedIn && !goingToAuth) return AppRoutes.signIn;
      if (signedIn && goingToAuth) return AppRoutes.home;
      return null;
    },
    errorBuilder: (BuildContext context, GoRouterState state) =>
        const _NotFoundScreen(),
    routes: [
      GoRoute(
        path: AppRoutes.signIn,
        builder: (BuildContext context, GoRouterState state) =>
            const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) =>
            const TripDashboardScreen(),
      ),
      // Phase 3 adds: sign-up, forgot-password
      // Phase 5 adds: /trips/:tripId/itinerary
      // Phase 6 adds: /trips/:tripId/checklist, /discover
      // Phase 7 adds: /profile
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
