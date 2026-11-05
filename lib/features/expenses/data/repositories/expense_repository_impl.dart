import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_data_source.dart';
import '../models/expense_model.dart';

/// Maps [ExpenseLocalDataSource] results onto the domain contract.
class ExpenseRepositoryImpl implements ExpenseRepository {
  const ExpenseRepositoryImpl(this._localDataSource);

  final ExpenseLocalDataSource _localDataSource;

  @override
  Future<List<Expense>> getExpenses() async {
    final models = await _localDataSource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Stream<List<Expense>> watchExpenses() {
    return _localDataSource.watchAll().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    final model = await _localDataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveExpense(Expense expense) {
    return _localDataSource.put(ExpenseModel.fromEntity(expense));
  }

  @override
  Future<void> deleteExpense(String id) => _localDataSource.delete(id);
}
