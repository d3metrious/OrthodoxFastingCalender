import 'package:fastingcalender/models/fast_type.dart';
import 'package:flutter/material.dart';

class FastingService extends ChangeNotifier {
  Future<void> init() async {}

  /// Returns the [FastType] for the given day under Greek Orthodox rules,
  /// or null if the day has no fasting requirement.
  FastType? getFastingType(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    final easter = _orthodoxEaster(d.year);

    // ── Special feast-day overrides (highest priority) ─────────────────────
    // March 25 — Annunciation: fish always allowed even in strict Lent
    if (d.month == 3 && d.day == 25) return FastType.fishOilWine;
    // Nov 21 — Presentation of Theotokos: fish allowed during Nativity fast
    if (d.month == 11 && d.day == 21) return FastType.fishOilWine;

    // ── Fast-free periods (no fasting at all) ──────────────────────────────
    if (_isFastFree(d, easter)) return null;

    // ── Cheesefare week (Mon–Sun before Clean Monday) ──────────────────────
    final cheesefareResult = _cheesefareWeek(d, easter);
    if (cheesefareResult != null) return cheesefareResult;

    // ── Great Lent & Holy Week ─────────────────────────────────────────────
    final lentResult = _lentFast(d, easter);
    if (lentResult != null) return lentResult;

    // ── Apostles' Fast ─────────────────────────────────────────────────────
    final apostlesResult = _apostlesFast(d, easter);
    if (apostlesResult != null) return apostlesResult;

    // ── Dormition Fast (Aug 1–14) ──────────────────────────────────────────
    final dormitionResult = _dormitionFast(d);
    if (dormitionResult != null) return dormitionResult;

    // ── Nativity Fast (Nov 15–Dec 24) ─────────────────────────────────────
    final nativityResult = _nativityFast(d);
    if (nativityResult != null) return nativityResult;

    // ── Fixed strict fast days ─────────────────────────────────────────────
    if (_isFixedStrictFast(d)) return FastType.strictFast;

    // ── Regular Wednesday & Friday ─────────────────────────────────────────
    if (d.weekday == DateTime.wednesday || d.weekday == DateTime.friday) {
      return FastType.strictFast;
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Easter calculation
  // ═══════════════════════════════════════════════════════════════════════════

  /// Calculates Orthodox (Julian) Easter expressed in the Gregorian calendar.
  /// Uses the Meeus Julian algorithm + 13-day Julian→Gregorian offset (1900–2099).
  DateTime _orthodoxEaster(int year) {
    final int a = year % 4;
    final int b = year % 7;
    final int c = year % 19;
    final int d = (19 * c + 15) % 30;
    final int e = (2 * a + 4 * b - d + 34) % 7;
    final int month = (d + e + 114) ~/ 31;
    final int day = (d + e + 114) % 31 + 1;
    // Dynamic Julian→Gregorian offset — valid for any century, not just 1900–2099
    final int offset = (year ~/ 100) - (year ~/ 400) - 2;
    return DateTime(year, month, day).add(Duration(days: offset));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Fast-free periods
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isFastFree(DateTime date, DateTime easter) {
    // Bright Week: Easter Sunday through the following Saturday
    final brightEnd = easter.add(const Duration(days: 6));
    if (!date.isBefore(easter) && !date.isAfter(brightEnd)) return true;

    // Week of the Publican & Pharisee
    // Publican Sunday = Easter − 70 days; fast-free Mon–Sat follow it
    final publicanSunday = easter.subtract(const Duration(days: 70));
    final fastFreeStart = publicanSunday.add(const Duration(days: 1));
    final fastFreeEnd   = publicanSunday.add(const Duration(days: 6));
    if (!date.isBefore(fastFreeStart) && !date.isAfter(fastFreeEnd)) return true;

    // Pentecost week: Mon–Sat after Pentecost Sunday (Easter + 49)
    final pentecost  = easter.add(const Duration(days: 49));
    final pWeekStart = pentecost.add(const Duration(days: 1));
    final pWeekEnd   = pentecost.add(const Duration(days: 6));
    if (!date.isBefore(pWeekStart) && !date.isAfter(pWeekEnd)) return true;

    // Christmas period: Dec 25 – Jan 4 (Jan 5 is Theophany Eve strict fast)
    if ((date.month == 12 && date.day >= 25) ||
        (date.month == 1  && date.day <= 4)) return true;

    return false;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Cheesefare week  (week before Clean Monday)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _cheesefareWeek(DateTime date, DateTime easter) {
    final cleanMonday = easter.subtract(const Duration(days: 48));
    final start = cleanMonday.subtract(const Duration(days: 7)); // Mon
    final end   = cleanMonday.subtract(const Duration(days: 1)); // Sun
    if (date.isBefore(start) || date.isAfter(end)) return null;
    // Meat forbidden; dairy, eggs, fish, oil & wine allowed all week
    return FastType.dairyAllowed;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Great Lent & Holy Week  (Clean Monday through Holy Saturday)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _lentFast(DateTime date, DateTime easter) {
    final cleanMonday  = easter.subtract(const Duration(days: 48));
    final holySaturday = easter.subtract(const Duration(days: 1));
    if (date.isBefore(cleanMonday) || date.isAfter(holySaturday)) return null;

    // ── Holy Week special days ─────────────────────────────────────────────
    // Lazarus Saturday (Easter − 8): fish, oil & wine
    if (_same(date, easter.subtract(const Duration(days: 8)))) return FastType.fishOilWine;
    // Palm Sunday (Easter − 7): fish, oil & wine
    if (_same(date, easter.subtract(const Duration(days: 7)))) return FastType.fishOilWine;
    // Holy Monday–Wednesday (Easter − 6 to − 4): strict fast
    if (_same(date, easter.subtract(const Duration(days: 6)))) return FastType.strictFast;
    if (_same(date, easter.subtract(const Duration(days: 5)))) return FastType.strictFast;
    if (_same(date, easter.subtract(const Duration(days: 4)))) return FastType.strictFast;
    // Holy Thursday (Easter − 3): wine & oil allowed
    if (_same(date, easter.subtract(const Duration(days: 3)))) return FastType.wineAndOil;
    // Holy Friday (Easter − 2): strict fast
    if (_same(date, easter.subtract(const Duration(days: 2)))) return FastType.strictFast;
    // Holy Saturday (Easter − 1): strict fast
    if (_same(date, holySaturday)) return FastType.strictFast;

    // ── Regular Great Lent ─────────────────────────────────────────────────
    // Saturdays & Sundays: wine & oil; weekdays: strict fast
    return (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday)
        ? FastType.wineAndOil
        : FastType.strictFast;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Apostles' Fast  (Mon after All Saints Sunday → June 28)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _apostlesFast(DateTime date, DateTime easter) {
    // All Saints Sunday = Easter + 56; fast starts the Monday after = Easter + 57
    final start = easter.add(const Duration(days: 57));
    final end   = DateTime(date.year, 6, 28);
    // In late-Easter years the fast may not exist at all
    if (start.isAfter(end)) return null;
    if (date.isBefore(start) || date.isAfter(end)) return null;

    return switch (date.weekday) {
      DateTime.wednesday || DateTime.friday => FastType.strictFast,
      DateTime.saturday  || DateTime.sunday => FastType.fishOilWine,
      _                                     => FastType.wineAndOil,
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Dormition Fast  (Aug 1–14)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _dormitionFast(DateTime date) {
    if (date.month != 8 || date.day < 1 || date.day > 14) return null;
    // Aug 6 — Transfiguration: fish, oil & wine
    if (date.day == 6) return FastType.fishOilWine;

    return switch (date.weekday) {
      DateTime.wednesday || DateTime.friday => FastType.strictFast,
      // Fish is NOT allowed during the Dormition fast (except Aug 6)
      _ => FastType.wineAndOil,
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Nativity Fast  (Nov 15 – Dec 24)
  // ═══════════════════════════════════════════════════════════════════════════

  FastType? _nativityFast(DateTime date) {
    final inFast = (date.month == 11 && date.day >= 15) ||
                   (date.month == 12 && date.day <= 24);
    if (!inFast) return null;

    // Dec 18–24: stricter (no fish on Sat/Sun, Mon–Fri all strict except Sat/Sun)
    if (date.month == 12 && date.day >= 18) {
      return switch (date.weekday) {
        DateTime.saturday || DateTime.sunday => FastType.wineAndOil,
        _                                    => FastType.strictFast,
      };
    }

    // Nov 15 – Dec 17
    return switch (date.weekday) {
      DateTime.wednesday || DateTime.friday => FastType.strictFast,
      DateTime.saturday  || DateTime.sunday => FastType.fishOilWine,
      _                                     => FastType.wineAndOil,
    };
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Fixed strict fast days
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isFixedStrictFast(DateTime date) {
    return (date.month == 1 && date.day == 5)  || // Theophany Eve
           (date.month == 8 && date.day == 29) || // Beheading of St John the Baptist
           (date.month == 9 && date.day == 14);   // Exaltation of the Holy Cross
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════════════════════════════════

  bool _same(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

// Global instance
final fastingService = FastingService();
