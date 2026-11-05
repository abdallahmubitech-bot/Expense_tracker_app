import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/use_case.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/// Loads a single expense by identifier.
class GetExpenseById implements UseCase {
  const GetExpenseById(this._repository);

  final ExpenseRepository _repository;

  @override
  String get name => 'GetExpenseById';

  /// Executes the use case.
  Future<Result<Expense>> call(String id) async {
    try {
      final expense = await _repository.getExpenseById(id);
      if (expense == null) {
        return Error<Expense>(
          NotFoundFailure('No expense found for id "$id".'),
        );
      }
      return Success<Expense>(expense);
    } on Exception catch (error) {
      return Error<Expense>(
        StorageFailure('Could not load the expense: $error'),
      );
    }
  }
}
