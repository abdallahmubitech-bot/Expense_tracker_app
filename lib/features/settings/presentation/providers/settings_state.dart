import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// User preferences that survive restarts.
class SettingsState extends Equatable {
  const SettingsState({
    required this.themeMode,
    this.monthlyBudget,
  });

  /// The initial settings used before Hive provides stored values.
  static const SettingsState initial = SettingsState(
    themeMode: ThemeMode.system,
  );

  /// Light, dark or system theme.
  final ThemeMode themeMode;

  /// Optional monthly spending limit.
  final double? monthlyBudget;

  /// Returns a copy with the given fields replaced.
  SettingsState copyWith({
    ThemeMode? themeMode,
    Object? monthlyBudget = _sentinel,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      monthlyBudget: identical(monthlyBudget, _sentinel)
          ? this.monthlyBudget
          : monthlyBudget as double?,
    );
  }

  @override
  List<Object?> get props => <Object?>[themeMode, monthlyBudget];
}

/// Distinguishes "not provided" from an explicit null.
const Object _sentinel = Object();
