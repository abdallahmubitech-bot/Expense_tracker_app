import '../../features/expenses/domain/entities/category.dart';

/// Predefined spending categories shipped with the app.
///
/// The identifiers are persisted, so they must never change.
abstract final class DefaultCategories {
  /// Colour palette reused by the seed data and the category pickers.
  static const int foodColor = 0xFFFF7043;
  static const int transportColor = 0xFF42A5F5;
  static const int shoppingColor = 0xFFAB47BC;
  static const int billsColor = 0xFF26A69A;
  static const int healthColor = 0xFFEF5350;
  static const int entertainmentColor = 0xFF7E57C2;
  static const int educationColor = 0xFF5C6BC0;
  static const int travelColor = 0xFF29B6F6;
  static const int groceriesColor = 0xFF66BB6A;
  static const int otherColor = 0xFF9E9E9E;

  /// All categories every fresh install starts with.
  static const List<Category> all = <Category>[
    Category(
      id: 'food',
      name: 'Food & Dining',
      iconKey: 'restaurant',
      colorValue: foodColor,
    ),
    Category(
      id: 'groceries',
      name: 'Groceries',
      iconKey: 'groceries',
      colorValue: groceriesColor,
    ),
    Category(
      id: 'transport',
      name: 'Transport',
      iconKey: 'transport',
      colorValue: transportColor,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      iconKey: 'shopping',
      colorValue: shoppingColor,
    ),
    Category(
      id: 'bills',
      name: 'Bills & Utilities',
      iconKey: 'bills',
      colorValue: billsColor,
    ),
    Category(
      id: 'health',
      name: 'Health',
      iconKey: 'health',
      colorValue: healthColor,
    ),
    Category(
      id: 'entertainment',
      name: 'Entertainment',
      iconKey: 'entertainment',
      colorValue: entertainmentColor,
    ),
    Category(
      id: 'education',
      name: 'Education',
      iconKey: 'education',
      colorValue: educationColor,
    ),
    Category(
      id: 'travel',
      name: 'Travel',
      iconKey: 'travel',
      colorValue: travelColor,
    ),
    Category(
      id: 'other',
      name: 'Other',
      iconKey: 'other',
      colorValue: otherColor,
    ),
  ];

  /// The fallback category used when nothing else matches.
  static const Category fallback = Category(
    id: 'other',
    name: 'Other',
    iconKey: 'other',
    colorValue: otherColor,
  );
}
