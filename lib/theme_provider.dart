import 'package:flutter/material.dart';

/// A [ChangeNotifier] that manages the application's theme state.
///
/// This provider allows the app to switch between light and dark modes
/// and notifies its listeners when the theme changes.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  /// The current theme mode of the application.
  ThemeMode get themeMode => _themeMode;

  /// Returns `true` if the current theme is dark mode.
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggles the application's theme between light and dark mode.
  ///
  /// Notifies listeners after the theme has been updated.
  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
