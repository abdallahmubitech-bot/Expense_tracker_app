import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/default_categories.dart';
import '../../domain/entities/category.dart';
import 'use_case_providers.dart';

part 'category_list_controller.g.dart';

/// Streams the categories and lets the user manage custom ones.
@riverpod
class CategoryListController extends _$CategoryListController {
  @override
  Stream<List<Category>> build() {
    return ref.watch(watchCategoriesProvider)().map((categories) {
      if (categories.isEmpty) return DefaultCategories.all;
      return categories;
    });
  }

  /// Creates a custom category and reports the error message when it fails.
  Future<String?> add(Category category) async {
    final result = await ref.read(addCategoryProvider)(category);
    return result.failureOrNull?.message;
  }

  /// Deletes a custom category and reports the error message when it fails.
  Future<String?> remove(String id) async {
    final result = await ref.read(deleteCategoryProvider)(id);
    return result.failureOrNull?.message;
  }
}
