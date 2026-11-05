import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/entities/budget_summary.dart';
import '../providers/dashboard_controller.dart';
import '../providers/selected_month_provider.dart';
import '../widgets/budget_overview_card.dart';
import '../widgets/category_breakdown_list.dart';
import '../widgets/month_switcher.dart';
import '../widgets/spending_bar_chart.dart';

/// Budget dashboard: totals, category split and daily rhythm.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardControllerProvider);
    final month = ref.watch(selectedMonthProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => <Widget>[
          SliverAppBar(
            expandedHeight: 148,
            pinned: true,
            title: const Text('SpendWise'),
            flexibleSpace: FlexibleSpaceBar(
              background: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MonthSwitcher(
                    month: month,
                    canGoForward: _canGoForward(month),
                    onPrevious: () =>
                        ref.read(selectedMonthProvider.notifier).shift(-1),
                    onNext: () =>
                        ref.read(selectedMonthProvider.notifier).shift(1),
                    onReset: () =>
                        ref.read(selectedMonthProvider.notifier).reset(),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: switch (summaryAsync) {
          AsyncError(:final error) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(dashboardControllerProvider),
            ),
          AsyncValue(:final value?) => _DashboardBody(summary: value),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }

  bool _canGoForward(DateTime month) {
    final now = DateTime.now();
    final current = DateTime(now.year, now.month);
    return month.isBefore(current);
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.summary});

  final BudgetSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardControllerProvider.notifier).refresh(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
        children: <Widget>[
          BudgetOverviewCard(summary: summary),
          const SizedBox(height: 24),
          if (summary.expenseCount == 0)
            EmptyState(
              icon: Icons.pie_chart_outline_rounded,
              title: 'Nothing recorded in ${Formatters.monthYear(summary.month)}',
              message: 'Add an expense to see how your money is split.',
            )
          else ...<Widget>[
            SectionHeader(
              title: 'Spending by category',
              subtitle: '${summary.categoryTotals.length} active '
                  '${summary.categoryTotals.length == 1 ? 'category' : 'categories'}',
            ),
            CategoryBreakdownList(
              totals: summary.categoryTotals,
              totalSpent: summary.totalSpent,
            ),
            const SizedBox(height: 8),
            SectionHeader(
              title: 'Daily rhythm',
              subtitle: 'How the month unfolded day by day',
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SpendingBarChart(
                  dailyTotals: summary.dailyTotals,
                  month: summary.month,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SectionHeader(title: 'At a glance'),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: <Widget>[
                    _StatRow(
                      icon: Icons.calendar_month_rounded,
                      label: 'Average per expense',
                      value: Formatters.currency(summary.averageExpense),
                    ),
                    Divider(height: 1, color: theme.colorScheme.outlineVariant),
                    _StatRow(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Highest day',
                      value: summary.busiestDay == null
                          ? '—'
                          : '${summary.busiestDay}/${summary.month.month}',
                    ),
                    Divider(height: 1, color: theme.colorScheme.outlineVariant),
                    _StatRow(
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Budget',
                      value: summary.monthlyBudget == null
                          ? 'Not set'
                          : Formatters.currency(summary.monthlyBudget!),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      dense: true,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.bodyMedium),
      trailing: Text(
        value,
        style: theme.textTheme.titleSmall,
      ),
    );
  }
}
