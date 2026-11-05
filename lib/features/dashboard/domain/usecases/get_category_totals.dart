import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/utils/use_case.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../entities/budget_summary.dart';

/// Aggregates spending per category for the month containing [month].
class GetCategoryTotals implements UseCase {
  const GetCategoryTotals(this._repository);

  final ExpenseRepository _repository;

  @override
  String get name => 'GetCategoryTotals';

  /// Executes the use case.
  Future<Result<List<CategoryTotal>>> call(DateTime month) async {
    try {
      final expenses = await _repository.getExpenses();
      final totals = <String, CategoryTotal>{};

      for (final expense in expenses.where(
        (Expense item) => item.isInMonth(month.year, month.month),
      )) {
        final current = totals[expense.category.id];
        totals[expense.category.id] = CategoryTotal(
          category: expense.category,
          total: (current?.total ?? 0) + expense.amount,
          count: (current?.count ?? 0) + 1,
        );
      }

      final sorted = totals.values.toList()
        ..sort((a, b) => b.total.compareTo(a.total));
      return Success<List<CategoryTotal>>(sorted);
    } on Exception catch (error) {
      return Error<List<CategoryTotal>>(
        StorageFailure('Could not calculate category totals: $error'),
      );
    }
  }
}
