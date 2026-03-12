import '../models/fasting_tradition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FastingService extends ChangeNotifier {
  static const String _key = 'fasting_tradition';
  FastingTradition _tradition = FastingTradition.none;

  FastingTradition get tradition => _tradition;

  /// Load the saved tradition preference
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getString(_key);
    
    _tradition = FastingTradition.values.firstWhere(
      (e) => e.name == savedValue,
      orElse: () => FastingTradition.none,
    );
    notifyListeners();
  }

  /// Update and persist the tradition
  Future<void> setTradition(FastingTradition newTradition) async {
    if (_tradition == newTradition) return;
    _tradition = newTradition;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newTradition.name);
    
    notifyListeners();
  }

  /// Logic to determine if a day is a fast based on tradition
  String? getFastingType(DateTime date) {
    switch (_tradition) {
      case FastingTradition.orthodox:
        // Eastern Orthodox: Wed/Fri always, plus some fixed
        if (date.weekday == DateTime.wednesday) return 'Orthodox Wednesday Fast';
        if (date.weekday == DateTime.friday) return 'Orthodox Friday Fast';
        break;
        
      case FastingTradition.romanCatholic:
        // Roman Catholic: Fridays in Lent (simplified for now)
        if (date.weekday == DateTime.friday) return 'Catholic Friday Penance';
        break;

      case FastingTradition.none:
        // Generic/General rules
        if (date.weekday == DateTime.friday) return 'General Friday Fast';
        break;
    }
    return null;
  }
}

// Global instance
final fastingService = FastingService();
