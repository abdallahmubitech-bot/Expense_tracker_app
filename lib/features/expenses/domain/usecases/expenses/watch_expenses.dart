import '../../../../../core/utils/use_case.dart';
import '../../entities/expense.dart';
import '../../repositories/expense_repository.dart';

/// Streams the expense list whenever the local store changes.
class WatchExpenses implements UseCase {
  const WatchExpenses(this._repository);

  final ExpenseRepository _repository;

  @override
  String get name => 'WatchExpenses';

  /// Executes the use case.
  Stream<List<Expense>> call() {
    return _repository.watchExpenses().map((expenses) {
      return List<Expense>.of(expenses)
        ..sort((a, b) => b.date.compareTo(a.date));
    });
  }
}
