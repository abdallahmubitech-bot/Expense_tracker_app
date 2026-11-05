import 'package:expense_tracker/core/theme/app_colors.dart';
import 'package:expense_tracker/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('matches the specified palette exactly', () {
      expect(AppColors.primary, const Color(0xFF9C27B0));
      expect(AppColors.primaryLight, const Color(0xFFE1BEE7));
      expect(AppColors.primaryDark, const Color(0xFF7B1FA2));
      expect(AppColors.secondary, const Color(0xFFE040FB));
      expect(AppColors.textPrimary, const Color(0xFF212121));
      expect(AppColors.textSecondary, const Color(0xFF757575));
      expect(AppColors.divider, const Color(0xFFBDBDBD));
      expect(AppColors.onPrimary, const Color(0xFFFFFFFF));
    });
  });

  group('AppTheme', () {
    test('light theme uses the brand palette', () {
      final theme = AppTheme.light;

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.colorScheme.onPrimary, AppColors.onPrimary);
      expect(theme.colorScheme.onSurface, AppColors.textPrimary);
      expect(theme.colorScheme.outline, AppColors.divider);
      expect(theme.scaffoldBackgroundColor, AppColors.surfaceLight);
    });

    test('dark theme keeps the brand colours readable', () {
      final theme = AppTheme.dark;

      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.primaryLight);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.colorScheme.onSurface, AppColors.textPrimaryDark);
    });

    test('both themes configure component shapes', () {
      for (final theme in <ThemeData>[AppTheme.light, AppTheme.dark]) {
        expect(theme.cardTheme.shape, isNotNull);
        expect(theme.appBarTheme.backgroundColor, isNotNull);
        expect(theme.inputDecorationTheme.border, isNotNull);
        expect(theme.navigationBarTheme.labelTextStyle, isNotNull);
      }
    });
  });
}
