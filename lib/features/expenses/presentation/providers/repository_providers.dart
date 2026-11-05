import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import 'data_sources_provider.dart';

part 'repository_providers.g.dart';

/// Provides the expense repository implementation.
@Riverpod(keepAlive: true)
ExpenseRepository expenseRepository(Ref ref) {
  return ExpenseRepositoryImpl(ref.watch(expenseLocalDataSourceProvider));
}

/// Provides the category repository implementation.
@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(ref.watch(categoryLocalDataSourceProvider));
}
