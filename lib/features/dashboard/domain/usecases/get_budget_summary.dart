import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/use_case.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../entities/budget_summary.dart';

/// Builds the dashboard summary for one month.
class GetBudgetSummary implements UseCase {
  const GetBudgetSummary(this._repository);

  final ExpenseRepository _repository;

  @override
  String get name => 'GetBudgetSummary';

  /// Executes the use case for the month containing [month].
  Future<Result<BudgetSummary>> call({
    required DateTime month,
    double? monthlyBudget,
  }) async {
    try {
      final expenses = await _repository.getExpenses();
      final monthly = expenses
          .where((expense) => expense.isInMonth(month.year, month.month))
          .toList();

      if (monthly.isEmpty) {
        return Success<BudgetSummary>(
          BudgetSummary.empty(month, monthlyBudget: monthlyBudget),
        );
      }

      var totalSpent = 0.0;
      final categoryTotals = <String, CategoryTotal>{};
      final dailyTotals = <int, double>{};

      for (final expense in monthly) {
        totalSpent += expense.amount;
        dailyTotals.update(
          expense.date.day,
          (value) => value + expense.amount,
          ifAbsent: () => expense.amount,
        );

        final current = categoryTotals[expense.category.id];
        categoryTotals[expense.category.id] = CategoryTotal(
          category: expense.category,
          total: (current?.total ?? 0) + expense.amount,
          count: (current?.count ?? 0) + 1,
        );
      }

      final sortedCategories = categoryTotals.values.toList()
        ..sort((a, b) => b.total.compareTo(a.total));

      return Success<BudgetSummary>(
        BudgetSummary(
          month: DateTime(month.year, month.month),
          totalSpent: totalSpent,
          expenseCount: monthly.length,
          categoryTotals: sortedCategories,
          dailyTotals: Map<int, double>.unmodifiable(dailyTotals),
          monthlyBudget: monthlyBudget,
        ),
      );
    } on Exception catch (error) {
      return Error<BudgetSummary>(
        StorageFailure('Could not build the budget summary: $error'),
      );
    }
  }
}
