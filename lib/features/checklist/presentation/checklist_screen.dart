import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tropicaguide/core/constants/spacing.dart';
import 'package:tropicaguide/core/ui/app_button.dart';
import 'package:tropicaguide/core/ui/empty_state.dart';
import 'package:tropicaguide/core/ui/error_state.dart';
import 'package:tropicaguide/core/ui/loading_state.dart';
import 'package:tropicaguide/features/checklist/domain/checklist_item.dart';
import 'package:tropicaguide/features/checklist/presentation/checklist_notifier.dart';

/// Shared checklist screen.
///
/// All toggles use Firestore transactions via ChecklistRepository.toggleItem.
/// This screen is the proposal's evidence for concurrent write handling.
class ChecklistScreen extends ConsumerWidget {
  /// Creates a [ChecklistScreen].
  const ChecklistScreen({required this.tripId, super.key});

  /// The trip whose checklist is displayed.
  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checklistAsync = ref.watch(checklistStreamProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Packing List'),
        actions: [
          IconButton(
            tooltip: 'Add item',
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddItemSheet(context, ref),
          ),
        ],
      ),
      body: checklistAsync.when(
        loading: () => const LoadingState(),
        error: (e, __) => ErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(checklistStreamProvider(tripId)),
        ),
        data: (items) => items.isEmpty
            ? EmptyState(
                title: 'Nothing packed yet',
                subtitle: 'Add items to your shared packing list.',
                ctaLabel: 'Add Item',
                onCtaTap: () => _showAddItemSheet(context, ref),
                icon: Icons.luggage_outlined,
              )
            : _ChecklistBody(tripId: tripId),
      ),
    );
  }

  Future<void> _showAddItemSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final labelController = TextEditingController();
    var category = 'packing';

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.xl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Add Item',
                style: Theme.of(ctx).textTheme.titleLarge,
              ),
              const Gap(AppSpacing.lg),
              TextField(
                controller: labelController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Item name'),
                textInputAction: TextInputAction.done,
              ),
              const Gap(AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(
                    value: 'packing',
                    child: Text('Packing'),
                  ),
                  DropdownMenuItem(
                    value: 'document',
                    child: Text('Document'),
                  ),
                  DropdownMenuItem(
                    value: 'todo',
                    child: Text('To-do'),
                  ),
                ],
                onChanged: (v) => setState(() => category = v!),
              ),
              const Gap(AppSpacing.xl),
              AppButton(
                label: 'Add to List',
                onPressed: () {
                  if (labelController.text.trim().isEmpty) return;
                  ref
                      .read(checklistNotifierProvider(tripId).notifier)
                      .addItem(
                        label: labelController.text,
                        category: category,
                      );
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
    labelController.dispose();
  }
}

class _ChecklistBody extends ConsumerWidget {
  const _ChecklistBody({required this.tripId});

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items =
        ref.watch(checklistStreamProvider(tripId)).valueOrNull ?? [];
    final grouped = <String, List<ChecklistItem>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        for (final entry in grouped.entries) ...[
          _CategoryHeader(category: entry.key),
          const Gap(AppSpacing.sm),
          for (final item in entry.value)
            _ChecklistTile(
              key: ValueKey(item.itemId),
              tripId: tripId,
              itemId: item.itemId,
            ),
          const Gap(AppSpacing.lg),
        ],
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return Text(
      category[0].toUpperCase() + category.substring(1),
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 1,
          ),
    );
  }
}

class _ChecklistTile extends ConsumerStatefulWidget {
  const _ChecklistTile({
    required this.tripId,
    required this.itemId,
    super.key,
  });

  final String tripId;
  final String itemId;

  @override
  ConsumerState<_ChecklistTile> createState() => _ChecklistTileState();
}

class _ChecklistTileState extends ConsumerState<_ChecklistTile> {
  bool? _optimisticChecked;

  @override
  Widget build(BuildContext context) {
    final items =
        ref.watch(checklistStreamProvider(widget.tripId)).valueOrNull ?? [];
    final item = items.where((i) => i.itemId == widget.itemId).firstOrNull;

    if (item == null) return const SizedBox.shrink();

    // Once the stream confirms the new value, clear the optimistic override.
    if (_optimisticChecked != null && _optimisticChecked == item.isChecked) {
      _optimisticChecked = null;
    }

    final effectiveChecked = _optimisticChecked ?? item.isChecked;
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(widget.itemId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
      ),
      onDismissed: (_) => ref
          .read(checklistNotifierProvider(widget.tripId).notifier)
          .deleteItem(widget.itemId),
      child: Card(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: CheckboxListTile(
          value: effectiveChecked,
          onChanged: (_) {
            setState(() => _optimisticChecked = !item.isChecked);
            ref
                .read(checklistNotifierProvider(widget.tripId).notifier)
                .toggle(widget.itemId);
          },
          title: Text(
            item.label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  decoration:
                      effectiveChecked ? TextDecoration.lineThrough : null,
                  color:
                      effectiveChecked ? colorScheme.onSurfaceVariant : null,
                ),
          ),
          subtitle: Text(
            item.category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }
}
