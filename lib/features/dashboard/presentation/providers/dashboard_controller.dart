import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../settings/presentation/providers/settings_controller.dart';
import '../../domain/entities/budget_summary.dart';
import 'dashboard_use_case_providers.dart';
import 'selected_month_provider.dart';

part 'dashboard_controller.g.dart';

/// Builds the budget summary for the month selected in the dashboard.
@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<BudgetSummary> build() {
    final month = ref.watch(selectedMonthProvider);
    final budget =
        ref.watch(settingsControllerProvider).valueOrNull?.monthlyBudget;

    return _load(month, budget);
  }

  Future<BudgetSummary> _load(DateTime month, double? budget) async {
    final result = await ref.read(getBudgetSummaryProvider)(
      month: month,
      monthlyBudget: budget,
    );

    final failure = result.failureOrNull;
    if (failure != null) throw failure;

    return result.valueOrNull ??
        BudgetSummary.empty(month, monthlyBudget: budget);
  }

  /// Reloads the current month, keeping the existing value on screen.
  Future<void> refresh() async {
    final month = ref.read(selectedMonthProvider);
    final budget =
        ref.read(settingsControllerProvider).valueOrNull?.monthlyBudget;

    final result = await _load(month, budget);
    state = AsyncValue<BudgetSummary>.data(result);
  }
}
