import '../entities/expense.dart';

/// Contract for expense persistence.
///
/// Implemented by the data layer, consumed by domain use cases.
abstract interface class ExpenseRepository {
  /// Returns every stored expense, newest first.
  Future<List<Expense>> getExpenses();

  /// Streams the expense list whenever the underlying store changes.
  Stream<List<Expense>> watchExpenses();

  /// Returns the expense with [id], or null when it does not exist.
  Future<Expense?> getExpenseById(String id);

  /// Persists a new expense or replaces the existing one with the same id.
  Future<void> saveExpense(Expense expense);

  /// Deletes the expense with [id].
  Future<void> deleteExpense(String id);
}
