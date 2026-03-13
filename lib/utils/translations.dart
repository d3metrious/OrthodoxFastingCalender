import '../models/app_language.dart';
import '../models/fast_type.dart';
import '../services/fasting_service.dart';

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

  // Fasting reason — liturgical period names (keyed by FastingReason.periodKey)
  String reasonPeriod(String key) => switch (key) {
    'greatLent'       => 'Great Lent',
    'lazarusSaturday' => 'Lazarus Saturday',
    'palmSunday'      => 'Palm Sunday',
    'holyWeek'        => 'Holy Week',
    'holyThursday'    => 'Holy Thursday',
    'holyFriday'      => 'Holy Friday',
    'holySaturday'    => 'Holy Saturday',
    'pentecostarion'  => 'Pentecostarion',
    'midPentecost'    => 'Mid-Pentecost',
    'apodosis'        => 'Leave-taking of Pascha',
    'apostlesFast'    => "Apostles' Fast",
    'dormitionFast'   => 'Dormition Fast',
    'nativityFast'    => 'Nativity Fast',
    'cheesefare'      => 'Cheesefare Week',
    'wednesday'       => 'Wednesday Fast',
    'friday'          => 'Friday Fast',
    'theophanyEve'    => 'Eve of Theophany',
    'beheadingJohn'   => 'Beheading of St John the Baptist',
    'elevationCross'  => 'Elevation of the Holy Cross',
    _                 => key,
  };

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

  @override
  String reasonPeriod(String key) => switch (key) {
    'greatLent'       => 'Μεγάλη Τεσσαρακοστή',
    'lazarusSaturday' => 'Σάββατο του Λαζάρου',
    'palmSunday'      => 'Κυριακή Βαΐων',
    'holyWeek'        => 'Μεγάλη Εβδομάδα',
    'holyThursday'    => 'Μεγάλη Πέμπτη',
    'holyFriday'      => 'Μεγάλη Παρασκευή',
    'holySaturday'    => 'Μεγάλο Σάββατο',
    'pentecostarion'  => 'Πεντηκοστάριο',
    'midPentecost'    => 'Μεσοπεντηκοστή',
    'apodosis'        => 'Απόδοση Πάσχα',
    'apostlesFast'    => 'Νηστεία Αποστόλων',
    'dormitionFast'   => 'Νηστεία Δεκαπενταύγουστου',
    'nativityFast'    => 'Νηστεία Χριστουγέννων',
    'cheesefare'      => 'Τυροφάγος',
    'wednesday'       => 'Νηστεία Τετάρτης',
    'friday'          => 'Νηστεία Παρασκευής',
    'theophanyEve'    => 'Παραμονή Θεοφανείων',
    'beheadingJohn'   => 'Αποτομή Κεφαλής Ιω. Προδρόμου',
    'elevationCross'  => 'Ύψωση Τιμίου Σταυρού',
    _                 => super.reasonPeriod(key),
  };

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
  @override
  String reasonPeriod(String key) => switch (key) {
    'greatLent'       => 'الصوم الكبير',
    'lazarusSaturday' => 'سبت لعازر',
    'palmSunday'      => 'أحد الشعانين',
    'holyWeek'        => 'الأسبوع المقدس',
    'holyThursday'    => 'خميس الأسرار',
    'holyFriday'      => 'الجمعة العظيمة',
    'holySaturday'    => 'سبت النور',
    'pentecostarion'  => 'فترة الخمسينية',
    'midPentecost'    => 'منتصف الخمسينية',
    'apodosis'        => 'وداع الفصح',
    'apostlesFast'    => 'صوم الرسل',
    'dormitionFast'   => 'صوم العذراء',
    'nativityFast'    => 'صوم الميلاد',
    'cheesefare'      => 'أسبوع الجبن',
    'wednesday'       => 'صيام الأربعاء',
    'friday'          => 'صيام الجمعة',
    'theophanyEve'    => 'عشية الغطاس',
    'beheadingJohn'   => 'قطع رأس يوحنا المعمدان',
    'elevationCross'  => 'رفع الصليب المقدس',
    _                 => super.reasonPeriod(key),
  };

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
  @override
  String reasonPeriod(String key) => switch (key) {
    'greatLent'       => 'Великій постъ',
    'lazarusSaturday' => 'Суббота Лазарева',
    'palmSunday'      => 'Недѣля Ваій',
    'holyWeek'        => 'Страстная седмица',
    'holyThursday'    => 'Великій Четвергъ',
    'holyFriday'      => 'Великій Пятокъ',
    'holySaturday'    => 'Великая Суббота',
    'pentecostarion'  => 'Пятидесятница',
    'midPentecost'    => 'Преполовеніе',
    'apodosis'        => 'Отданіе Пасхи',
    'apostlesFast'    => 'Постъ Апостолскій',
    'dormitionFast'   => 'Успенскій постъ',
    'nativityFast'    => 'Рождественскій постъ',
    'cheesefare'      => 'Сырная седмица',
    'wednesday'       => 'Постъ среды',
    'friday'          => 'Постъ пятницы',
    'theophanyEve'    => 'Навечеріе Богоявленія',
    'beheadingJohn'   => 'Усѣкновеніе главы Іоанна',
    'elevationCross'  => 'Воздвиженіе Честнаго Креста',
    _                 => super.reasonPeriod(key),
  };

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
  @override
  String reasonPeriod(String key) => switch (key) {
    'greatLent'       => 'ዐቢይ ጾም',
    'lazarusSaturday' => 'ቅዳሜ ሊቀ ነቢያት',
    'palmSunday'      => 'ሆሳዕና',
    'holyWeek'        => 'ሰሙነ ሕማማት',
    'holyThursday'    => 'ሐሙስ ሰሙነ ሕማማት',
    'holyFriday'      => 'ስቅለት',
    'holySaturday'    => 'ቅዳሜ ሰሙነ ሕማማት',
    'pentecostarion'  => 'ጰሃቄ',
    'midPentecost'    => 'መካከለኛ ሃምሳ ቀን',
    'apodosis'        => 'ፍሬ ፋሲካ',
    'apostlesFast'    => 'ጾመ ሐዋርያት',
    'dormitionFast'   => 'ጾመ ፍልሰታ',
    'nativityFast'    => 'ጾመ ገና',
    'cheesefare'      => 'የቅዱስ ሥጋ ሳምንት',
    'wednesday'       => 'ጾም ሮብ',
    'friday'          => 'ጾም ዐርብ',
    'theophanyEve'    => 'ቅዳሜ ጥምቀት',
    'beheadingJohn'   => 'ሰማዕትነት ቅዱስ ዮሐንስ',
    'elevationCross'  => 'ሰቀለ ዕፀ መስቀሉ',
    _                 => super.reasonPeriod(key),
  };

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

  // ── Fasting reason helpers ─────────────────────────────────────────────────

  /// Returns (periodText, feastText?) for display in the day view.
  static (String period, String? feast) getReasonText(FastingReason reason, AppLanguage lang) {
    final period = of(lang).reasonPeriod(reason.periodKey);
    final feast  = reason.feastKey != null ? feastNames[reason.feastKey] : null;
    return (period, feast);
  }

  /// English display names for feast-day exceptions, keyed by MM-dd.
  static const Map<String, String> feastNames = {
    '01-06': 'Theophany',
    '01-07': 'Synaxis of St John the Baptist',
    '01-14': 'Leave-taking of Theophany',
    '01-16': 'Chains of the Apostle Peter',
    '01-17': 'St Anthony the Great',
    '01-18': 'Sts Athanasios & Cyril',
    '01-20': 'St Euthymius the Great',
    '01-25': 'St Gregory the Theologian',
    '01-30': 'Three Holy Hierarchs',
    '02-02': 'Presentation of Christ',
    '02-10': 'Hieromartyr Haralambos',
    '02-11': 'Hieromartyr Blaise of Sebaste',
    '02-24': 'Finding of the Head of St John',
    '03-09': 'Forty Martyrs of Sebaste',
    '03-25': 'Annunciation',
    '03-26': 'Synaxis of Archangel Gabriel',
    '04-23': 'Holy Great-Martyr George',
    '05-21': 'Sts Constantine & Helen',
    '06-24': 'Nativity of St John the Baptist',
    '06-29': 'Sts Peter & Paul',
    '07-01': 'Holy Unmercenaries Cosmas & Damian',
    '07-08': 'Holy Martyr Prokopios',
    '07-17': 'Holy Martyr Marina',
    '07-20': 'Holy Prophet Elijah',
    '07-22': 'Mary Magdalene',
    '08-06': 'Transfiguration',
    '08-15': 'Dormition of the Theotokos',
    '08-29': 'Beheading of St John the Baptist',
    '09-08': 'Nativity of the Theotokos',
    '09-09': 'Sts Joachim & Anna',
    '09-23': 'Conception of St John the Baptist',
    '09-26': 'St John the Theologian',
    '10-06': 'Holy Apostle Thomas',
    '10-18': 'St Luke the Evangelist',
    '10-23': 'Holy Apostle James',
    '10-26': 'St Demetrius of Thessaloniki',
    '11-08': 'Synaxis of Archangel Michael',
    '11-13': 'St John Chrysostom',
    '11-21': 'Presentation of the Theotokos',
    '11-25': 'St Catherine of Alexandria',
    '12-04': 'Holy Great-Martyr Barbara',
    '12-06': 'St Nicholas',
    '12-09': 'Conception of St Anna',
    '12-12': 'St Spyridon',
    '12-15': 'St Eleutherios',
    '12-17': 'Prophet Daniel & Three Holy Youths',
  };

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
