import 'package:flutter/material.dart';

/// The exact brand palette used across the app.
///
/// Every theme colour is derived from these constants only, so the design
/// system stays consistent in light and dark mode.
abstract final class AppColors {
  /// Primary brand colour.
  static const Color primary = Color(0xFF9C27B0);

  /// Light tint of [primary], used for containers and highlights.
  static const Color primaryLight = Color(0xFFE1BEE7);

  /// Dark shade of [primary], used for pressed and high-emphasis states.
  static const Color primaryDark = Color(0xFF7B1FA2);

  /// Accent colour mapped to the colour scheme secondary.
  static const Color secondary = Color(0xFFE040FB);

  /// Primary body text colour.
  static const Color textPrimary = Color(0xFF212121);

  /// Secondary and helper text colour.
  static const Color textSecondary = Color(0xFF757575);

  /// Dividers, borders and outlines.
  static const Color divider = Color(0xFFBDBDBD);

  /// Text and icons drawn on top of [primary].
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Ambient surface for light mode.
  static const Color surfaceLight = Color(0xFFFFFBFE);

  /// Elevated surface for light mode cards.
  static const Color surfaceContainerLight = Color(0xFFF7F2FA);

  /// Ambient surface for dark mode.
  static const Color surfaceDark = Color(0xFF151218);

  /// Elevated surface for dark mode cards.
  static const Color surfaceContainerDark = Color(0xFF221E27);

  /// Body text colour for dark mode.
  static const Color textPrimaryDark = Color(0xFFEDE7F6);

  /// Secondary text colour for dark mode.
  static const Color textSecondaryDark = Color(0xFFB0A9BE);

  /// Divider colour for dark mode.
  static const Color dividerDark = Color(0xFF3A3442);

  /// Positive balance colour.
  static const Color success = Color(0xFF2E7D32);

  /// Negative balance colour.
  static const Color danger = Color(0xFFC62828);

  /// Warning colour used near the budget limit.
  static const Color warning = Color(0xFFEF6C00);

  /// Options offered when creating a custom category.
  static const List<Color> categoryPalette = <Color>[
    Color(0xFF9C27B0),
    Color(0xFFE040FB),
    Color(0xFFE91E63),
    Color(0xFFFF7043),
    Color(0xFFFFB300),
    Color(0xFF66BB6A),
    Color(0xFF26A69A),
    Color(0xFF42A5F5),
    Color(0xFF5C6BC0),
    Color(0xFF7E57C2),
    Color(0xFF8D6E63),
    Color(0xFF9E9E9E),
  ];
}
