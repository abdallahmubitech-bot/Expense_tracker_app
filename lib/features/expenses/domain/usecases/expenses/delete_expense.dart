import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/use_case.dart';
import '../../repositories/expense_repository.dart';

/// Removes a stored expense.
class DeleteExpense implements UseCase {
  const DeleteExpense(this._repository);

  final ExpenseRepository _repository;

  @override
  String get name => 'DeleteExpense';

  /// Executes the use case.
  Future<Result<void>> call(String id) async {
    try {
      final existing = await _repository.getExpenseById(id);
      if (existing == null) {
        return const Error<void>(
          NotFoundFailure('The expense no longer exists.'),
        );
      }
      await _repository.deleteExpense(id);
      return const Success<void>(null);
    } on Exception catch (error) {
      return Error<void>(
        StorageFailure('Could not delete the expense: $error'),
      );
    }
  }
}
