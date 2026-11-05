import '../../domain/entities/category.dart';

/// Validated values collected by the expense form.
class ExpenseFormValues {
  const ExpenseFormValues({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
  });

  /// Short description entered by the user.
  final String title;

  /// Positive amount entered by the user.
  final double amount;

  /// Selected expense date.
  final DateTime date;

  /// Selected category.
  final Category category;

  /// Optional note.
  final String? note;
}
