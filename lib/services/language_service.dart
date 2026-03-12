import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_language.dart';

class LanguageService extends ChangeNotifier {
  static const String _key = 'app_language';
  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getString(_key);
    
    _language = AppLanguage.values.firstWhere(
      (e) => e.name == savedValue,
      orElse: () => AppLanguage.english,
    );
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage newLanguage) async {
    if (_language == newLanguage) return;
    _language = newLanguage;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newLanguage.name);
    
    notifyListeners();
  }
}

final languageService = LanguageService();
