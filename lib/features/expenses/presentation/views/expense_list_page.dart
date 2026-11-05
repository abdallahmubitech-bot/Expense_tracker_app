import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../domain/entities/expense.dart';
import '../providers/expense_form_controller.dart';
import '../providers/expense_list_controller.dart';
import '../widgets/expense_tile.dart';
import 'expense_form_sheet.dart';

/// Chronological list of every recorded expense, grouped by day.
class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: SafeArea(
        child: switch (expensesAsync) {
          AsyncError(:final error) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(expenseListControllerProvider),
            ),
          AsyncValue(:final value?) when value.isEmpty => const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No expenses yet',
              message: 'Tap the plus button to record your first expense.',
            ),
          AsyncValue(:final value?) => _ExpenseList(expenses: value),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _ExpenseList extends ConsumerWidget {
  const _ExpenseList({required this.expenses});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = expenses.fold<double>(0, (sum, item) => sum + item.amount);
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'All time spending',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                Formatters.currency(total),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${expenses.length} '
                '${expenses.length == 1 ? 'expense' : 'expenses'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 96),
            itemCount: expenses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ExpenseTile(
                expense: expense,
                onTap: () => showExpenseFormSheet(context, expense: expense),
                onDelete: () => _confirmDelete(context, ref, expense),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Expense expense,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = ref.read(expenseFormControllerProvider);
    final failure = await controller.delete(expense.id);

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          failure ?? '"${expense.title}" deleted',
        ),
      ),
    );
  }
}
