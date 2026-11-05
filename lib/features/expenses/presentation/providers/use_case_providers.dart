import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/usecases/categories/add_category.dart';
import '../../domain/usecases/categories/delete_category.dart';
import '../../domain/usecases/categories/get_categories.dart';
import '../../domain/usecases/categories/watch_categories.dart';
import '../../domain/usecases/expenses/add_expense.dart';
import '../../domain/usecases/expenses/delete_expense.dart';
import '../../domain/usecases/expenses/get_expense_by_id.dart';
import '../../domain/usecases/expenses/get_expenses.dart';
import '../../domain/usecases/expenses/get_expenses_for_month.dart';
import '../../domain/usecases/expenses/update_expense.dart';
import '../../domain/usecases/expenses/watch_expenses.dart';
import 'repository_providers.dart';

part 'use_case_providers.g.dart';

// ---------------------------------------------------------------------------
// Expense use cases.
// ---------------------------------------------------------------------------

/// Provides [GetExpenses].
@Riverpod(keepAlive: true)
GetExpenses getExpenses(Ref ref) => GetExpenses(ref.watch(expenseRepositoryProvider));

/// Provides [WatchExpenses].
@Riverpod(keepAlive: true)
WatchExpenses watchExpenses(Ref ref) =>
    WatchExpenses(ref.watch(expenseRepositoryProvider));

/// Provides [GetExpenseById].
@Riverpod(keepAlive: true)
GetExpenseById getExpenseById(Ref ref) =>
    GetExpenseById(ref.watch(expenseRepositoryProvider));

/// Provides [GetExpensesForMonth].
@Riverpod(keepAlive: true)
GetExpensesForMonth getExpensesForMonth(Ref ref) =>
    GetExpensesForMonth(ref.watch(expenseRepositoryProvider));

/// Provides [AddExpense].
@Riverpod(keepAlive: true)
AddExpense addExpense(Ref ref) => AddExpense(ref.watch(expenseRepositoryProvider));

/// Provides [UpdateExpense].
@Riverpod(keepAlive: true)
UpdateExpense updateExpense(Ref ref) =>
    UpdateExpense(ref.watch(expenseRepositoryProvider));

/// Provides [DeleteExpense].
@Riverpod(keepAlive: true)
DeleteExpense deleteExpense(Ref ref) =>
    DeleteExpense(ref.watch(expenseRepositoryProvider));

// ---------------------------------------------------------------------------
// Category use cases.
// ---------------------------------------------------------------------------

/// Provides [GetCategories].
@Riverpod(keepAlive: true)
GetCategories getCategories(Ref ref) =>
    GetCategories(ref.watch(categoryRepositoryProvider));

/// Provides [WatchCategories].
@Riverpod(keepAlive: true)
WatchCategories watchCategories(Ref ref) =>
    WatchCategories(ref.watch(categoryRepositoryProvider));

/// Provides [AddCategory].
@Riverpod(keepAlive: true)
AddCategory addCategory(Ref ref) => AddCategory(ref.watch(categoryRepositoryProvider));

/// Provides [DeleteCategory].
@Riverpod(keepAlive: true)
DeleteCategory deleteCategory(Ref ref) =>
    DeleteCategory(ref.watch(categoryRepositoryProvider));
