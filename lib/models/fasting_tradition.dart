enum FastingTradition {
  orthodox,
  romanCatholic,
  none;

  String get displayName {
    switch (this) {
      case FastingTradition.orthodox:
        return 'Eastern Orthodox';
      case FastingTradition.romanCatholic:
        return 'Roman Catholic';
      case FastingTradition.none:
        return 'None / General';
    }
  }
}
