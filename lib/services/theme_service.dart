import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_font.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _fontKey = 'app_font';
  static const String _tabKey = 'default_tab_index';

  ThemeMode _themeMode = ThemeMode.system;
  AppFont _appFont = AppFont.serif;
  int _defaultTabIndex = 1; // Default to Month view (index 1)

  ThemeMode get themeMode => _themeMode;
  AppFont get appFont => _appFont;
  int get defaultTabIndex => _defaultTabIndex;

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

    // Load default tab
    _defaultTabIndex = prefs.getInt(_tabKey) ?? 1;
    
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

  /// Update and persist the default tab
  Future<void> setDefaultTab(int index) async {
    if (_defaultTabIndex == index) return;
    _defaultTabIndex = index;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tabKey, index);
    
    notifyListeners();
  }
}

// Global instance
final themeService = ThemeService();
