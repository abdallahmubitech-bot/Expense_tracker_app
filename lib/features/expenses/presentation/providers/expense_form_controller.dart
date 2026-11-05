import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import 'use_case_providers.dart';

part 'expense_form_controller.g.dart';

/// Outcome of a save attempt so the UI can show the right message.
sealed class SaveOutcome {
  const SaveOutcome();
}

/// The expense was persisted.
final class SaveSuccess extends SaveOutcome {
  const SaveSuccess(this.expense);

  /// The stored expense.
  final Expense expense;
}

/// The expense could not be persisted.
final class SaveError extends SaveOutcome {
  const SaveError(this.message);

  /// Reason shown to the user.
  final String message;
}

/// Handles create and update operations for the expense form.
@Riverpod(keepAlive: true)
class ExpenseFormController extends _$ExpenseFormController {
  @override
  void build() {}

  /// Creates a new expense.
  Future<SaveOutcome> create({
    required String title,
    required double amount,
    required DateTime date,
    required Category category,
    String? note,
  }) async {
    final expense = Expense(
      id: _generateId(),
      title: title.trim(),
      amount: amount,
      date: date,
      category: category,
      note: _normaliseNote(note),
    );

    final result = await ref.read(addExpenseProvider)(expense);
    final failure = result.failureOrNull;
    if (failure != null) return SaveError(failure.message);

    return SaveSuccess(result.valueOrNull ?? expense);
  }

  /// Updates an existing expense.
  Future<SaveOutcome> update(Expense expense) async {
    final result = await ref.read(updateExpenseProvider)(expense);
    final failure = result.failureOrNull;
    if (failure != null) return SaveError(failure.message);

    return SaveSuccess(result.valueOrNull ?? expense);
  }

  /// Removes an expense and reports the error message when it fails.
  Future<String?> delete(String id) async {
    final result = await ref.read(deleteExpenseProvider)(id);
    return result.failureOrNull?.message;
  }

  String _generateId() {
    final now = DateTime.now();
    final salt = now.millisecondsSinceEpoch ^ now.microsecondsSinceEpoch;
    return '${now.microsecondsSinceEpoch}-${salt.toRadixString(16)}';
  }

  String? _normaliseNote(String? note) {
    final trimmed = note?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
