import 'package:hive_ce/hive_ce.dart';

import '../../domain/entities/expense.dart';
import 'category_model.dart';

part 'expense_model.g.dart';

/// Persisted representation of [Expense].
///
/// Stores the category inline so a single box read is enough to rebuild
/// the full domain object.
@HiveType(typeId: 0)
class ExpenseModel {
  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
  });

  /// Builds a model from a domain entity.
  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      date: expense.date,
      category: CategoryModel.fromEntity(expense.category),
      note: expense.note,
    );
  }

  /// Unique identifier and Hive key.
  @HiveField(0)
  final String id;

  /// Short description.
  @HiveField(1)
  final String title;

  /// Absolute amount spent.
  @HiveField(2)
  final double amount;

  /// Moment the money was spent.
  @HiveField(3)
  final DateTime date;

  /// Category snapshot for this expense.
  @HiveField(4)
  final CategoryModel category;

  /// Optional free-text note.
  @HiveField(5)
  final String? note;

  /// Converts this model back into a domain entity.
  Expense toEntity() {
    return Expense(
      id: id,
      title: title,
      amount: amount,
      date: date,
      category: category.toEntity(),
      note: note,
    );
  }
}
