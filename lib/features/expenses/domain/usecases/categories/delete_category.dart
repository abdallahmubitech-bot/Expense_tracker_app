import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/use_case.dart';
import '../../repositories/category_repository.dart';

/// Removes a custom category that is no longer needed.
class DeleteCategory implements UseCase {
  const DeleteCategory(this._repository);

  final CategoryRepository _repository;

  @override
  String get name => 'DeleteCategory';

  /// Executes the use case.
  Future<Result<void>> call(String id) async {
    try {
      final category = await _repository.getCategoryById(id);
      if (category == null) {
        return const Error<void>(
          NotFoundFailure('The category no longer exists.'),
        );
      }
      if (!category.isCustom) {
        return const Error<void>(
          ValidationFailure('Default categories cannot be removed.'),
        );
      }
      await _repository.deleteCategory(id);
      return const Success<void>(null);
    } on Exception catch (error) {
      return Error<void>(
        StorageFailure('Could not delete the category: $error'),
      );
    }
  }
}
