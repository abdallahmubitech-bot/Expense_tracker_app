import 'package:expense_tracker/features/expenses/data/models/category_model.dart';
import 'package:expense_tracker/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker/features/expenses/domain/entities/expense.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const Category category = Category(
    id: 'food',
    name: 'Food',
    iconKey: 'restaurant',
    colorValue: 0xFFFF7043,
  );

  final Expense expense = Expense(
    id: 'expense-1',
    title: 'Lunch',
    amount: 12.5,
    date: DateTime(2025, 11, 3, 13, 30),
    category: category,
    note: 'Team lunch',
  );

  group('ExpenseModel mapping', () {
    test('round trips through the domain entity', () {
      final model = ExpenseModel.fromEntity(expense);
      final restored = model.toEntity();

      expect(restored.id, expense.id);
      expect(restored.title, expense.title);
      expect(restored.amount, expense.amount);
      expect(restored.date, expense.date);
      expect(restored.note, expense.note);
      expect(restored.category, expense.category);
    });

    test('keeps a null note null', () {
      final withoutNote = expense.copyWith();
      final model = ExpenseModel.fromEntity(
        Expense(
          id: withoutNote.id,
          title: withoutNote.title,
          amount: withoutNote.amount,
          date: withoutNote.date,
          category: withoutNote.category,
        ),
      );

      expect(model.toEntity().note, isNull);
    });

    test('assigns the stable Hive type ids', () {
      expect(ExpenseModelAdapter().typeId, 0);
      expect(CategoryModelAdapter().typeId, 1);
    });

    test('adapters implement the equality contract Hive expects', () {
      final first = ExpenseModelAdapter();
      final second = ExpenseModelAdapter();

      expect(first, equals(second));
      expect(first.hashCode, second.hashCode);
      expect(first == CategoryModelAdapter(), isFalse);
    });
  });
}
