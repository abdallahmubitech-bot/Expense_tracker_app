/// Names of the Hive boxes opened by the app.
///
/// Kept in one place so data sources and the bootstrap code cannot drift.
abstract final class HiveBoxNames {
  /// Box holding [ExpenseModel] values.
  static const String expenses = 'expenses_box';

  /// Box holding [CategoryModel] values.
  static const String categories = 'categories_box';

  /// Box holding settings primitives.
  static const String settings = 'settings_box';
}
