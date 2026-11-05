import 'package:hive_ce/hive_ce.dart';

import '../../domain/entities/category.dart';

part 'category_model.g.dart';

/// Persisted representation of [Category].
///
/// Inflates to and from the domain entity so Hive never leaks upward.
@HiveType(typeId: 1)
class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorValue,
    this.isCustom = false,
  });

  /// Builds a model from a domain entity.
  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      iconKey: category.iconKey,
      colorValue: category.colorValue,
      isCustom: category.isCustom,
    );
  }

  /// Unique identifier and Hive key.
  @HiveField(0)
  final String id;

  /// Display label.
  @HiveField(1)
  final String name;

  /// Icon lookup key used by the presentation layer.
  @HiveField(2)
  final String iconKey;

  /// ARGB colour value.
  @HiveField(3)
  final int colorValue;

  /// True when the user created this category.
  @HiveField(4, defaultValue: false)
  final bool isCustom;

  /// Converts this model back into a domain entity.
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      iconKey: iconKey,
      colorValue: colorValue,
      isCustom: isCustom,
    );
  }
}
