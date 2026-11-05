import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dashboard/presentation/views/dashboard_page.dart';
import '../features/expenses/presentation/views/expense_form_sheet.dart';
import '../features/expenses/presentation/views/expense_list_page.dart';
import '../features/settings/presentation/views/settings_page.dart';

/// Bottom navigation shell hosting the three top level tabs.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  static const List<Widget> _pages = <Widget>[
    DashboardPage(),
    ExpenseListPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: _index == 2
          ? null
          : FloatingActionButton(
              onPressed: _openQuickAdd,
              tooltip: 'Add expense',
              child: const Icon(Icons.add_rounded),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Expenses',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Future<void> _openQuickAdd() async {
    final saved = await showExpenseFormSheet(context);
    if (!mounted || !saved) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Expense saved')),
    );
  }
}
