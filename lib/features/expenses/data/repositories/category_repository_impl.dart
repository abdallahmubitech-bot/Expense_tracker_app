import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../models/category_model.dart';

/// Maps [CategoryLocalDataSource] results onto the domain contract.
class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._localDataSource);

  final CategoryLocalDataSource _localDataSource;

  @override
  Future<List<Category>> getCategories() async {
    final models = await _localDataSource.getAll();
    if (models.isEmpty) return const <Category>[];
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Stream<List<Category>> watchCategories() {
    return _localDataSource.watchAll().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    final model = await _localDataSource.getById(id);
    return model?.toEntity();
  }

  @override
  Future<void> saveCategory(Category category) {
    return _localDataSource.put(CategoryModel.fromEntity(category));
  }

  @override
  Future<void> deleteCategory(String id) => _localDataSource.delete(id);
}
