import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// Dependency free bar chart of daily spending for the selected month.
class SpendingBarChart extends StatelessWidget {
  const SpendingBarChart({
    required this.dailyTotals,
    required this.month,
    super.key,
  });

  /// Amount spent per day of month.
  final Map<int, double> dailyTotals;

  /// Any date inside the rendered month.
  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final peak = dailyTotals.values.fold<double>(0, (max, value) {
      return value > max ? value : max;
    });
    final busiest = _busiestDay();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 132,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              for (var day = 1; day <= daysInMonth; day++)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: _Bar(
                      heightFactor: peak <= 0
                          ? 0
                          : (dailyTotals[day] ?? 0) / peak,
                      isHighlighted: day == busiest,
                      color: theme.colorScheme.primary,
                      highlightColor: theme.colorScheme.secondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                'Day 1',
                style: theme.textTheme.labelSmall,
              ),
            ),
            Text(
              'Day $daysInMonth',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
        if (busiest != null) ...<Widget>[
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Icon(
                Icons.local_fire_department_rounded,
                size: 16,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Highest day: ${busiest} ${Formatters.monthYear(month)} '
                  '(${Formatters.currency(dailyTotals[busiest] ?? 0)})',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  int? _busiestDay() {
    if (dailyTotals.isEmpty) return null;
    var day = dailyTotals.keys.first;
    for (final entry in dailyTotals.entries) {
      if (entry.value > (dailyTotals[day] ?? 0)) day = entry.key;
    }
    return day;
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.heightFactor,
    required this.isHighlighted,
    required this.color,
    required this.highlightColor,
  });

  final double heightFactor;
  final bool isHighlighted;
  final Color color;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    final clamped = heightFactor.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final height = (maxHeight * clamped).clamp(3.0, maxHeight);

        return Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: height,
            decoration: BoxDecoration(
              color: isHighlighted ? highlightColor : color.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      },
    );
  }
}
