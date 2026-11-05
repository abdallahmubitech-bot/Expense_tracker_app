import '../entities/category.dart';

/// Contract for category persistence.
///
/// Implemented by the data layer, consumed by domain use cases.
abstract interface class CategoryRepository {
  /// Returns every available category.
  Future<List<Category>> getCategories();

  /// Streams the category list whenever the underlying store changes.
  Stream<List<Category>> watchCategories();

  /// Returns the category with [id], or null when it does not exist.
  Future<Category?> getCategoryById(String id);

  /// Persists a new category or replaces the existing one with the same id.
  Future<void> saveCategory(Category category);

  /// Deletes the category with [id].
  Future<void> deleteCategory(String id);
}
