import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/fasting_service.dart';
import '../services/language_service.dart';
import '../utils/app_colors.dart';

class YearView extends StatefulWidget {
  final int initialYear;
  final bool isDarkMode;

  const YearView({
    super.key,
    required this.initialYear,
    required this.isDarkMode,
  });

  @override
  State<YearView> createState() => _YearViewState();
}

class _YearViewState extends State<YearView> {
  late PageController _yearPageController;
  late int _currentYear;

  @override
  void initState() {
    super.initState();
    _currentYear = widget.initialYear;
    // We'll use a large number for initial page to allow "infinite" swiping
    _yearPageController = PageController(initialPage: _currentYear);
  }

  @override
  void dispose() {
    _yearPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _yearPageController,
      onPageChanged: (year) {
        setState(() {
          _currentYear = year;
        });
      },
      itemBuilder: (context, year) {
        // year index acts as the actual year
        if (year < 1) return const SizedBox.shrink();
        
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '$year',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 months per row for a better year overview
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 12,
                itemBuilder: (context, monthIndex) {
                  return _MonthSmallCalendar(
                    year: year,
                    month: monthIndex + 1,
                    isDarkMode: widget.isDarkMode,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MonthSmallCalendar extends StatelessWidget {
  final int year;
  final int month;
  final bool isDarkMode;

  const _MonthSmallCalendar({
    required this.year,
    required this.month,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // DateTime.weekday returns 1 for Monday, 7 for Sunday.
    // Standard calendar grids usually start on Sunday (index 0).
    final firstDayOfWeek = DateTime(year, month, 1).weekday;
    final locale = languageService.language.languageCode;
    final monthName = DateFormat('MMM', locale).format(DateTime(year, month));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          monthName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42,
            itemBuilder: (context, index) {
              // Adjusting to start on Sunday (standard mini-calendar view)
              final dayNumber = index - (firstDayOfWeek % 7) + 1;
              if (dayNumber <= 0 || dayNumber > daysInMonth) {
                return const SizedBox.shrink();
              }

              final date = DateTime(year, month, dayNumber);
              final fastType = fastingService.getFastingType(date);

              return Container(
                margin: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  color: fastType?.color.withOpacity(isDarkMode ? 0.8 : 0.6),
                  borderRadius: BorderRadius.circular(1),
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      fontSize: 6,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
