import 'package:equatable/equatable.dart';

import 'category.dart';

/// A single expense recorded by the user.
///
/// This is a pure domain object: no Hive, no Flutter.
class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
  });

  /// Unique identifier and Hive key.
  final String id;

  /// Short description, for example "Weekly groceries".
  final String title;

  /// Absolute spending amount. Always positive.
  final double amount;

  /// The moment the money was spent.
  final DateTime date;

  /// Category this expense belongs to.
  final Category category;

  /// Optional free-text note.
  final String? note;

  /// Returns a copy with the given fields replaced.
  Expense copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? date,
    Category? category,
    String? note,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      note: note ?? this.note,
    );
  }

  /// True when the expense was recorded within the given month.
  bool isInMonth(int year, int month) =>
      date.year == year && date.month == month;

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        amount,
        date,
        category,
        note,
      ];
}
