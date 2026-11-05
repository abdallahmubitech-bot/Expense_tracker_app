import 'package:hive_ce/hive_ce.dart';

import '../models/category_model.dart';
import 'category_local_data_source.dart';
import 'hive_box_names.dart';

/// Hive backed implementation of [CategoryLocalDataSource].
class HiveCategoryLocalDataSource implements CategoryLocalDataSource {
  const HiveCategoryLocalDataSource();

  Box<CategoryModel> get _box =>
      Hive.box<CategoryModel>(HiveBoxNames.categories);

  @override
  Future<List<CategoryModel>> getAll() async => _box.values.toList();

  @override
  Stream<List<CategoryModel>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<CategoryModel?> getById(String id) async => _box.get(id);

  @override
  Future<void> put(CategoryModel model) => _box.put(model.id, model);

  @override
  Future<void> putAll(Iterable<CategoryModel> models) {
    return _box.putAll(<String, CategoryModel>{
      for (final model in models) model.id: model,
    });
  }

  @override
  Future<void> delete(String id) => _box.delete(id);

  @override
  Future<bool> get isEmpty async => _box.isEmpty;
}
