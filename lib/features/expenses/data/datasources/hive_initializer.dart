import 'package:hive_ce/hive_ce.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../../../core/constants/default_categories.dart';
import '../models/category_model.dart';
import '../models/expense_model.dart';
import 'hive_box_names.dart';

/// Opens every Hive box the app needs and seeds default data.
///
/// Runs once during bootstrap, before the first frame.
abstract final class HiveInitializer {
  /// Initialises Hive, registers adapters, opens boxes and seeds categories.
  static Future<void> initialize() async {
    await Hive.initFlutter();
    _registerAdapters();

    await Future.wait<void>(<Future<void>>[
      Hive.openBox<ExpenseModel>(HiveBoxNames.expenses),
      Hive.openBox<CategoryModel>(HiveBoxNames.categories),
      Hive.openBox<dynamic>(HiveBoxNames.settings),
    ]);

    await _seedDefaultCategories();
  }

  /// Registers the generated type adapters exactly once.
  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter<ExpenseModel>(ExpenseModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter<CategoryModel>(CategoryModelAdapter());
    }
  }

  /// Writes the built-in categories on first launch only.
  static Future<void> _seedDefaultCategories() async {
    final box = Hive.box<CategoryModel>(HiveBoxNames.categories);
    if (box.isNotEmpty) return;

    await box.putAll(<String, CategoryModel>{
      for (final category in DefaultCategories.all)
        category.id: CategoryModel.fromEntity(category),
    });
  }
}
