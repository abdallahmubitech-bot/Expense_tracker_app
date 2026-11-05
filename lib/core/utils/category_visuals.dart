import 'package:flutter/material.dart';

import '../constants/default_categories.dart';

/// Maps persisted category metadata onto concrete icons and colours.
///
/// The domain only stores string keys and integers, so the UI decides how a
/// category looks.
abstract final class CategoryVisuals {
  static const Map<String, IconData> _icons = <String, IconData>{
    'restaurant': Icons.restaurant_rounded,
    'groceries': Icons.shopping_basket_rounded,
    'transport': Icons.directions_bus_rounded,
    'shopping': Icons.shopping_bag_rounded,
    'bills': Icons.receipt_long_rounded,
    'health': Icons.favorite_rounded,
    'entertainment': Icons.movie_rounded,
    'education': Icons.menu_book_rounded,
    'travel': Icons.flight_takeoff_rounded,
    'other': Icons.category_rounded,
    'savings': Icons.savings_rounded,
    'gift': Icons.card_giftcard_rounded,
    'pets': Icons.pets_rounded,
    'fitness': Icons.fitness_center_rounded,
    'coffee': Icons.local_cafe_rounded,
    'home': Icons.home_rounded,
    'phone': Icons.smartphone_rounded,
    'car': Icons.directions_car_rounded,
  };

  /// Icons offered when creating a custom category.
  static const List<String> selectableIconKeys = <String>[
    'restaurant',
    'groceries',
    'transport',
    'shopping',
    'bills',
    'health',
    'entertainment',
    'education',
    'travel',
    'savings',
    'gift',
    'pets',
    'fitness',
    'coffee',
    'home',
    'phone',
    'car',
    'other',
  ];

  /// Resolves an icon key to an [IconData], falling back to a neutral icon.
  static IconData iconFor(String iconKey) =>
      _icons[iconKey] ?? Icons.category_rounded;

  /// Resolves a stored colour value to a [Color].
  static Color colorFor(int colorValue) => Color(colorValue);

  /// Returns a readable foreground colour for the given background.
  static Color foregroundFor(Color background) {
    return background.computeLuminance() > 0.55
        ? const Color(0xFF212121)
        : Colors.white;
  }

  /// Tints a base colour so category containers stay readable in both modes.
  static Color container(Color base, Brightness brightness) {
    final opacity = brightness == Brightness.dark ? 0.24 : 0.14;
    return base.withValues(alpha: opacity);
  }

  /// Colour used for the "Other" bucket.
  static Color get fallbackColor => Color(DefaultCategories.otherColor);
}
