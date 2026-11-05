import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/category_visuals.dart';
import '../../../expenses/domain/entities/category.dart';

/// Collects the name, icon and colour of a new custom category.
///
/// Returns null when the user cancels.
Future<Category?> showCategoryDialog(BuildContext context) {
  return showDialog<Category>(
    context: context,
    builder: (_) => const _CategoryDialog(),
  );
}

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog();

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _iconKey = CategoryVisuals.selectableIconKeys.first;
  Color _color = AppColors.categoryPalette.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSave = _nameController.text.trim().isNotEmpty;

    return AlertDialog(
      title: const Text('New category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _nameController,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Pet care',
              ),
            ),
            const SizedBox(height: 20),
            Text('Icon', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                for (final key in CategoryVisuals.selectableIconKeys)
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _iconKey = key),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: key == _iconKey
                            ? _color.withValues(alpha: 0.2)
                            : theme.colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: key == _iconKey
                              ? _color
                              : theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: Icon(
                        CategoryVisuals.iconFor(key),
                        size: 20,
                        color: key == _iconKey
                            ? _color
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Colour', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                for (final color in AppColors.categoryPalette)
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => setState(() => _color = color),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color == _color
                              ? theme.colorScheme.onSurface
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: color == _color
                          ? const Icon(
                              Icons.check_rounded,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: canSave
              ? () {
                  Navigator.of(context).pop(
                    Category(
                      id: 'custom-${DateTime.now().microsecondsSinceEpoch}',
                      name: _nameController.text.trim(),
                      iconKey: _iconKey,
                      colorValue: _color.value,
                      isCustom: true,
                    ),
                  );
                }
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
