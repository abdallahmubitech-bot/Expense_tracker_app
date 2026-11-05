import 'dart:async';

import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker/features/expenses/domain/repositories/expense_repository.dart';

/// In-memory [ExpenseRepository] used by the use case tests.
class FakeExpenseRepository implements ExpenseRepository {
  FakeExpenseRepository([List<Expense>? seed])
      : _expenses = <String, Expense>{
          for (final expense in seed ?? const <Expense>[]) expense.id: expense,
        };

  final Map<String, Expense> _expenses;
  final StreamController<List<Expense>> _controller =
      StreamController<List<Expense>>.broadcast();

  /// Number of times [saveExpense] was called.
  int saveCalls = 0;

  /// Number of times [deleteExpense] was called.
  int deleteCalls = 0;

  /// When true every read throws, simulating a broken box.
  bool failOnRead = false;

  List<Expense> get _values => _expenses.values.toList();

  @override
  Future<void> saveExpense(Expense expense) async {
    saveCalls++;
    _expenses[expense.id] = expense;
    _controller.add(_values);
  }

  @override
  Future<void> deleteExpense(String id) async {
    deleteCalls++;
    _expenses.remove(id);
    _controller.add(_values);
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    if (failOnRead) throw Exception('box closed');
    return _expenses[id];
  }

  @override
  Future<List<Expense>> getExpenses() async {
    if (failOnRead) throw Exception('box closed');
    return _values;
  }

  @override
  Stream<List<Expense>> watchExpenses() async* {
    yield _values;
    yield* _controller.stream;
  }

  /// Releases the stream controller.
  Future<void> dispose() => _controller.close();
}
