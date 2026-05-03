import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/core/ui/app_text_field.dart';
import 'package:tropicaguide/features/itinerary/presentation/itinerary_notifier.dart';

/// Screen for adding a new activity to a trip's itinerary.
class AddEditActivityScreen extends ConsumerStatefulWidget {
  /// Creates an [AddEditActivityScreen].
  const AddEditActivityScreen({required this.tripId, super.key});

  /// The trip to add the activity to.
  final String tripId;

  @override
  ConsumerState<AddEditActivityScreen> createState() =>
      _AddEditActivityScreenState();
}

class _AddEditActivityScreenState extends ConsumerState<AddEditActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _durationController = TextEditingController();
  String _category = 'sightseeing';

  static const _categories = [
    'sightseeing',
    'food',
    'adventure',
    'rest',
    'transport',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final costDollars = double.tryParse(_costController.text) ?? 0;
    final costCents = (costDollars * 100).toInt();
    final duration = int.tryParse(_durationController.text) ?? 60;

    await ref
        .read(itineraryNotifierProvider(widget.tripId).notifier)
        .addActivity(
          title: _titleController.text,
          category: _category,
          locationName: _locationController.text,
          estimatedCost: costCents,
          durationMinutes: duration,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
        );

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itineraryNotifierProvider(widget.tripId));
    final isLoading = state is AsyncLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Activity')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _titleController,
                  label: 'Activity Name',
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  controller: _locationController,
                  label: 'Location / Venue',
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  controller: _descriptionController,
                  label: 'Description (optional)',
                  textInputAction: TextInputAction.next,
                ),
                const Gap(AppSpacing.md),
                // Category dropdown
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c,
                          child: Text(c[0].toUpperCase() + c.substring(1)),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  controller: _costController,
                  label: 'Estimated Cost (USD)',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (double.tryParse(v) == null) return 'Enter a number';
                    return null;
                  },
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  controller: _durationController,
                  label: 'Duration (minutes)',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (int.tryParse(v) == null) return 'Enter a whole number';
                    return null;
                  },
                ),
                const Gap(AppSpacing.xl),
                AppButton(
                  label: 'Add to Itinerary',
                  onPressed: _submit,
                  isLoading: isLoading,
                  icon: Icons.add_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
