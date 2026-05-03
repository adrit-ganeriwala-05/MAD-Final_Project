import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tropicaguide/core/config/app_config.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/app_button.dart';

/// Sign-in screen.
///
/// **Phase 1 (current):** Stub — a single button simulates authentication by
/// writing `true` to [authStateNotifier], triggering the GoRouter redirect.
///
/// **Phase 3:** Full email/password form + Google Sign-In.
class SignInScreen extends StatelessWidget {
  /// Creates a [SignInScreen].
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppStrings.appName,
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.sm),
              Text(
                AppStrings.tagline,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(AppSpacing.xxxl),
              // ── Phase 1 routing test — replaced by real form in Phase 3 ──
              AppButton(
                label: '${AppStrings.signIn} →',
                onPressed: () => authStateNotifier.value = true,
              ),
              if (AppConfig.environment == AppEnvironment.dev) ...[
                const Gap(AppSpacing.md),
                Text(
                  'Phase 1 stub — tap above to simulate auth and verify routing.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
