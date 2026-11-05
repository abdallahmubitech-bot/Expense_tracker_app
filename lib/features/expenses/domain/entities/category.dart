import 'package:equatable/equatable.dart';

/// A spending category that expenses can be grouped under.
///
/// Lives in the domain layer and has no knowledge of persistence.
class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorValue,
    this.isCustom = false,
  });

  /// Stable identifier used as the Hive key.
  final String id;

  /// Human readable label shown in the UI.
  final String name;

  /// Key that the presentation layer maps to a concrete [IconData].
  final String iconKey;

  /// ARGB colour value used for charts and chips.
  final int colorValue;

  /// True when the user created this category.
  final bool isCustom;

  /// Returns a copy with the given fields replaced.
  Category copyWith({
    String? id,
    String? name,
    String? iconKey,
    int? colorValue,
    bool? isCustom,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => <Object?>[id, name, iconKey, colorValue, isCustom];
}
