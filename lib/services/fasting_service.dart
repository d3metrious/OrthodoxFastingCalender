import 'package:flutter/material.dart';

class FastingService extends ChangeNotifier {
  Future<void> init() async {
    // Nothing to load yet
  }

  /// Returns a fasting label if the given day is a fasting day, otherwise null.
  String? getFastingType(DateTime date) {
    if (date.weekday == DateTime.wednesday) return 'Wednesday Fast';
    if (date.weekday == DateTime.friday) return 'Friday Fast';
    return null;
  }
}

// Global instance
final fastingService = FastingService();
