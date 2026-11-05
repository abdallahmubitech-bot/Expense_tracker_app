import 'package:flutter/material.dart';

import '../../../../core/utils/category_visuals.dart';
import '../../domain/entities/category.dart';

/// Horizontally scrollable single-choice category selector.
class CategoryChipSelector extends StatelessWidget {
  const CategoryChipSelector({
    required this.categories,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Categories offered to the user.
  final List<Category> categories;

  /// Currently selected category.
  final Category? selected;

  /// Invoked with the newly selected category.
  final ValueChanged<Category> onSelected;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selected?.id;
          final base = CategoryVisuals.colorFor(category.colorValue);

          return ChoiceChip(
            selected: isSelected,
            onSelected: (_) => onSelected(category),
            showCheckmark: false,
            avatar: Icon(
              CategoryVisuals.iconFor(category.iconKey),
              size: 18,
              color: isSelected ? Colors.white : base,
            ),
            label: Text(category.name),
            labelStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            selectedColor: base,
            backgroundColor: CategoryVisuals.container(base, brightness),
            side: BorderSide(color: base.withValues(alpha: 0.4)),
          );
        },
      ),
    );
  }
}
