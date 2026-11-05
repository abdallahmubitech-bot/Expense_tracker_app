import 'package:expense_tracker/core/error/failure.dart';
import 'package:expense_tracker/core/utils/result.dart';
import 'package:expense_tracker/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/expenses/add_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/expenses/delete_expense.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/expenses/get_expenses.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/expenses/get_expenses_for_month.dart';
import 'package:expense_tracker/features/expenses/domain/usecases/expenses/update_expense.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_expense_repository.dart';

const Category food = Category(
  id: 'food',
  name: 'Food',
  iconKey: 'restaurant',
  colorValue: 0xFFFF7043,
);

Expense buildExpense({
  String id = 'e1',
  String title = 'Lunch',
  double amount = 12.5,
  DateTime? date,
  Category category = food,
}) {
  return Expense(
    id: id,
    title: title,
    amount: amount,
    date: date ?? DateTime(2025, 11, 3, 12),
    category: category,
  );
}

void main() {
  late FakeExpenseRepository repository;

  setUp(() => repository = FakeExpenseRepository());
  tearDown(() => repository.dispose());

  group('GetExpenses', () {
    test('returns expenses sorted by date descending', () async {
      repository = FakeExpenseRepository(<Expense>[
        buildExpense(id: 'a', date: DateTime(2025, 11, 1)),
        buildExpense(id: 'b', date: DateTime(2025, 11, 5)),
      ]);
      final result = await GetExpenses(repository)();

      expect(result, isA<Success<List<Expense>>>());
      final ids = result.valueOrNull!.map((expense) => expense.id).toList();
      expect(ids, <String>['b', 'a']);
    });

    test('maps storage exceptions to StorageFailure', () async {
      repository.failOnRead = true;
      final result = await GetExpenses(repository)();

      expect(result.failureOrNull, isA<StorageFailure>());
    });
  });

  group('AddExpense', () {
    test('persists a valid expense', () async {
      final result = await AddExpense(repository)(buildExpense());

      expect(result.isSuccess, isTrue);
      expect(repository.saveCalls, 1);
    });

    test('rejects an empty title', () async {
      final result = await AddExpense(repository)(buildExpense(title: '   '));

      expect(result.failureOrNull, isA<ValidationFailure>());
      expect(repository.saveCalls, 0);
    });

    test('rejects a non positive amount', () async {
      final result = await AddExpense(repository)(buildExpense(amount: 0));

      expect(result.failureOrNull, isA<ValidationFailure>());
    });

    test('rejects a date far in the future', () async {
      final future = DateTime.now().add(const Duration(days: 10));
      final result = await AddExpense(repository)(
        buildExpense(date: future),
      );

      expect(result.failureOrNull, isA<ValidationFailure>());
    });
  });

  group('UpdateExpense', () {
    test('updates an existing expense', () async {
      repository = FakeExpenseRepository(<Expense>[buildExpense()]);
      final updated = buildExpense(amount: 99);

      final result = await UpdateExpense(repository)(updated);

      expect(result.isSuccess, isTrue);
      expect((await repository.getExpenseById('e1'))!.amount, 99);
    });

    test('fails when the expense is gone', () async {
      final result = await UpdateExpense(repository)(buildExpense());

      expect(result.failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('DeleteExpense', () {
    test('removes an existing expense', () async {
      repository = FakeExpenseRepository(<Expense>[buildExpense()]);

      final result = await DeleteExpense(repository)('e1');

      expect(result.isSuccess, isTrue);
      expect(repository.deleteCalls, 1);
    });

    test('fails for an unknown id', () async {
      final result = await DeleteExpense(repository)('missing');

      expect(result.failureOrNull, isA<NotFoundFailure>());
    });
  });

  group('GetExpensesForMonth', () {
    test('keeps only expenses inside the requested month', () async {
      repository = FakeExpenseRepository(<Expense>[
        buildExpense(id: 'oct', date: DateTime(2025, 10, 31)),
        buildExpense(id: 'nov', date: DateTime(2025, 11, 2)),
        buildExpense(id: 'dec', date: DateTime(2025, 12, 1)),
      ]);

      final result = await GetExpensesForMonth(repository)(
        DateTime(2025, 11),
      );

      expect(result.valueOrNull!.map((e) => e.id), <String>['nov']);
    });
  });
}
