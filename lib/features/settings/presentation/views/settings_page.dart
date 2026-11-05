import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../dashboard/presentation/providers/dashboard_controller.dart';
import '../../../expenses/presentation/providers/category_list_controller.dart';
import '../../../expenses/presentation/widgets/category_avatar.dart';
import '../providers/settings_controller.dart';
import '../widgets/appearance_selector.dart';
import '../widgets/budget_dialog.dart';
import '../widgets/category_dialog.dart';

/// Preferences, monthly budget and custom category management.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final categories = ref.watch(categoryListControllerProvider).valueOrNull ??
        const [];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
          children: <Widget>[
            Text('Appearance', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            AppearanceSelector(
              themeMode: settings.themeMode,
              onChanged: (mode) =>
                  ref.read(settingsControllerProvider.notifier).setThemeMode(mode),
            ),
            const SizedBox(height: 28),
            Text('Budget', style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.savings_rounded,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Monthly budget'),
                subtitle: Text(
                  settings.monthlyBudget == null
                      ? 'No limit set'
                      : Formatters.currency(settings.monthlyBudget!),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final budget = await showBudgetDialog(
                    context,
                    initialValue: settings.monthlyBudget,
                  );
                  if (budget == null) return;
                  await ref
                      .read(settingsControllerProvider.notifier)
                      .setMonthlyBudget(budget.value);
                  ref.invalidate(dashboardControllerProvider);
                },
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Categories', style: theme.textTheme.titleMedium),
                ),
                TextButton.icon(
                  onPressed: () => _addCategory(context, ref),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Card(
              child: Column(
                children: <Widget>[
                  for (final category in categories)
                    ListTile(
                      leading: CategoryAvatar(category: category, size: 38),
                      title: Text(category.name),
                      subtitle: Text(
                        category.isCustom ? 'Custom category' : 'Default category',
                      ),
                      trailing: category.isCustom
                          ? IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Icons.delete_outline_rounded),
                              onPressed: () => ref
                                  .read(categoryListControllerProvider.notifier)
                                  .remove(category.id),
                            )
                          : null,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'SpendWise 1.0.0',
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final category = await showCategoryDialog(context);
    if (category == null) return;

    final failure = await ref
        .read(categoryListControllerProvider.notifier)
        .add(category);

    if (failure != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure)),
      );
    }
  }
}
