// lib/features/trips/presentation/join_trip_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/core/ui/app_text_field.dart';
import 'package:tropicaguide/features/trips/presentation/trips_notifier.dart';

/// Screen for joining an existing trip via a 6-character invite code.
class JoinTripScreen extends ConsumerStatefulWidget {
  /// Creates a [JoinTripScreen].
  const JoinTripScreen({super.key});

  @override
  ConsumerState<JoinTripScreen> createState() => _JoinTripScreenState();
}

class _JoinTripScreenState extends ConsumerState<JoinTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final tripId = await ref
        .read(joinTripNotifierProvider.notifier)
        .joinByCode(_codeController.text);
    if (tripId != null && mounted) {
      context.pushReplacement(AppRoutes.itinerary(tripId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(joinTripNotifierProvider);
    final isLoading = state is AsyncLoading;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen(joinTripNotifierProvider, (_, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Join a Trip')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(AppSpacing.xl),
                Icon(
                  Icons.group_add_outlined,
                  size: 64,
                  color: colorScheme.primary,
                ),
                const Gap(AppSpacing.lg),
                Text(
                  'Enter Invite Code',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const Gap(AppSpacing.sm),
                Text(
                  'Ask a trip member for the 6-character code shown on the itinerary screen.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(AppSpacing.xxl),
                AppTextField(
                  controller: _codeController,
                  label: 'Invite Code',
                  hint: 'e.g. TRP4X9',
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length != 6) {
                      return 'Code must be exactly 6 characters';
                    }
                    return null;
                  },
                ),
                const Gap(AppSpacing.xl),
                AppButton(
                  label: 'Join Trip',
                  onPressed: _submit,
                  isLoading: isLoading,
                  icon: Icons.login_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
