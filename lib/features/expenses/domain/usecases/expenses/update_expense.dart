import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/use_case.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/// Validates and writes changes to an existing expense.
class UpdateExpense implements UseCase {
  const UpdateExpense(this._repository);

  final ExpenseRepository _repository;

  @override
  String get name => 'UpdateExpense';

  /// Executes the use case.
  Future<Result<Expense>> call(Expense expense) async {
    final validationError = _validate(expense);
    if (validationError != null) {
      return Error<Expense>(ValidationFailure(validationError));
    }

    try {
      final existing = await _repository.getExpenseById(expense.id);
      if (existing == null) {
        return Error<Expense>(
          NotFoundFailure('The expense no longer exists.'),
        );
      }
      await _repository.saveExpense(expense);
      return Success<Expense>(expense);
    } on Exception catch (error) {
      return Error<Expense>(
        StorageFailure('Could not update the expense: $error'),
      );
    }
  }

  /// Returns an error message, or null when the expense is valid.
  String? _validate(Expense expense) {
    if (expense.title.trim().isEmpty) {
      return 'Please give the expense a title.';
    }
    if (expense.amount <= 0) {
      return 'The amount has to be greater than zero.';
    }
    if (!expense.amount.isFinite) {
      return 'The amount has to be a finite number.';
    }
    return null;
  }
}
