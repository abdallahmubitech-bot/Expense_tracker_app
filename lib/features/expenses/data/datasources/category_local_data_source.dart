import '../models/category_model.dart';

/// Local storage contract for categories.
///
/// The concrete implementation uses Hive; tests can swap in a fake.
abstract interface class CategoryLocalDataSource {
  /// Returns every stored category model.
  Future<List<CategoryModel>> getAll();

  /// Emits the full list whenever the box changes.
  Stream<List<CategoryModel>> watchAll();

  /// Returns the model with [id], or null when absent.
  Future<CategoryModel?> getById(String id);

  /// Adds or replaces [model], keyed by its id.
  Future<void> put(CategoryModel model);

  /// Adds or replaces several models at once.
  Future<void> putAll(Iterable<CategoryModel> models);

  /// Deletes the model with [id].
  Future<void> delete(String id);

  /// True when at least one category is stored.
  Future<bool> get isEmpty;
}
