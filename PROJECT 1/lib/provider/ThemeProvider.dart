// packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Enum for theme preference
enum ThemePreference { system, light, dark }

class ThemeProvider extends ChangeNotifier {
  late Box<String> _settingsBox;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeProvider() {
    _settingsBox = Hive.box<String>('settingsBox');
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  String get themePreferenceString {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _loadThemeMode() {
    final storedTheme = _settingsBox.get('themePreference');
    if (storedTheme != null) {
      switch (storedTheme) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
          break;
      }
    }
    notifyListeners();
  }

  void setThemePreference(ThemePreference preference) {
    switch (preference) {
      case ThemePreference.light:
        _themeMode = ThemeMode.light;
        _settingsBox.put('themePreference', 'light');
        break;
      case ThemePreference.dark:
        _themeMode = ThemeMode.dark;
        _settingsBox.put('themePreference', 'dark');
        break;
      case ThemePreference.system:
        _themeMode = ThemeMode.system;
        _settingsBox.put('themePreference', 'system');
        break;
    }
    notifyListeners();
  }
}
