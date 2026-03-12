import '../utils/translations.dart';

enum AppLanguage {
  english,
  greek,
  churchSlavonic,
  arabic,
  ethiopian;

  String get displayName {
    switch (this) {
      case AppLanguage.english: return 'English';
      case AppLanguage.greek: return 'Ελληνικά (Greek)';
      case AppLanguage.churchSlavonic: return 'Церковнославянскій (Slavonic)';
      case AppLanguage.arabic: return 'العربية (Arabic)';
      case AppLanguage.ethiopian: return 'አማርኛ (Amharic)';
    }
  }

  String get languageCode {
    switch (this) {
      case AppLanguage.english: return 'en';
      case AppLanguage.greek: return 'el';
      case AppLanguage.churchSlavonic: return 'cu';
      case AppLanguage.arabic: return 'ar';
      case AppLanguage.ethiopian: return 'am';
    }
  }

  /// Returns the corresponding translation class
  AppStrings get strings => Translations.of(this);
}
