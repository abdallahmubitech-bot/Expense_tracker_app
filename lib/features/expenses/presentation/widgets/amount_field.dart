import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Large numeric input tailored for money entry.
class AmountField extends StatelessWidget {
  const AmountField({
    required this.controller,
    required this.currencySymbol,
    this.validator,
    super.key,
  });

  /// Text controller owned by the form.
  final TextEditingController controller;

  /// Symbol rendered before the number.
  final String currencySymbol;

  /// Optional validator.
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: 'Amount',
        hintText: '0.00',
        prefixText: '$currencySymbol ',
        prefixStyle: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.primary,
        ),
      ),
      validator: validator,
    );
  }
}
