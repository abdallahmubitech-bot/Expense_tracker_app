import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Builds the app text theme.
///
/// Uses a single type scale and paints it with the palette colours so light and
/// dark modes stay in sync. No fonts are downloaded at runtime, which keeps the
/// app fully offline capable.
abstract final class AppTypography {
  /// Text theme for light mode.
  static TextTheme light() => _build(AppColors.textPrimary);

  /// Text theme for dark mode.
  static TextTheme dark() => _build(AppColors.textPrimaryDark);

  static TextTheme _build(Color bodyColor) {
    final base = Typography.material2021().black;
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: base.displayMedium?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: base.displaySmall?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: base.titleLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: base.titleMedium?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: base.titleSmall?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: bodyColor, fontSize: 16),
      bodyMedium: base.bodyMedium?.copyWith(color: bodyColor, fontSize: 14),
      bodySmall: base.bodySmall?.copyWith(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
      labelLarge: base.labelLarge?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      labelMedium: base.labelMedium?.copyWith(
        color: bodyColor,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 0.4,
      ),
    );
  }
}
