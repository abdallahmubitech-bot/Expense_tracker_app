import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/expense.dart';
import '../providers/expense_form_controller.dart';
import '../providers/expense_list_controller.dart';
import '../widgets/expense_form_body.dart';
import '../widgets/expense_form_values.dart';

/// Full screen create/edit form used for deep links.
class ExpenseFormPage extends ConsumerStatefulWidget {
  const ExpenseFormPage({this.expenseId, super.key});

  /// When provided the form edits that expense, otherwise it creates one.
  final String? expenseId;

  @override
  ConsumerState<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(expenseListControllerProvider).valueOrNull ??
        const <Expense>[];
    final existing = widget.expenseId == null
        ? null
        : expenses.where((expense) => expense.id == widget.expenseId).firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(existing == null ? 'New expense' : 'Edit expense'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ExpenseFormBody(
            expense: existing,
            submitting: _submitting,
            onSubmit: (values) => _submit(existing, values),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(Expense? existing, ExpenseFormValues values) async {
    setState(() => _submitting = true);
    final controller = ref.read(expenseFormControllerProvider);

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
        Navigator.of(context).pop();
      case SaveError(:final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }
}
