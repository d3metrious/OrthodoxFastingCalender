import '../models/app_language.dart';
import '../models/fast_type.dart';

class Translations {
  static String get(String key, AppLanguage lang) {
    final Map<AppLanguage, Map<String, String>> _data = {
      AppLanguage.english: {
        'today': 'Today',
        'settings': 'Settings',
        'theme': 'Theme',
        'light': 'Light Mode',
        'dark': 'Dark Mode',
        'system': 'Device Default',
        'font': 'Font',
        'language': 'Language',
        'month': 'Month',
        'day': 'Day',
        'select_day': 'Select a day to see fasting details.',
        'no_fasting': 'No Fasting',
        'no_fasting_desc': 'Standard foods are permitted today.',
        'fasting_rules': 'Fasting Rules',
        'fasting_encouragement': 'On this day, the faithful are encouraged to observe the traditional fasting guidelines according to their tradition.',
        'strict_fast_label': 'Strict Fast',
        'strict_fast_desc': 'Refrain from meat, fish, oil, wine, dairy, and eggs.',
        'wine_oil_label': 'Wine & Oil',
        'wine_oil_desc': 'Wine and oil are allowed. Refrain from meat, fish, dairy, and eggs.',
        'fish_oil_wine_label': 'Fish, Oil & Wine',
        'fish_oil_wine_desc': 'Fish, oil and wine are allowed. Refrain from meat, dairy and eggs.',
        'dairy_allowed_label': 'Dairy Allowed',
        'dairy_allowed_desc': 'Dairy, eggs, fish, oil and wine are allowed. Refrain from meat.',
      },
      AppLanguage.greek: {
        'today': 'Σήμερα',
        'settings': 'Ρυθμίσεις',
        'theme': 'Θέμα',
        'light': 'Φωτεινό',
        'dark': 'Σκούρο',
        'system': 'Προεπιλογή συστήματος',
        'font': 'Γραμματοσειρά',
        'language': 'Γλώσσα',
        'month': 'Μήνας',
        'day': 'Ημέρα',
        'select_day': 'Επιλέξτε μια ημέρα για λεπτομέρειες νηστείας.',
        'no_fasting': 'Κατάλυση',
        'no_fasting_desc': 'Επιτρέπονται όλες οι τροφές σήμερα.',
        'fasting_rules': 'Κανόνες Νηστείας',
        'fasting_encouragement': 'Αυτήν την ημέρα, οι πιστοί ενθαρρύνονται να τηρούν τις παραδοσιακές οδηγίες νηστείας σύμφωνα με την παράδοσή τους.',
        'strict_fast_label': 'Αυστηρή Νηστεία',
        'strict_fast_desc': 'Αποχή από κρέας, ψάρι, λάδι, κρασί, γαλακτοκομικά και αυγά.',
        'wine_oil_label': 'Οίνος και Έλαιο',
        'wine_oil_desc': 'Επιτρέπεται το κρασί και το λάδι. Αποχή από κρέας, ψάρι, γαλακτοκομικά και αυγά.',
        'fish_oil_wine_label': 'Ιχθύς, Οίνος και Έλαιο',
        'fish_oil_wine_desc': 'Επιτρέπεται το ψάρι, το κρασί και το λάδι. Αποχή από κρέας, γαλακτοκομικά και αυγά.',
        'dairy_allowed_label': 'Κατάλυση Τυρού',
        'dairy_allowed_desc': 'Επιτρέπονται γαλακτοκομικά, αυγά, ψάρι, λάδι και κρασί. Αποχή από κρέας.',
      },
      // Placeholder translations for other languages
      AppLanguage.churchSlavonic: {
        'today': 'Днесь',
        'settings': 'Настройки',
        'strict_fast_label': 'Строгій постъ',
      },
      AppLanguage.arabic: {
        'today': 'اليوم',
        'settings': 'الإعدادات',
        'strict_fast_label': 'صوم انقطاعي',
      },
      AppLanguage.ethiopian: {
        'today': 'ዛሬ',
        'settings': 'ቅንጅቶች',
        'strict_fast_label': 'አጽዋማት',
      },
    };

    return _data[lang]?[key] ?? _data[AppLanguage.english]![key]!;
  }

  static String getFastLabel(FastType type, AppLanguage lang) {
    switch (type) {
      case FastType.strictFast: return get('strict_fast_label', lang);
      case FastType.wineAndOil: return get('wine_oil_label', lang);
      case FastType.fishOilWine: return get('fish_oil_wine_label', lang);
      case FastType.dairyAllowed: return get('dairy_allowed_label', lang);
    }
  }

  static String getFastDescription(FastType type, AppLanguage lang) {
    switch (type) {
      case FastType.strictFast: return get('strict_fast_desc', lang);
      case FastType.wineAndOil: return get('wine_oil_desc', lang);
      case FastType.fishOilWine: return get('fish_oil_wine_desc', lang);
      case FastType.dairyAllowed: return get('dairy_allowed_desc', lang);
    }
  }
}
