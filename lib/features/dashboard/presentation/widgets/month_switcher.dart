import 'package:flutter/material.dart';

import '../../../../core/utils/formatters.dart';

/// Arrow based month navigation with a reset shortcut.
class MonthSwitcher extends StatelessWidget {
  const MonthSwitcher({
    required this.month,
    required this.onPrevious,
    required this.onNext,
    required this.onReset,
    required this.canGoForward,
    super.key,
  });

  /// Month currently displayed, expected on the first day.
  final DateTime month;

  /// Moves one month back.
  final VoidCallback onPrevious;

  /// Moves one month forward.
  final VoidCallback? onNext;

  /// Jumps back to the current month.
  final VoidCallback onReset;

  /// False when the next month would be in the future.
  final bool canGoForward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: <Widget>[
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
          tooltip: 'Previous month',
        ),
        Expanded(
          child: InkWell(
            onTap: onReset,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: <Widget>[
                  Text(
                    Formatters.monthYear(month),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    canGoForward ? 'Jump to this month' : 'Current month',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: canGoForward ? onNext : null,
          icon: const Icon(Icons.chevron_right_rounded),
          tooltip: 'Next month',
          disabledColor: theme.colorScheme.onPrimary.withValues(alpha: 0.35),
          color: theme.colorScheme.onPrimary,
        ),
      ],
    );
  }
}
