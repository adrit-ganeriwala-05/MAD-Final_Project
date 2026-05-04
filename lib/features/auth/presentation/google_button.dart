// lib/features/auth/presentation/google_button.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tropicaguide/core/constants/spacing.dart';

/// Google branded sign-in/sign-up button with official logo.
class GoogleButton extends StatelessWidget {
  /// Creates a [GoogleButton].
  const GoogleButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  /// Button label text.
  final String label;

  /// Callback fired on tap. Pass `null` to disable.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
            imageUrl:
                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
            width: 20,
            height: 20,
            placeholder: (_, __) => const SizedBox(width: 20, height: 20),
            errorWidget: (_, __, ___) => const Icon(Icons.g_mobiledata_rounded,
                size: 20, color: Color(0xFF4285F4),) ,
          ) ,
          const Gap(AppSpacing.sm),
          Text(label, style: textTheme.labelLarge),
        ],
      ),
    );
  }
}

/// "or" divider used between social and email auth options.
class OrDivider extends StatelessWidget {
  /// Creates an [OrDivider].
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'or',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
