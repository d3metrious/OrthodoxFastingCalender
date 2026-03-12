import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_font.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _fontKey = 'app_font';

  ThemeMode _themeMode = ThemeMode.system;
  AppFont _appFont = AppFont.serif;

  ThemeMode get themeMode => _themeMode;
  AppFont get appFont => _appFont;

  /// Call this at app startup to load saved preferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load theme
    final savedTheme = prefs.getString(_themeKey);
    if (savedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }

    // Load font
    final savedFont = prefs.getString(_fontKey);
    _appFont = AppFont.values.firstWhere(
      (e) => e.name == savedFont,
      orElse: () => AppFont.serif,
    );
    
    notifyListeners();
  }

  /// Update and persist the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
    
    notifyListeners();
  }

  /// Update and persist the font
  Future<void> setFont(AppFont font) async {
    if (_appFont == font) return;
    _appFont = font;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontKey, font.name);
    
    notifyListeners();
  }
}

// Global instance
final themeService = ThemeService();
