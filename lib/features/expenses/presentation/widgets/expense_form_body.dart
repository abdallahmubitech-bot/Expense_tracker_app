import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/expense.dart';
import '../providers/category_list_controller.dart';
import 'amount_field.dart';
import 'expense_form_values.dart';
import 'category_chip_selector.dart';

/// Reusable form used by both the sheet and the full screen page.
class ExpenseFormBody extends ConsumerStatefulWidget {
  const ExpenseFormBody({
    this.expense,
    required this.onSubmit,
    required this.submitting,
    super.key,
  });

  /// Existing expense when editing, null when creating.
  final Expense? expense;

  /// Invoked with the validated values.
  final ValueChanged<ExpenseFormValues> onSubmit;

  /// Disables the primary button while a save is running.
  final bool submitting;

  @override
  ConsumerState<ExpenseFormBody> createState() => _ExpenseFormBodyState();
}

class _ExpenseFormBodyState extends ConsumerState<ExpenseFormBody> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _noteController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late DateTime _date;
  Category? _category;
  bool _initialisedCategory = false;

  @override
  void initState() {
    super.initState();
    final expense = widget.expense;
    _titleController = TextEditingController(text: expense?.title ?? '');
    _amountController = TextEditingController(
      text: expense == null
          ? ''
          : expense.amount.toStringAsFixed(2),
    );
    _noteController = TextEditingController(text: expense?.note ?? '');
    _date = expense?.date ?? DateTime.now();
    _category = expense?.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListControllerProvider);
    final categories = categoriesAsync.valueOrNull ?? const <Category>[];

    if (!_initialisedCategory && categories.isNotEmpty) {
      _initialisedCategory = true;
      _category ??= categories.first;
    }

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AmountField(
            controller: _amountController,
            currencySymbol: '\$',
            validator: _validateAmount,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _titleController,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Coffee with a friend',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please give the expense a title.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _DateSelector(
            date: _date,
            onChanged: (date) => setState(() => _date = date),
          ),
          const SizedBox(height: 20),
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          if (categories.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: LinearProgressIndicator(),
            )
          else
            CategoryChipSelector(
              categories: categories,
              selected: _category,
              onSelected: (category) => setState(() => _category = category),
            ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _noteController,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Note (optional)',
              hintText: 'Anything worth remembering',
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: widget.submitting ? null : _submit,
              child: widget.submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(widget.expense == null ? 'Add expense' : 'Save changes'),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateAmount(String? value) {
    final parsed = double.tryParse(value?.trim() ?? '');
    if (parsed == null) return 'Enter an amount.';
    if (parsed <= 0) return 'The amount has to be greater than zero.';
    return null;
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    final category = _category;
    if (!isValid || category == null) return;

    widget.onSubmit(
      ExpenseFormValues(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        date: _date,
        category: category,
        note: _noteController.text,
      ),
    );
  }
}

/// Tap target that opens the Material date picker.
class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.date, required this.onChanged});

  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          helpText: 'Select expense date',
        );
        if (picked != null) {
          onChanged(
            DateTime(
              picked.year,
              picked.month,
              picked.day,
              date.hour,
              date.minute,
            ),
          );
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Date'),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Text(
              '${Formatters.fullDate(date)} · ${Formatters.time(date)}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
