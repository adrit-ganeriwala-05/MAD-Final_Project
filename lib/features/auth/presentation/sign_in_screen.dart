
// lib/features/auth/presentation/sign_in_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/core/ui/app_text_field.dart';
import 'package:tropicaguide/features/auth/presentation/auth_notifier.dart';
import 'package:tropicaguide/features/auth/presentation/google_button.dart';
/// Sign-in screen with email/password and Google Sign-In.
class SignInScreen extends ConsumerStatefulWidget {
  /// Creates a [SignInScreen].
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  @override

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authNotifierProvider.notifier).signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }
  Future<void> _googleSignIn() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = authState is AuthLoading;
    ref.listen(authNotifierProvider, (_, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    });
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(AppSpacing.xxxl),
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
                GoogleButton(
                  label: 'Continue with Google',
                  onPressed: isLoading ? null : _googleSignIn,
                ),
                const Gap(AppSpacing.lg),
                const OrDivider(),
                const Gap(AppSpacing.lg),
                AppTextField(
                  controller: _emailController,
                  label: AppStrings.email,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required.';
                    }
                    if (!value.trim().contains('@')) {
                      return 'Enter a valid email.';
                    }
                    return null;
                  },
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  controller: _passwordController,
                  label: AppStrings.password,
                  focusNode: _passwordFocus,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required.';
                    }
                    return null;
                  },
                ),
                const Gap(AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: const Text(AppStrings.forgotPassword),
                  ),
                ),
                const Gap(AppSpacing.lg),
                AppButton(
                  label: AppStrings.signIn,
                  onPressed: _submit,
                  isLoading: isLoading,
                ),
                const Gap(AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signUp),
                      child: const Text(AppStrings.signUp),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

      ),

    );

  }

}


