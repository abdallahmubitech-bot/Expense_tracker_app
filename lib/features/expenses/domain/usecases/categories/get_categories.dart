import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/utils/use_case.dart';
import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

/// Loads every available spending category.
class GetCategories implements UseCase {
  const GetCategories(this._repository);

  final CategoryRepository _repository;

  @override
  String get name => 'GetCategories';

  /// Executes the use case.
  Future<Result<List<Category>>> call() async {
    try {
      final categories = await _repository.getCategories();
      return Success<List<Category>>(categories);
    } on Exception catch (error) {
      return Error<List<Category>>(
        StorageFailure('Could not load categories: $error'),
      );
    }
  }
}
