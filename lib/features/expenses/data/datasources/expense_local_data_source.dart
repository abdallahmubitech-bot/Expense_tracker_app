import '../models/expense_model.dart';

/// Local storage contract for expenses.
///
/// The concrete implementation uses Hive; tests can swap in a fake.
abstract interface class ExpenseLocalDataSource {
  /// Returns every stored expense model.
  Future<List<ExpenseModel>> getAll();

  /// Emits the full list whenever the box changes.
  Stream<List<ExpenseModel>> watchAll();

  /// Returns the model with [id], or null when absent.
  Future<ExpenseModel?> getById(String id);

  /// Adds or replaces [model], keyed by its id.
  Future<void> put(ExpenseModel model);

  /// Deletes the model with [id].
  Future<void> delete(String id);

  /// Removes every stored expense.
  Future<void> clear();
}
