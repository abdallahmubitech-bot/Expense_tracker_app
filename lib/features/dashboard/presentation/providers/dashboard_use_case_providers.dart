import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../expenses/presentation/providers/repository_providers.dart';
import '../../domain/usecases/get_budget_summary.dart';
import '../../domain/usecases/get_category_totals.dart';

part 'dashboard_use_case_providers.g.dart';

/// Provides [GetBudgetSummary].
@Riverpod(keepAlive: true)
GetBudgetSummary getBudgetSummary(Ref ref) =>
    GetBudgetSummary(ref.watch(expenseRepositoryProvider));

/// Provides [GetCategoryTotals].
@Riverpod(keepAlive: true)
GetCategoryTotals getCategoryTotals(Ref ref) =>
    GetCategoryTotals(ref.watch(expenseRepositoryProvider));
