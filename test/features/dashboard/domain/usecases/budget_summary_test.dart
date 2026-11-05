import 'package:expense_tracker/core/utils/result.dart';
import 'package:expense_tracker/features/dashboard/domain/entities/budget_summary.dart';
import 'package:expense_tracker/features/dashboard/domain/usecases/get_budget_summary.dart';
import 'package:expense_tracker/features/dashboard/domain/usecases/get_category_totals.dart';
import 'package:expense_tracker/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../expenses/domain/usecases/fake_expense_repository.dart';

const Category food = Category(
  id: 'food',
  name: 'Food',
  iconKey: 'restaurant',
  colorValue: 0xFFFF7043,
);

const Category travel = Category(
  id: 'travel',
  name: 'Travel',
  iconKey: 'travel',
  colorValue: 0xFF29B6F6,
);

Expense expense({
  required String id,
  required double amount,
  required Category category,
  required DateTime date,
}) {
  return Expense(
    id: id,
    title: 'Item $id',
    amount: amount,
    date: date,
    category: category,
  );
}

void main() {
  late FakeExpenseRepository repository;

  setUp(() {
    repository = FakeExpenseRepository(<Expense>[
      expense(
        id: '1',
        amount: 20,
        category: food,
        date: DateTime(2025, 11, 2),
      ),
      expense(
        id: '2',
        amount: 30,
        category: food,
        date: DateTime(2025, 11, 2),
      ),
      expense(
        id: '3',
        amount: 100,
        category: travel,
        date: DateTime(2025, 11, 9),
      ),
      expense(
        id: '4',
        amount: 999,
        category: travel,
        date: DateTime(2025, 10, 9),
      ),
    ]);
  });

  tearDown(() => repository.dispose());

  group('GetBudgetSummary', () {
    test('aggregates only the requested month', () async {
      final result = await GetBudgetSummary(repository)(
        month: DateTime(2025, 11),
        monthlyBudget: 500,
      );

      final summary = result.valueOrNull!;
      expect(summary.totalSpent, 150);
      expect(summary.expenseCount, 3);
      expect(summary.monthlyBudget, 500);
      expect(summary.remaining, 350);
      expect(summary.averageExpense, 50);
    });

    test('sorts category totals descending', () async {
      final result = await GetBudgetSummary(repository)(
        month: DateTime(2025, 11),
      );

      final totals = result.valueOrNull!.categoryTotals;
      expect(totals.first.category.id, 'travel');
      expect(totals.first.total, 100);
      expect(totals.last.category.id, 'food');
      expect(totals.last.total, 50);
      expect(totals.last.count, 2);
    });

    test('groups daily totals by day of month', () async {
      final result = await GetBudgetSummary(repository)(
        month: DateTime(2025, 11),
      );

      final daily = result.valueOrNull!.dailyTotals;
      expect(daily[2], 50);
      expect(daily[9], 100);
      expect(result.valueOrNull!.busiestDay, 9);
    });

    test('computes budget usage clamped to one', () async {
      final result = await GetBudgetSummary(repository)(
        month: DateTime(2025, 11),
        monthlyBudget: 100,
      );

      final summary = result.valueOrNull!;
      expect(summary.budgetUsage, 1);
      expect(summary.isOverBudget, isTrue);
      expect(summary.remaining, -50);
    });

    test('returns an empty summary for a quiet month', () async {
      final result = await GetBudgetSummary(repository)(
        month: DateTime(2025, 1),
      );

      final summary = result.valueOrNull!;
      expect(summary, isA<BudgetSummary>());
      expect(summary.totalSpent, 0);
      expect(summary.expenseCount, 0);
      expect(summary.categoryTotals, isEmpty);
      expect(summary.busiestDay, isNull);
    });
  });

  group('GetCategoryTotals', () {
    test('returns one entry per category', () async {
      final result = await GetCategoryTotals(repository)(
        DateTime(2025, 11),
      );

      expect(result, isA<Success<List<CategoryTotal>>>());
      final totals = result.valueOrNull!;
      expect(totals.length, 2);
      expect(totals.first.total, 100);
    });
  });
}
