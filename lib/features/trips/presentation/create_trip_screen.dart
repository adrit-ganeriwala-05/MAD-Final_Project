import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:tropicaguide/core/config/router_config.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/core/ui/app_text_field.dart';
import 'package:tropicaguide/features/trips/presentation/trips_notifier.dart';

/// Screen for creating a new trip.
class CreateTripScreen extends ConsumerStatefulWidget {
  /// Creates a [CreateTripScreen].
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _titleController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = picked.add(const Duration(days: 1));
        }
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final budgetDollars = double.tryParse(_budgetController.text) ?? 0;
    final tripId =
        await ref.read(createTripNotifierProvider.notifier).createTrip(
              title: _titleController.text,
              destination: _destinationController.text,
              totalBudget: (budgetDollars * 100).toInt(),
              startDate: _startDate,
              endDate: _endDate,
            );
    if (tripId != null && mounted) {
      context.pushReplacement(AppRoutes.itinerary(tripId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTripNotifierProvider);
    final isLoading = state is AsyncLoading;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen(createTripNotifierProvider, (_, next) {
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
      appBar: AppBar(title: const Text('New Trip')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Plan your adventure', style: textTheme.headlineSmall),
                const Gap(AppSpacing.xl),
                AppTextField(
                  controller: _titleController,
                  label: 'Trip Name',
                  hint: 'e.g. Cancún Spring Break',
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  controller: _destinationController,
                  label: 'Destination',
                  hint: 'e.g. Cancún, Mexico',
                  textInputAction: TextInputAction.next,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
                const Gap(AppSpacing.md),
                AppTextField(
                  controller: _budgetController,
                  label: 'Total Budget (USD)',
                  hint: '0',
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                // Date pickers
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerButton(
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () => _pickDate(isStart: true),
                      ),
                    ),
                    const Gap(AppSpacing.md),
                    Expanded(
                      child: _DatePickerButton(
                        label: 'End Date',
                        date: _endDate,
                        onTap: () => _pickDate(isStart: false),
                      ),
                    ),
                  ],
                ),
                const Gap(AppSpacing.xl),
                AppButton(
                  label: 'Create Trip',
                  onPressed: _submit,
                  isLoading: isLoading,
                  icon: Icons.flight_takeoff_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DatePickerButton extends StatelessWidget {
  const _DatePickerButton({
    required this.label,
    required this.onTap,
    this.date,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(AppSpacing.xs),
            Text(
              date == null
                  ? 'Select date'
                  : '${date!.day}/${date!.month}/${date!.year}',
              style: textTheme.bodyMedium?.copyWith(
                color: date == null
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
