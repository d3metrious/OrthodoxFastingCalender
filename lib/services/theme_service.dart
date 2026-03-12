import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  // Internal state
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // Update logic
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    
    // Notify all listeners (the UI) to rebuild
    notifyListeners();
  }
}

// Global instance for simplicity in this project
final themeService = ThemeService();
