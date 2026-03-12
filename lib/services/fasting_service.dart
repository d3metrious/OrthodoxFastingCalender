import 'package:fastingcalender/models/fast_type.dart';
import 'package:flutter/material.dart';

class FastingService extends ChangeNotifier {
  Future<void> init() async {
    // Nothing to load yet
  }

  /// Returns the [FastType] for the given day, or null if it is not a fasting day.
  FastType? getFastingType(DateTime date) {
    if (date.weekday == DateTime.wednesday) return FastType.strictFast;
    if (date.weekday == DateTime.friday) return FastType.strictFast;
    return null;
  }
}

// Global instance
final fastingService = FastingService();
