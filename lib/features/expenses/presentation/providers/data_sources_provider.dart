import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/category_local_data_source.dart';
import '../../data/datasources/expense_local_data_source.dart';
import '../../data/datasources/hive_category_local_data_source.dart';
import '../../data/datasources/hive_expense_local_data_source.dart';

part 'data_sources_provider.g.dart';

/// Provides the Hive backed expense data source.
@Riverpod(keepAlive: true)
ExpenseLocalDataSource expenseLocalDataSource(Ref ref) {
  return const HiveExpenseLocalDataSource();
}

/// Provides the Hive backed category data source.
@Riverpod(keepAlive: true)
CategoryLocalDataSource categoryLocalDataSource(Ref ref) {
  return const HiveCategoryLocalDataSource();
}
