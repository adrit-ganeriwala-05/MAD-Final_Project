import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/constants/strings.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/core/ui/app_text_field.dart';
import 'package:tropicaguide/features/auth/presentation/auth_notifier.dart';

/// Forgot password screen.
///
/// Sends a password reset email via Firebase Auth.
/// Shows a confirmation message on success.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  /// Creates a [ForgotPasswordScreen].
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(authNotifierProvider.notifier)
        .sendPasswordReset(email: _emailController.text);
    final authState = ref.read(authNotifierProvider);
    if (authState is AuthDone && mounted) {
      setState(() => _emailSent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (_, next) {
      if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: _emailSent ? _buildConfirmation(context) : _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    final authState = ref.watch(authNotifierProvider);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(AppSpacing.lg),
          Text(
            'Forgot your password?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Gap(AppSpacing.sm),
          Text(
            "Enter your email and we'll send you a reset link.",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Gap(AppSpacing.xxl),
          AppTextField(
            controller: _emailController,
            label: AppStrings.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
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
          const Gap(AppSpacing.xl),
          AppButton(
            label: 'Send Reset Link',
            onPressed: _submit,
            isLoading: authState is AuthLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 44,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const Gap(AppSpacing.xl),
        Text(
          'Check your inbox',
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const Gap(AppSpacing.sm),
        Text(
          'A password reset link has been sent to '
          '${_emailController.text.trim()}.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const Gap(AppSpacing.xl),
        AppButton(
          label: 'Back to Sign In',
          onPressed: () => context.pop(),
          fullWidth: false,
          variant: AppButtonVariant.secondary,
        ),
      ],
    );
  }
}
