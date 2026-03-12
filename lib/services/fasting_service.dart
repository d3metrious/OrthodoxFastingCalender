class FastingService {
  static final Map<DateTime, String> _fixedFasts = {
    DateTime.utc(2023, 12, 24): 'Nativity Fast',
    DateTime.utc(2023, 12, 25): 'Feast of the Nativity',
  };

  static String? getFastingType(DateTime date) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    if (_fixedFasts.containsKey(normalizedDate)) {
      return _fixedFasts[normalizedDate];
    }

    if (date.weekday == DateTime.wednesday) return 'Wednesday Fast';
    if (date.weekday == DateTime.friday) return 'Friday Fast';

    return null;
  }
}
