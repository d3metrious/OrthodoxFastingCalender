import 'package:fastingcalender/models/fast_type.dart';
import 'package:flutter/material.dart';

class FastingService extends ChangeNotifier {
  Future<void> init() async {}

  /// Returns the [FastType] for the given day under Greek Orthodox (GOARCH) rules,
  /// or null if the day has no fasting requirement.
  FastType? getFastingType(DateTime date) {
    final d = _dateOnly(date);
    final easter = _orthodoxEaster(d.year);

    // ── 1. Fast-free periods (no fasting at all) ───────────────────────────
    if (_isFastFree(d, easter)) return null;

    // ── 2. Cheesefare week: dairy & eggs OK, meat forbidden ───────────────
    if (_inCheesefareWeek(d, easter)) return FastType.dairyAllowed;

    // ── 3. Compute the base fast from season / weekly rules ───────────────
    final FastType? base =
        _lentFast(d, easter) ??
        _pentecostarionFast(d, easter) ??   // relaxed Wed/Fri after Bright Week → All Saints
        _apostlesFast(d, easter) ??
        _dormitionFast(d) ??
        _nativityFast(d) ??
        (_isFixedStrictFast(d) ? FastType.strictFast : null) ??
        (d.weekday == DateTime.wednesday || d.weekday == DateTime.friday
            ? FastType.strictFast
            : null);

    if (base == null) return null; // Not a fasting day

    // ── 4. Feast-day exception (can only relax, never tighten, the base fast)
    final key =
        '${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return _feastExceptions[key] ?? base;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Feast-day exception table
  // Keys are "MM-dd".  A feast on a non-fasting day has no effect because
  // we only look up the table when base != null (step 4 above).
  // ═══════════════════════════════════════════════════════════════════════════

  static const Map<String, FastType> _feastExceptions = {
    // ── January ─────────────────────────────────────────────────────────────
    '01-06': FastType.fishOilWine, // Theophany (Great Feast — if on Wed/Fri)
    '01-07': FastType.fishOilWine, // Synaxis of St John the Baptist
    '01-14': FastType.wineAndOil,  // Leave-taking of Theophany
    '01-16': FastType.wineAndOil,  // Veneration of Chains of Apostle Peter
    '01-17': FastType.wineAndOil,  // St Anthony the Great
    '01-18': FastType.wineAndOil,  // Sts Athanasios & Cyril
    '01-20': FastType.wineAndOil,  // St Euthymius the Great
    '01-25': FastType.wineAndOil,  // St Gregory the Theologian
    '01-30': FastType.wineAndOil,  // Three Holy Hierarchs

    // ── February ─────────────────────────────────────────────────────────────
    '02-02': FastType.fishOilWine, // Meeting of Christ (Presentation / Hypapante)
    '02-10': FastType.wineAndOil,  // Hieromartyr Haralambos
    '02-11': FastType.wineAndOil,  // Hieromartyr Blaise of Sebaste
    '02-24': FastType.wineAndOil,  // 1st & 2nd Finding of the Head of St John

    // ── March ────────────────────────────────────────────────────────────────
    '03-09': FastType.wineAndOil,  // Holy Forty Martyrs of Sebaste
    '03-25': FastType.fishOilWine, // Annunciation (Great Feast — always fish)
    '03-26': FastType.wineAndOil,  // Synaxis of Archangel Gabriel

    // ── April ────────────────────────────────────────────────────────────────
    '04-23': FastType.wineAndOil,  // Holy Great-Martyr George

    // ── May ──────────────────────────────────────────────────────────────────
    '05-21': FastType.fishOilWine, // Equal-to-Apostles Constantine & Helen

    // ── June ─────────────────────────────────────────────────────────────────
    '06-24': FastType.fishOilWine, // Nativity of St John the Baptist
    '06-29': FastType.fishOilWine, // Feast of Apostles Peter & Paul

    // ── July ─────────────────────────────────────────────────────────────────
    '07-01': FastType.wineAndOil,  // Holy Unmercenaries Cosmas & Damian of Rome
    '07-08': FastType.wineAndOil,  // Holy Great-Martyr Prokopios
    '07-17': FastType.wineAndOil,  // Holy Great-Martyr Marina
    '07-20': FastType.wineAndOil,  // Holy Prophet Elijah
    '07-22': FastType.wineAndOil,  // Holy Myrrh-bearer Mary Magdalene

    // ── August ───────────────────────────────────────────────────────────────
    '08-15': FastType.fishOilWine, // Dormition of the Theotokos (Great Feast — after Dormition Fast)
    '08-29': FastType.wineAndOil, // Beheading of St John the Baptist


    // ── September ────────────────────────────────────────────────────────────
    '09-08': FastType.fishOilWine, // Nativity of the Theotokos (Great Feast)
    '09-09': FastType.wineAndOil, // Holy Ancestors Joachim and Anna
    '09-23': FastType.wineAndOil, // Conception of St John the Baptist
    '09-26': FastType.wineAndOil,  // Repose of St John the Theologian

    // ── October ──────────────────────────────────────────────────────────────
    '10-06': FastType.wineAndOil,  // Holy Apostle Thomas
    '10-18': FastType.wineAndOil,  // Holy Apostle & Evangelist Luke
    '10-23': FastType.wineAndOil,  // Holy Apostle James, Brother of the Lord
    '10-26': FastType.wineAndOil,  // Holy Great-Martyr Demetrius of Thessaloniki

    // ── November ─────────────────────────────────────────────────────────────
    '11-08': FastType.wineAndOil,  // Feast of Archangels
    '11-13': FastType.wineAndOil, // St John Chrysostom
    '11-21': FastType.fishOilWine, // Presentation of Theotokos (Great Feast)
    '11-25': FastType.wineAndOil, // Catherine the Great of Alexandria


    // ── December ─────────────────────────────────────────────────────────────
    '12-04': FastType.wineAndOil,  // Holy Great-Martyr Barbara
    '12-06': FastType.fishOilWine, // St Nicholas
    '12-09': FastType.wineAndOil,  // Conception of St Anna
    '12-12': FastType.wineAndOil,  // St Spyridon (fish not allowed in stricter Nativity Fast period)
    '12-15': FastType.wineAndOil,  // Holy Hieromartyr Eleutherios
    '12-17': FastType.wineAndOil,  // Prophet Daniel & the Three Holy Youths
  };

  // ═══════════════════════════════════════════════════════════════════════════
  // Easter calculation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Orthodox (Julian) Easter expressed in the Gregorian calendar.
  /// Meeus Julian algorithm with a dynamic century-aware J→G offset.
  DateTime _orthodoxEaster(int year) {
    final int a = year % 4;
    final int b = year % 7;
    final int c = year % 19;
    final int d = (19 * c + 15) % 30;
    final int e = (2 * a + 4 * b - d + 34) % 7;
    final int month = (d + e + 114) ~/ 31;
    final int day   = (d + e + 114) % 31 + 1;
    final int offset = (year ~/ 100) - (year ~/ 400) - 2; // valid any century
    return DateTime(year, month, day + offset); // calendar arithmetic — DST-safe
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Fast-free periods
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isFastFree(DateTime date, DateTime easter) {
    // Bright Week: Easter Sunday through the following Saturday
    if (_inRange(date, easter, _shift(easter, 6))) return true;

    // Week of the Publican & Pharisee: Mon–Sat after Publican Sunday (Easter − 70)
    final pSun = _shift(easter, -70);
    if (_inRange(date, _shift(pSun, 1), _shift(pSun, 6))) return true;

    // Pentecost week: Mon–Sat after Pentecost Sunday (Easter + 49)
    final pentecost = _shift(easter, 49);
    if (_inRange(date, _shift(pentecost, 1), _shift(pentecost, 6))) return true;

    // Christmas period: Dec 25 – Jan 4 (Jan 5 = Theophany Eve, strict fast)
    if ((date.month == 12 && date.day >= 25) ||
        (date.month == 1  && date.day <= 4)) return true;

    return false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Cheesefare week  (Mon–Sun immediately before Clean Monday)
  // ═══════════════════════════════════════════════════════════════════════════

  bool _inCheesefareWeek(DateTime date, DateTime easter) {
    final cleanMonday = _shift(easter, -48);
    return _inRange(date, _shift(cleanMonday, -7), _shift(cleanMonday, -1));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Great Lent & Holy Week  (Clean Monday through Holy Saturday)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _lentFast(DateTime date, DateTime easter) {
    final cleanMonday  = _shift(easter, -48);
    final holySaturday = _shift(easter, -1);
    if (!_inRange(date, cleanMonday, holySaturday)) return null;

    // Holy-Week special days (in date order)
    if (_same(date, _shift(easter, -8))) return FastType.wineAndOil;  // Lazarus Saturday
    if (_same(date, _shift(easter, -7))) return FastType.fishOilWine; // Palm Sunday
    if (_same(date, _shift(easter, -6))) return FastType.strictFast;  // Holy Monday
    if (_same(date, _shift(easter, -5))) return FastType.strictFast;  // Holy Tuesday
    if (_same(date, _shift(easter, -4))) return FastType.strictFast;  // Holy Wednesday
    if (_same(date, _shift(easter, -3))) return FastType.wineAndOil;  // Holy Thursday
    if (_same(date, _shift(easter, -2))) return FastType.strictFast;  // Holy Friday
    if (_same(date, holySaturday))       return FastType.strictFast;  // Holy Saturday

    // Regular Great Lent: Sat & Sun → wine & oil; weekdays → strict fast
    return (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday)
        ? FastType.wineAndOil
        : FastType.strictFast;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Pentecostarion  (Mon after Bright Week → All Saints Sunday)
  // Wed & Fri fasting is relaxed to wine & oil throughout this period.
  // Fast-free sub-periods (Bright Week, Pentecost week) are already removed
  // by _isFastFree before this method is ever reached.
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _pentecostarionFast(DateTime date, DateTime easter) {
    final start = _shift(easter, 7);   // Monday after Bright Week
    final end   = _shift(easter, 56);  // All Saints Sunday
    if (!_inRange(date, start, end)) return null;

    // Mid-Pentecost (4th Wed after Pascha = Easter + 24): fish allowed
    if (_same(date, _shift(easter, 24))) return FastType.fishOilWine;
    // Apodosis of Pascha (Wed before Ascension = Easter + 38): fish allowed
    if (_same(date, _shift(easter, 38))) return FastType.fishOilWine;

    if (date.weekday == DateTime.wednesday || date.weekday == DateTime.friday) {
      return FastType.wineAndOil;
    }
    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Apostles' Fast  (Mon after All Saints Sunday → June 28)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _apostlesFast(DateTime date, DateTime easter) {
    final start = _shift(easter, 57); // Mon after All Saints Sunday
    final end   = DateTime(date.year, 6, 28);
    if (start.isAfter(end) || !_inRange(date, start, end)) return null;

    return switch (date.weekday) {
      DateTime.wednesday || DateTime.friday => FastType.strictFast,
      DateTime.saturday  || DateTime.sunday => FastType.fishOilWine,
      _                                     => FastType.fishOilWine,
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Dormition Fast  (Aug 1–14)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _dormitionFast(DateTime date) {
    if (date.month != 8 || date.day < 1 || date.day > 14) return null;
    if (date.day == 6) return FastType.fishOilWine; // Transfiguration

    return switch (date.weekday) {
      DateTime.saturday || DateTime.sunday => FastType.wineAndOil,
      _ => FastType.strictFast, // Fish not allowed (except Aug 6)
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Nativity Fast  (Nov 15 – Dec 24)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _nativityFast(DateTime date) {
    final inFast = (date.month == 11 && date.day >= 15) ||
                   (date.month == 12 && date.day <= 24);
    if (!inFast) return null;

    // Dec 12–24: stricter — no fish even on weekends; max = wine & oil
    if (date.month == 12 && date.day >= 12) {
      return switch (date.weekday) {
        DateTime.saturday || DateTime.sunday => FastType.wineAndOil,
        _                                    => FastType.strictFast,
      };
    }

    // Nov 15 – Dec 11: fish on all non-fast days (Mon/Tue/Thu/Sat/Sun)
    return switch (date.weekday) {
      DateTime.wednesday || DateTime.friday => FastType.strictFast,
      DateTime.saturday  || DateTime.sunday => FastType.fishOilWine,
      _                                     => FastType.fishOilWine,
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Fixed strict fast days
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isFixedStrictFast(DateTime date) =>
      (date.month == 1 && date.day == 5)  || // Theophany Eve
      (date.month == 8 && date.day == 29) || // Beheading of St John the Baptist
      (date.month == 9 && date.day == 14);   // Exaltation of the Holy Cross

  // ═══════════════════════════════════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════════════════════════════════

  /// Shift [base] by [days] calendar days (positive = forward, negative = backward).
  /// Uses DateTime constructor overflow arithmetic — completely DST-safe because
  /// no seconds are involved, only year/month/day fields.
  /// e.g. DateTime(2026, 4, 12 - 48) → Dart normalises to DateTime(2026, 2, 23).
  DateTime _shift(DateTime base, int days) =>
      DateTime(base.year, base.month, base.day + days);

  /// Strip any time component, keeping only the calendar date.
  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  bool _same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _inRange(DateTime date, DateTime start, DateTime end) =>
      !date.isBefore(start) && !date.isAfter(end);
}

// Global instance
final fastingService = FastingService();
