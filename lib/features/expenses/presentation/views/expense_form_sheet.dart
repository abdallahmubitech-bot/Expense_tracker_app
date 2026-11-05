import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/expense.dart';
import '../providers/expense_form_controller.dart';
import '../widgets/expense_form_body.dart';
import '../widgets/expense_form_values.dart';

/// Opens the expense form as a modal bottom sheet.
///
/// Returns true when an expense was saved.
Future<bool> showExpenseFormSheet(
  BuildContext context, {
  Expense? expense,
}) async {
  final saved = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => ExpenseFormSheet(expense: expense),
  );
  return saved ?? false;
}

/// Bottom sheet wrapper around [ExpenseFormBody].
class ExpenseFormSheet extends ConsumerStatefulWidget {
  const ExpenseFormSheet({this.expense, super.key});

  /// Existing expense when editing.
  final Expense? expense;

  @override
  ConsumerState<ExpenseFormSheet> createState() => _ExpenseFormSheetState();
}

class _ExpenseFormSheetState extends ConsumerState<ExpenseFormSheet> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.expense != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    isEditing ? 'Edit expense' : 'New expense',
                    style: theme.textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Close',
                ),
              ],
            ),
            const SizedBox(height: 12),
            ExpenseFormBody(
              expense: widget.expense,
              submitting: _submitting,
              onSubmit: _handleSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit(ExpenseFormValues values) async {
    setState(() => _submitting = true);
    final controller = ref.read(expenseFormControllerProvider);
    final existing = widget.expense;

    final outcome = existing == null
        ? await controller.create(
            title: values.title,
            amount: values.amount,
            date: values.date,
            category: values.category,
            note: values.note,
          )
        : await controller.update(
            existing.copyWith(
              title: values.title,
              amount: values.amount,
              date: values.date,
              category: values.category,
              note: values.note,
            ),
          );

    if (!mounted) return;
    setState(() => _submitting = false);

    switch (outcome) {
      case SaveSuccess():
        Navigator.of(context).pop(true);
      case SaveError(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }
}
