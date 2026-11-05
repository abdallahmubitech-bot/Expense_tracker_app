import 'package:flutter/material.dart';

import '../features/expenses/presentation/views/expense_form_page.dart';
import 'home_shell.dart';

/// Route names and the route table for the app.
abstract final class AppRoutes {
  /// The dashboard shell.
  static const String home = '/';

  /// Create a new expense.
  static const String addExpense = '/expenses/new';

  /// Edit an existing expense; expects an expense id as argument.
  static const String editExpense = '/expenses/edit';

  /// Route table consumed by [MaterialApp].
  static final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
    home: (_) => const HomeShell(),
    addExpense: (_) => const ExpenseFormPage(),
    editExpense: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      return ExpenseFormPage(expenseId: arguments is String ? arguments : null);
    },
  };
}
