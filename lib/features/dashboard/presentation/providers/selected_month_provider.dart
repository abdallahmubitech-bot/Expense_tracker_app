import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_month_provider.g.dart';

/// The month currently shown on the dashboard.
///
/// Always normalised to the first day of the month so equality is stable.
@riverpod
class SelectedMonth extends _$SelectedMonth {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  /// Moves the selection by [delta] months.
  void shift(int delta) {
    state = DateTime(state.year, state.month + delta);
  }

  /// Jumps to the month containing [date].
  void select(DateTime date) {
    state = DateTime(date.year, date.month);
  }

  /// Returns to the current month.
  void reset() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month);
  }
}
