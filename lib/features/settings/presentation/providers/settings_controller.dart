import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../expenses/data/datasources/hive_box_names.dart';
import 'settings_state.dart';

part 'settings_controller.g.dart';

/// Reads and writes user preferences in the settings box.
@Riverpod(keepAlive: true)
class SettingsController extends _$SettingsController {
  static const String _themeKey = 'themeMode';
  static const String _budgetKey = 'monthlyBudget';

  Box<dynamic> get _box => Hive.box<dynamic>(HiveBoxNames.settings);

  @override
  SettingsState build() {
    return SettingsState(
      themeMode: _readThemeMode(),
      monthlyBudget: _readBudget(),
    );
  }

  /// Cycles between system, light and dark mode.
  Future<void> setThemeMode(ThemeMode mode) async {
    await _box.put(_themeKey, mode.name);
    state = state.copyWith(themeMode: mode);
  }

  /// Stores a monthly budget; pass null to clear it.
  Future<void> setMonthlyBudget(double? budget) async {
    if (budget == null) {
      await _box.delete(_budgetKey);
    } else {
      await _box.put(_budgetKey, budget);
    }
    state = state.copyWith(monthlyBudget: budget);
  }

  ThemeMode _readThemeMode() {
    final stored = _box.get(_themeKey);
    if (stored is! String) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  double? _readBudget() {
    final stored = _box.get(_budgetKey);
    return stored is num ? stored.toDouble() : null;
  }
}
