import 'package:flutter/material.dart' show DateTimeRange;
import 'package:intl/intl.dart';

/// Centralised formatting helpers so every screen renders money and dates
/// identically.
abstract final class Formatters {
  static final NumberFormat _currency = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );
  static final NumberFormat _compactCurrency = NumberFormat.compactCurrency(
    symbol: '\$',
    decimalDigits: 1,
  );
  static final NumberFormat _decimal = NumberFormat('#,##0.00');
  static final DateFormat _fullDate = DateFormat('EEE, d MMM yyyy');
  static final DateFormat _shortDate = DateFormat('d MMM');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');
  static final DateFormat _isoDay = DateFormat('yyyy-MM-dd');
  static final DateFormat _time = DateFormat('h:mm a');

  /// Formats an amount as currency, for example `$1,240.50`.
  static String currency(double amount) => _currency.format(amount);

  /// Formats large amounts compactly, for example `$1.2K`.
  static String compactCurrency(double amount) {
    if (amount.abs() < 1000) return currency(amount);
    return _compactCurrency.format(amount);
  }

  /// Formats a plain decimal with two digits.
  static String decimal(double value) => _decimal.format(value);

  /// Formats a percentage from a 0..1 fraction.
  static String percent(double fraction) => '${(fraction * 100).round()}%';

  /// Formats a full date, for example `Mon, 3 Nov 2025`.
  static String fullDate(DateTime date) => _fullDate.format(date);

  /// Formats a short date, for example `3 Nov`.
  static String shortDate(DateTime date) => _shortDate.format(date);

  /// Formats a month and year, for example `November 2025`.
  static String monthYear(DateTime date) => _monthYear.format(date);

  /// Formats the machine readable day used by Hive keys.
  static String isoDay(DateTime date) => _isoDay.format(date);

  /// Formats a time of day, for example `4:30 PM`.
  static String time(DateTime date) => _time.format(date);

  /// Returns a friendly relative label such as "Today" or "Yesterday".
  static String relativeDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final difference = today.difference(target).inDays;
    return switch (difference) {
      0 => 'Today',
      1 => 'Yesterday',
      _ => shortDate(date),
    };
  }

  /// Returns the first and last day of the month containing [date].
  static DateTimeRange monthBounds(DateTime date) {
    final start = DateTime(date.year, date.month);
    final end = DateTime(date.year, date.month + 1, 0, 23, 59, 59, 999);
    return DateTimeRange(start: start, end: end);
  }
}
