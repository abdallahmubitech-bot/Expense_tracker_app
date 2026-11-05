import 'package:flutter/material.dart';

import '../../../../core/utils/category_visuals.dart';
import '../../../../core/utils/formatters.dart';
import '../../../expenses/presentation/widgets/category_avatar.dart';
import '../../domain/entities/budget_summary.dart';

/// Ranked list of category totals with proportional bars.
class CategoryBreakdownList extends StatelessWidget {
  const CategoryBreakdownList({
    required this.totals,
    required this.totalSpent,
    super.key,
  });

  /// Per-category totals sorted by amount.
  final List<CategoryTotal> totals;

  /// Month total used to compute each share.
  final double totalSpent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        for (final total in totals)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: <Widget>[
                CategoryAvatar(category: total.category, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              total.category.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          Text(
                            Formatters.currency(total.total),
                            style: theme.textTheme.titleSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          minHeight: 6,
                          value: totalSpent <= 0
                              ? 0
                              : (total.total / totalSpent).clamp(0, 1),
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            CategoryVisuals.colorFor(total.category.colorValue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${total.count} '
                        '${total.count == 1 ? 'expense' : 'expenses'} · '
                        '${Formatters.percent(
                          totalSpent <= 0 ? 0 : total.total / totalSpent,
                        )}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
