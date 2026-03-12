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
  @override String get theme => 'المظهر';
  @override String get light => 'وضع فاتح';
  @override String get dark => 'وضع داكن';
  @override String get system => 'تلقائي';
  @override String get font => 'الخط';
  @override String get language => 'اللغة';
  @override String get month => 'الشهر';
  @override String get day => 'اليوم';
  @override String get selectDay => 'اختر يوماً لرؤية تفاصيل الصيام.';
  @override String get noFasting => 'لا يوجد صيام';
  @override String get noFastingDesc => 'جميع الأطعمة مسموحة اليوم.';
  @override String get fastingRules => 'قوانين الصيام';
  @override String get fastingEncouragement => 'في هذا اليوم، يُشجع المؤمنون على اتباع إرشادات الصيام التقليدية حسب تقاليدهم.';
  @override String get strictFastLabel => 'صوم انقطاعي';
  @override String get wineOilLabel => 'نبيذ وزيت';
  @override String get fishOilWineLabel => 'سمك وزيت ونبيذ';
  @override String get dairyAllowedLabel => 'يسمح بمنتجات الألبان';
  @override String get strictFastDesc => 'الامتناع عن اللحم والسمك والزيت والنبيذ والألبان والبيض.';
  @override String get wineOilDesc => 'يسمح بالنبيذ والزيت. الامتناع عن اللحم والسمك والألبان والبيض.';
  @override String get fishOilWineDesc => 'يسمح بالسمك والزيت والنبيذ. الامتناع عن اللحم والألبان والبيض.';
  @override String get dairyAllowedDesc => 'يسمح بمنتجات الألبان والبيض والسمك والزيت والنبيذ. الامتناع عن اللحم.';
}

/// Church Slavonic Overrides
class SlavonicStrings extends AppStrings {
  @override String get today => 'Днесь';
  @override String get settings => 'Настройки';
  @override String get theme => 'Оформленіе';
  @override String get light => 'Свѣтлая';
  @override String get dark => 'Темная';
  @override String get system => 'По умолчанию';
  @override String get font => 'Шрифтъ';
  @override String get language => 'Языкъ';
  @override String get month => 'Мѣсяцъ';
  @override String get day => 'День';
  @override String get selectDay => 'Выбери день да видиши правила поста.';
  @override String get noFasting => 'Поста нѣсть';
  @override String get noFastingDesc => 'Всяка пища разрѣшена днесь.';
  @override String get fastingRules => 'Постныя правила';
  @override String get fastingEncouragement => 'Въ сей день вѣрніи призываются соблюдати традиціонная правила поста по преданію ихъ.';
  @override String get strictFastLabel => 'Строгій постъ';
  @override String get wineOilLabel => 'Вино и елей';
  @override String get fishOilWineLabel => 'Рыба, вино и елей';
  @override String get dairyAllowedLabel => 'Разрѣшеніе на вся';
  @override String get strictFastDesc => 'Воздержаніе отъ мяса, рыбы, елея, вина, млечныхъ и яицъ.';
  @override String get wineOilDesc => 'Вино и елей разрѣшаются. Воздержаніе отъ мяса, рыбы, млечныхъ и яицъ.';
  @override String get fishOilWineDesc => 'Рыба, елей и вино разрѣшаются. Воздержаніе отъ мяса, млечныхъ и яицъ.';
  @override String get dairyAllowedDesc => 'Млечная, яйца, рыба, елей и вино разрѣшаются. Воздержаніе отъ мяса.';
}

/// Ethiopian (Amharic) Overrides
class AmharicStrings extends AppStrings {
  @override String get today => 'ዛሬ';
  @override String get settings => 'ቅንጅቶች';
  @override String get theme => 'ገጽታ';
  @override String get light => 'ብሩህ ገጽታ';
  @override String get dark => 'ጨለማ ገጽታ';
  @override String get system => 'የስርዓቱ መደበኛ';
  @override String get font => 'ፊደል';
  @override String get language => 'ቋንቋ';
  @override String get month => 'ወር';
  @override String get day => 'ቀን';
  @override String get selectDay => 'የጾም ዝርዝሮችን ለማየት ቀኑን ይምረጡ።';
  @override String get noFasting => 'ጾም የለም';
  @override String get noFastingDesc => 'ዛሬ ሁሉም ምግቦች ይፈቀዳሉ።';
  @override String get fastingRules => 'የጾም ህጎች';
  @override String get fastingEncouragement => 'በዚህ ቀን ምዕመናን እንደ ወጋቸው ባህላዊውን የጾም መመሪያ እንዲከተሉ ይበረታታሉ።';
  @override String get strictFastLabel => 'አጽዋማት';
  @override String get wineOilLabel => 'ወይን እና ዘይት';
  @override String get fishOilWineLabel => 'ዓሳ፣ ዘይት እና ወይን';
  @override String get dairyAllowedLabel => 'የወተት ተዋጽኦ ይፈቀዳል';
  @override String get strictFastDesc => 'ከሥጋ፣ ከዓሳ፣ ከዘይት፣ ከወይን፣ ከወተት እና ከእንቁላል መከልከል::';
  @override String get wineOilDesc => 'ወይን እና ዘይት ይፈቀዳሉ። ከሥጋ፣ ከዓሳ፣ ከወተት እና ከእንቁላል መከልከል::';
  @override String get fishOilWineDesc => 'ዓሳ፣ ዘይት እና ወይን ይፈቀዳሉ። ከወተት እና ከእንቁላል መከልከል::';
  @override String get dairyAllowedDesc => 'የወተት ተዋጽኦ፣ እንቁላል፣ ዓሳ፣ ዘይት እና ወይን ይፈቀዳሉ። ከሥጋ መከልከል::';
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
