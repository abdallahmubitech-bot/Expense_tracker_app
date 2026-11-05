import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/expense.dart';
import 'use_case_providers.dart';

part 'expense_list_controller.g.dart';

/// Exposes the stream of expenses and the mutations the UI can trigger.
///
/// Every write goes through a use case; the stream then pushes the new list.
@riverpod
class ExpenseListController extends _$ExpenseListController {
  @override
  Stream<List<Expense>> build() {
    return ref.watch(watchExpensesProvider)();
  }

  /// Deletes [id] and returns an error message when the write failed.
  Future<String?> delete(String id) async {
    final result = await ref.read(deleteExpenseProvider)(id);
    return result.failureOrNull?.message;
  }
}
