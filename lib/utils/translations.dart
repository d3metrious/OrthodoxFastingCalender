import '../models/app_language.dart';
import '../models/fast_type.dart';

/// Base class (English) acts as the fallback for all other languages
class AppStrings {
  String get today => 'Today';
  String get settings => 'Settings';
  String get theme => 'Theme';
  String get light => 'Light Mode';
  String get dark => 'Dark Mode';
  String get system => 'Device Default';
  String get font => 'Font';
  String get language => 'Language';
  String get month => 'Month';
  String get day => 'Day';
  String get selectDay => 'Select a day to see fasting details.';
  String get noFasting => 'No Fasting';
  String get noFastingDesc => 'Standard foods are permitted today.';
  String get fastingRules => 'Fasting Rules';
  String get fastingEncouragement => 
      'On this day, the faithful are encouraged to observe the traditional fasting guidelines according to their tradition.';

  // Fasting Labels
  String get strictFastLabel => 'Strict Fast';
  String get wineOilLabel => 'Wine & Oil';
  String get fishOilWineLabel => 'Fish, Oil & Wine';
  String get dairyAllowedLabel => 'Dairy Allowed';

  // Fasting Descriptions
  String get strictFastDesc => 'Refrain from meat, fish, oil, wine, dairy, and eggs.';
  String get wineOilDesc => 'Wine and oil are allowed. Refrain from meat, fish, dairy, and eggs.';
  String get fishOilWineDesc => 'Fish, oil and wine are allowed. Refrain from meat, dairy and eggs.';
  String get dairyAllowedDesc => 'Dairy, eggs, fish, oil and wine are allowed. Refrain from meat.';
}

/// Greek Overrides
class GreekStrings extends AppStrings {
  @override String get today => 'Σήμερα';
  @override String get settings => 'Ρυθμίσεις';
  @override String get theme => 'Θέμα';
  @override String get light => 'Φωτεινό';
  @override String get dark => 'Σκούρο';
  @override String get system => 'Προεπιλογή συστήματος';
  @override String get font => 'Γραμματοσειρά';
  @override String get language => 'Γλώσσα';
  @override String get month => 'Μήνας';
  @override String get day => 'Ημέρα';
  @override String get selectDay => 'Επιλέξτε μια ημέρα για λεπτομέρειες νηστείας.';
  @override String get noFasting => 'Κατάλυση';
  @override String get noFastingDesc => 'Επιτρέπονται όλες οι τροφές σήμερα.';
  @override String get fastingRules => 'Κανόνες Νηστείας';
  @override String get fastingEncouragement => 
      'Αυτήν την ημέρα, οι πιστοί ενθαρρύνονται να τηρούν τις παραδοσιακές οδηγίες νηστείας σύμφωνα με την παράδοσή τους.';

  @override String get strictFastLabel => 'Αυστηρή Νηστεία';
  @override String get strictFastDesc => 'Αποχή από κρέας, ψάρι, λάδι, κρασί, γαλακτοκομικά και αυγά.';
  @override String get wineOilLabel => 'Οίνος και Έλαιο';
  @override String get wineOilDesc => 'Επιτρέπεται το κρασί και το λάδι. Αποχή από κρέας, ψάρι, γαλακτοκομικά και αυγά.';
  @override String get fishOilWineLabel => 'Ιχθύς, Οίνος και Έλαιο';
  @override String get fishOilWineDesc => 'Επιτρέπεται το ψάρι, το κρασί και το λάδι. Αποχή από κρέας, γαλακτοκομικά και αυγά.';
  @override String get dairyAllowedLabel => 'Κατάλυση Τυρού';
  @override String get dairyAllowedDesc => 'Επιτρέπονται γαλακτοκομικά, αυγά, ψάρι, λάδι και κρασί. Αποχή από κρέας.';
}

/// Arabic Overrides
class ArabicStrings extends AppStrings {
  @override String get today => 'اليوم';
  @override String get settings => 'الإعدادات';
  @override String get strictFastLabel => 'صوم انقطاعي';
}

/// Church Slavonic Overrides
class SlavonicStrings extends AppStrings {
  @override String get today => 'Днесь';
  @override String get settings => 'Настройки';
  @override String get strictFastLabel => 'Строгій постъ';
}

/// Ethiopian (Amharic) Overrides
class AmharicStrings extends AppStrings {
  @override String get today => 'ዛሬ';
  @override String get settings => 'ቅንጅቶች';
  @override String get strictFastLabel => 'አጽዋማት';
}

class Translations {
  /// Returns the correct string object for the given language
  static AppStrings of(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.greek:
        return GreekStrings();
      case AppLanguage.arabic:
        return ArabicStrings();
      case AppLanguage.churchSlavonic:
        return SlavonicStrings();
      case AppLanguage.ethiopian:
        return AmharicStrings();
      case AppLanguage.english:
      default:
        return AppStrings(); // Fallback to English
    }
  }

  // Helper methods for the FastType enum
  static String getFastLabel(FastType type, AppLanguage lang) {
    final s = of(lang);
    switch (type) {
      case FastType.strictFast: return s.strictFastLabel;
      case FastType.wineAndOil: return s.wineOilLabel;
      case FastType.fishOilWine: return s.fishOilWineLabel;
      case FastType.dairyAllowed: return s.dairyAllowedLabel;
    }
  }

  static String getFastDescription(FastType type, AppLanguage lang) {
    final s = of(lang);
    switch (type) {
      case FastType.strictFast: return s.strictFastDesc;
      case FastType.wineAndOil: return s.wineOilDesc;
      case FastType.fishOilWine: return s.fishOilWineDesc;
      case FastType.dairyAllowed: return s.dairyAllowedDesc;
    }
  }
}
