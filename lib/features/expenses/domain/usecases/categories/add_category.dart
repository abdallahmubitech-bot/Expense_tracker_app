import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/use_case.dart';
import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

/// Validates and stores a new custom category.
class AddCategory implements UseCase {
  const AddCategory(this._repository);

  final CategoryRepository _repository;

  @override
  String get name => 'AddCategory';

  /// Executes the use case.
  Future<Result<Category>> call(Category category) async {
    if (category.name.trim().isEmpty) {
      return const Error<Category>(
        ValidationFailure('Please give the category a name.'),
      );
    }

    try {
      final existing = await _repository.getCategories();
      final duplicate = existing.any(
        (item) => item.name.toLowerCase() == category.name.toLowerCase(),
      );
      if (duplicate) {
        return Error<Category>(
          ValidationFailure('"${category.name}" already exists.'),
        );
      }
      await _repository.saveCategory(
        category.copyWith(isCustom: true),
      );
      return Success<Category>(category);
    } on Exception catch (error) {
      return Error<Category>(
        StorageFailure('Could not save the category: $error'),
      );
    }
  }
}
