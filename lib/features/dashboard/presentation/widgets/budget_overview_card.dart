import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/budget_summary.dart';

/// Headline card showing month spending against the optional budget.
class BudgetOverviewCard extends StatelessWidget {
  const BudgetOverviewCard({required this.summary, super.key});

  /// Aggregated data rendered by the card.
  final BudgetSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = summary.remaining;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Spent this month',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                  ),
                ),
              ),
              _Badge(
                label: summary.isOverBudget ? 'Over budget' : 'On track',
                icon: summary.isOverBudget
                    ? Icons.trending_up_rounded
                    : Icons.verified_rounded,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            Formatters.currency(summary.totalSpent),
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${summary.expenseCount} '
            '${summary.expenseCount == 1 ? 'expense' : 'expenses'} · '
            'avg ${Formatters.currency(summary.averageExpense)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
            ),
          ),
          if (summary.monthlyBudget != null) ...<Widget>[
            const SizedBox(height: 18),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: summary.budgetUsage,
                minHeight: 10,
                backgroundColor:
                    theme.colorScheme.onPrimary.withValues(alpha: 0.22),
                valueColor: AlwaysStoppedAnimation<Color>(
                  summary.isOverBudget
                      ? theme.colorScheme.error
                      : theme.colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${Formatters.percent(summary.budgetUsage)} of '
                    '${Formatters.currency(summary.monthlyBudget!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                Text(
                  remaining == null
                      ? ''
                      : remaining < 0
                          ? '${Formatters.currency(remaining.abs())} over'
                          : '${Formatters.currency(remaining)} left',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: theme.colorScheme.onPrimary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
