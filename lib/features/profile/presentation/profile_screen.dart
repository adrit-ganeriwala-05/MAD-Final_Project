// lib/features/profile/presentation/profile_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tropicaguide/core/config/app_config.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/core/ui/app_text_field.dart';
import 'package:tropicaguide/core/ui/error_state.dart';
import 'package:tropicaguide/core/ui/loading_state.dart';
import 'package:tropicaguide/core/utils/logger.dart';
import 'package:tropicaguide/features/auth/presentation/auth_notifier.dart';
import 'package:tropicaguide/features/profile/domain/user_profile.dart';
import 'package:tropicaguide/features/profile/presentation/profile_notifier.dart';

/// Profile screen for viewing and editing user preferences.
class ProfileScreen extends ConsumerStatefulWidget {
  /// Creates a [ProfileScreen].
  const ProfileScreen({required this.uid, super.key});

  /// The UID of the user whose profile is shown.
  final String uid;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  String _pace = 'moderate';
  bool _initialised = false;

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _populate(UserProfile profile) {
    if (_initialised) return;
    _initialised = true;
    _nameController.text = profile.displayName;
    _budgetController.text =
        (profile.defaultDailyBudget / 100).toStringAsFixed(0);
    setState(() => _pace = profile.pace);
  }

  Future<void> _pickProfilePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 512,
    );
    if (picked == null) return;
    await ref.read(profileNotifierProvider.notifier).uploadPhoto(
          uid: widget.uid,
          imageFile: File(picked.path),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo updated!')),
      );
    }
    appLogger.i('ProfileScreen: uploaded photo for ${widget.uid}');
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final budgetDollars = double.tryParse(_budgetController.text) ?? 0;
    await ref.read(profileNotifierProvider.notifier).updateProfile(
          uid: widget.uid,
          displayName: _nameController.text,
          defaultDailyBudget: (budgetDollars * 100).toInt(),
          pace: _pace,
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved!')),
      );
    }
    appLogger.i('ProfileScreen: saved profile for ${widget.uid}');
  }

  @override
  Widget build(BuildContext context) {
    final bootstrapAsync = ref.watch(userBootstrapProvider);
    final profileAsync = bootstrapAsync.when(
      loading: () => const AsyncLoading<UserProfile?>(),
      error: AsyncError<UserProfile?>.new,
      data: (_) => ref.watch(userProfileProvider(widget.uid)),
    );
    final notifierState = ref.watch(profileNotifierProvider);
    final themeMode = ref.watch(themeModeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isLoading = notifierState is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: profileAsync.when(
        loading: () => const LoadingState(),
        error: (e, __) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(userProfileProvider(widget.uid)),
        ),
        data: (profile) {
          if (profile == null) return const LoadingState();
          _populate(profile);
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Tappable avatar ─────────────────────────────────────
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: isLoading ? null : _pickProfilePhoto,
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: colorScheme.primaryContainer,
                              backgroundImage: profile.photoUrl != null
                                  ? NetworkImage(profile.photoUrl!)
                                  : null,
                              child: profile.photoUrl == null
                                  ? Text(
                                      profile.initials,
                                      style: textTheme.headlineMedium
                                          ?.copyWith(
                                        color: colorScheme.onPrimaryContainer,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: isLoading ? null : _pickProfilePhoto,
                              child: Container(
                                padding:
                                    const EdgeInsets.all(AppSpacing.xs),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: colorScheme.surface,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          if (isLoading)
                            const Positioned.fill(
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.black38,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Gap(AppSpacing.sm),
                    Center(
                      child: Text(
                        profile.email,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Gap(AppSpacing.xl),

                    // ── Editable fields ─────────────────────────────────────
                    AppTextField(
                      controller: _nameController,
                      label: 'Display Name',
                      textInputAction: TextInputAction.next,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const Gap(AppSpacing.md),
                    AppTextField(
                      controller: _budgetController,
                      label: 'Daily Budget (USD)',
                      hint: '200',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        if (v != null &&
                            v.isNotEmpty &&
                            double.tryParse(v) == null) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const Gap(AppSpacing.lg),

                    // ── Travel pace ─────────────────────────────────────────
                    Text('Travel Pace', style: textTheme.labelLarge),
                    const Gap(AppSpacing.sm),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'relaxed',
                          label: Text('Relaxed'),
                          icon: Icon(Icons.beach_access_outlined),
                        ),
                        ButtonSegment(
                          value: 'moderate',
                          label: Text('Moderate'),
                          icon: Icon(Icons.directions_walk_outlined),
                        ),
                        ButtonSegment(
                          value: 'intense',
                          label: Text('Intense'),
                          icon: Icon(Icons.directions_run_outlined),
                        ),
                      ],
                      selected: {_pace},
                      onSelectionChanged: (val) =>
                          setState(() => _pace = val.first),
                    ),
                    const Gap(AppSpacing.xl),

                    // ── Appearance ──────────────────────────────────────────
                    Text('Appearance', style: textTheme.labelLarge),
                    const Gap(AppSpacing.sm),
                    SegmentedButton<ThemeMode>(
                      segments: const [
                        ButtonSegment(
                          value: ThemeMode.system,
                          label: Text('System'),
                          icon: Icon(Icons.brightness_auto_outlined),
                        ),
                        ButtonSegment(
                          value: ThemeMode.light,
                          label: Text('Light'),
                          icon: Icon(Icons.light_mode_outlined),
                        ),
                        ButtonSegment(
                          value: ThemeMode.dark,
                          label: Text('Dark'),
                          icon: Icon(Icons.dark_mode_outlined),
                        ),
                      ],
                      selected: {themeMode},
                      onSelectionChanged: (val) {
                        ref.read(themeModeProvider.notifier).themeMode =
                            val.first;
                      },
                    ),
                    const Gap(AppSpacing.xl),

                    AppButton(
                      label: 'Save Changes',
                      onPressed: _save,
                      isLoading: isLoading,
                      icon: Icons.save_outlined,
                    ),
                    const Gap(AppSpacing.xl),

                    AppButton(
                      label: 'Sign Out',
                      variant: AppButtonVariant.secondary,
                      onPressed: () =>
                          ref.read(authNotifierProvider.notifier).signOut(),
                      icon: Icons.logout_outlined,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
