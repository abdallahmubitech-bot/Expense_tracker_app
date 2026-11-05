import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/use_case.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/// Loads the expenses recorded inside a single calendar month.
class GetExpensesForMonth implements UseCase {
  const GetExpensesForMonth(this._repository);

  final ExpenseRepository _repository;

  @override
  String get name => 'GetExpensesForMonth';

  /// Executes the use case for the month containing [month].
  Future<Result<List<Expense>>> call(DateTime month) async {
    try {
      final expenses = await _repository.getExpenses();
      final filtered = expenses
          .where((expense) => expense.isInMonth(month.year, month.month))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      return Success<List<Expense>>(filtered);
    } on Exception catch (error) {
      return Error<List<Expense>>(
        StorageFailure('Could not load monthly expenses: $error'),
      );
    }
  }
}
