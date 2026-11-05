import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:expense_tracker/shared/widgets/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EmptyState renders its copy and action', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No expenses yet',
            message: 'Tap the plus button to record your first expense.',
            action: FilledButton(
              onPressed: () => tapped = true,
              child: const Text('Add expense'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('No expenses yet'), findsOneWidget);
    expect(
      find.text('Tap the plus button to record your first expense.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Add expense'));
    expect(tapped, isTrue);
  });
}
