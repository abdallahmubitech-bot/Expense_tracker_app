import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/use_case.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/// Loads every stored expense, newest first.
class GetExpenses implements UseCase {
  const GetExpenses(this._repository);

  final ExpenseRepository _repository;

  @override
  String get name => 'GetExpenses';

  /// Executes the use case.
  Future<Result<List<Expense>>> call() async {
    try {
      final expenses = await _repository.getExpenses();
      final sorted = List<Expense>.of(expenses)
        ..sort((a, b) => b.date.compareTo(a.date));
      return Success<List<Expense>>(sorted);
    } on Exception catch (error) {
      return Error<List<Expense>>(
        StorageFailure('Could not load expenses: $error'),
      );
    }
  }
}
