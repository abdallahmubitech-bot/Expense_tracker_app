import 'package:equatable/equatable.dart';

import '../../../expenses/domain/entities/category.dart';

/// Spending total for one category.
class CategoryTotal extends Equatable {
  const CategoryTotal({
    required this.category,
    required this.total,
    required this.count,
  });

  /// The category these totals belong to.
  final Category category;

  /// Sum of all expense amounts in the category.
  final double total;

  /// Number of expenses in the category.
  final int count;

  @override
  List<Object?> get props => <Object?>[category, total, count];
}

/// Immutable dashboard summary aggregated from the expense list.
class BudgetSummary extends Equatable {
  const BudgetSummary({
    required this.month,
    required this.totalSpent,
    required this.expenseCount,
    required this.categoryTotals,
    required this.dailyTotals,
    this.monthlyBudget,
  });

  /// Any date inside the aggregated month.
  final DateTime month;

  /// Total spent inside the month.
  final double totalSpent;

  /// Number of expenses inside the month.
  final int expenseCount;

  /// Per-category totals, sorted by amount descending.
  final List<CategoryTotal> categoryTotals;

  /// Per-day totals keyed by day of month.
  final Map<int, double> dailyTotals;

  /// Optional monthly budget, used to compute the remaining balance.
  final double? monthlyBudget;

  /// An empty summary for the given month.
  factory BudgetSummary.empty(DateTime month, {double? monthlyBudget}) {
    return BudgetSummary(
      month: DateTime(month.year, month.month),
      totalSpent: 0,
      expenseCount: 0,
      categoryTotals: const <CategoryTotal>[],
      dailyTotals: const <int, double>{},
      monthlyBudget: monthlyBudget,
    );
  }

  /// Budget minus spending. Null when no budget is configured.
  double? get remaining {
    final budget = monthlyBudget;
    return budget == null ? null : budget - totalSpent;
  }

  /// Share of the budget already spent, clamped between 0 and 1.
  double get budgetUsage {
    final budget = monthlyBudget;
    if (budget == null || budget <= 0) return 0;
    final usage = totalSpent / budget;
    if (usage < 0) return 0;
    if (usage > 1) return 1;
    return usage;
  }

  /// True when spending exceeds the configured budget.
  bool get isOverBudget => remaining != null && remaining! < 0;

  /// Average spending per recorded expense.
  double get averageExpense => expenseCount == 0 ? 0 : totalSpent / expenseCount;

  /// Day of the month with the highest spending, if any.
  int? get busiestDay {
    if (dailyTotals.isEmpty) return null;
    var busiest = dailyTotals.keys.first;
    for (final entry in dailyTotals.entries) {
      if (entry.value > dailyTotals[busiest]!) busiest = entry.key;
    }
    return busiest;
  }

  @override
  List<Object?> get props => <Object?>[
        month,
        totalSpent,
        expenseCount,
        categoryTotals,
        dailyTotals,
        monthlyBudget,
      ];
}
