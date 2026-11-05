import '../../../../../core/utils/use_case.dart';
import '../../entities/category.dart';
import '../../repositories/category_repository.dart';

/// Streams the category list whenever the local store changes.
class WatchCategories implements UseCase {
  const WatchCategories(this._repository);

  final CategoryRepository _repository;

  @override
  String get name => 'WatchCategories';

  /// Executes the use case.
  Stream<List<Category>> call() => _repository.watchCategories();
}
