enum AppFont {
  sans,
  serif;

  String get displayName {
    switch (this) {
      case AppFont.sans:
        return 'Noto Sans';
      case AppFont.serif:
        return 'Noto Serif';
    }
  }
}
