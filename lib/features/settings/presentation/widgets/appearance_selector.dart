import 'package:flutter/material.dart';

/// Segmented control for the light, dark and system theme modes.
class AppearanceSelector extends StatelessWidget {
  const AppearanceSelector({
    required this.themeMode,
    required this.onChanged,
    super.key,
  });

  /// Currently applied theme mode.
  final ThemeMode themeMode;

  /// Invoked when the user picks another mode.
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<ThemeMode>(
        segments: const <ButtonSegment<ThemeMode>>[
          ButtonSegment<ThemeMode>(
            value: ThemeMode.system,
            label: Text('System'),
            icon: Icon(Icons.brightness_auto_rounded),
          ),
          ButtonSegment<ThemeMode>(
            value: ThemeMode.light,
            label: Text('Light'),
            icon: Icon(Icons.light_mode_rounded),
          ),
          ButtonSegment<ThemeMode>(
            value: ThemeMode.dark,
            label: Text('Dark'),
            icon: Icon(Icons.dark_mode_rounded),
          ),
        ],
        selected: <ThemeMode>{themeMode},
        onSelectionChanged: (selection) => onChanged(selection.first),
        showSelectedIcon: false,
      ),
    );
  }
}
