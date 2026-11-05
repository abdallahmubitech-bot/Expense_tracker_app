import 'package:flutter/material.dart';

import '../../../../core/utils/category_visuals.dart';
import '../../domain/entities/category.dart';

/// Circular icon badge tinted with the category colour.
class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    required this.category,
    this.size = 44,
    super.key,
  });

  /// Category whose colour and icon are rendered.
  final Category category;

  /// Diameter of the badge.
  final double size;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final base = CategoryVisuals.colorFor(category.colorValue);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: CategoryVisuals.container(base, brightness),
        shape: BoxShape.circle,
      ),
      child: Icon(
        CategoryVisuals.iconFor(category.iconKey),
        size: size * 0.5,
        color: base,
      ),
    );
  }
}
