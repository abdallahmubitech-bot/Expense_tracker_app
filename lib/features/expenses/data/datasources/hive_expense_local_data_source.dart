import 'package:hive_ce/hive_ce.dart';

import '../models/expense_model.dart';
import 'expense_local_data_source.dart';
import 'hive_box_names.dart';

/// Hive backed implementation of [ExpenseLocalDataSource].
class HiveExpenseLocalDataSource implements ExpenseLocalDataSource {
  const HiveExpenseLocalDataSource();

  Box<ExpenseModel> get _box => Hive.box<ExpenseModel>(HiveBoxNames.expenses);

  @override
  Future<List<ExpenseModel>> getAll() async => _box.values.toList();

  @override
  Stream<List<ExpenseModel>> watchAll() async* {
    yield _box.values.toList();
    yield* _box.watch().map((_) => _box.values.toList());
  }

  @override
  Future<ExpenseModel?> getById(String id) async => _box.get(id);

  @override
  Future<void> put(ExpenseModel model) => _box.put(model.id, model);

  @override
  Future<void> delete(String id) => _box.delete(id);

  @override
  Future<void> clear() => _box.clear();
}
