import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Result of the budget dialog: either a new amount or an explicit clear.
class BudgetDialogResult {
  const BudgetDialogResult(this.value);

  /// The new budget, null when the user cleared it.
  final double? value;
}

/// Prompts the user for a monthly budget.
///
/// Returns null when the dialog is dismissed without saving.
Future<BudgetDialogResult?> showBudgetDialog(
  BuildContext context, {
  double? initialValue,
}) {
  return showDialog<BudgetDialogResult>(
    context: context,
    builder: (_) => _BudgetDialog(initialValue: initialValue),
  );
}

class _BudgetDialog extends StatefulWidget {
  const _BudgetDialog({this.initialValue});

  final double? initialValue;

  @override
  State<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<_BudgetDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue?.toStringAsFixed(2) ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Monthly budget'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Set a limit to track how much of your budget is left each month.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: '\$ ',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(
            const BudgetDialogResult(null),
          ),
          child: const Text('Clear'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final parsed = double.tryParse(_controller.text.trim());
            Navigator.of(context).pop(BudgetDialogResult(parsed));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
