import 'package:fastingcalender/models/app_font.dart';
import 'package:fastingcalender/models/app_language.dart';
import 'package:fastingcalender/models/fast_type.dart';
import 'package:fastingcalender/services/fasting_service.dart';
import 'package:fastingcalender/services/theme_service.dart';
import 'package:fastingcalender/services/language_service.dart';
import 'package:fastingcalender/utils/app_colors.dart';
import 'package:fastingcalender/utils/translations.dart';
import 'package:fastingcalender/widgets/year_view.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onTabTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  String _getSafeLocale() {
    final code = languageService.language.languageCode;
    if (['en', 'el', 'ar', 'am'].contains(code)) {
      return code;
    }
    return 'en';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([languageService, themeService, fastingService]),
      builder: (context, child) {
        final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final s = Translations.of(languageService.language);
        final String safeLocale = _getSafeLocale();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.today_outlined),
                tooltip: s.today,
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime.now();
                    _selectedDay = _focusedDay;
                  });
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.settings_outlined),
                onSelected: (value) {
                  if (value.startsWith('theme_')) {
                    final mode = ThemeMode.values.firstWhere((e) => e.name == value.substring(6));
                    themeService.setThemeMode(mode);
                  } else if (value.startsWith('font_')) {
                    final font = AppFont.values.firstWhere((e) => e.name == value.substring(5));
                    themeService.setFont(font);
                  } else if (value.startsWith('lang_')) {
                    final lang = AppLanguage.values.firstWhere((e) => e.name == value.substring(5));
                    languageService.setLanguage(lang);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Text(s.theme, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  PopupMenuItem(value: 'theme_system', child: Text(s.system)),
                  PopupMenuItem(value: 'theme_light', child: Text(s.light)),
                  PopupMenuItem(value: 'theme_dark', child: Text(s.dark)),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    enabled: false,
                    child: Text(s.font, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  ...AppFont.values.map((font) => PopupMenuItem(
                        value: 'font_${font.name}',
                        child: Text(font.displayName),
                      )),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    enabled: false,
                    child: Text(s.language, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  ...AppLanguage.values.map((lang) => PopupMenuItem(
                        value: 'lang_${lang.name}',
                        child: Text(lang.displayName),
                  )),
                ],
              ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const ClampingScrollPhysics(),
            children: [
              _buildMonthView(isDarkMode, s, safeLocale),
              _buildDayView(isDarkMode, s, safeLocale),
              YearView(initialYear: _focusedDay.year, isDarkMode: isDarkMode),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: isDarkMode ? AppColors.fastingBackgroundDark : AppColors.fastingBackgroundLight,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: isDarkMode ? Colors.white54 : Colors.black54,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month_outlined),
                activeIcon: const Icon(Icons.calendar_month),
                label: s.month,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.today_outlined),
                activeIcon: const Icon(Icons.today),
                label: s.day,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.grid_view_outlined),
                activeIcon: const Icon(Icons.grid_view),
                label: s.year,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthView(bool isDarkMode, AppStrings s, String locale) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          locale: locale,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: isDarkMode ? Colors.white70 : Colors.black54),
            rightChevronIcon: Icon(Icons.chevron_right, color: isDarkMode ? Colors.white70 : Colors.black54),
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: const CalendarStyle(markersMaxCount: 0),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) => _buildDayCell(
              day,
              isDarkMode,
              isWeekend: day.weekday == DateTime.saturday || day.weekday == DateTime.sunday,
            ),
            todayBuilder: (context, day, focusedDay) =>
                _buildDayCell(day, isDarkMode, isToday: true),
            selectedBuilder: (context, day, focusedDay) =>
                _buildDayCell(day, isDarkMode, isSelected: true),
          ),
        ),
        const SizedBox(height: 20),
        _buildLegend(s),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: _buildInfoCard(isDarkMode, _selectedDay, s),
          ),
        ),
      ],
    );
  }

  Widget _buildDayView(bool isDarkMode, AppStrings s, String locale) {
    final dateToDisplay = _selectedDay ?? _focusedDay;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _selectedDay = dateToDisplay.subtract(const Duration(days: 1));
                    _focusedDay = _selectedDay!;
                  });
                },
              ),
              Column(
                children: [
                  Text(
                    DateFormat('EEEE', languageService.language.languageCode).format(dateToDisplay),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('MMMM d, yyyy', languageService.language.languageCode).format(dateToDisplay),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isDarkMode ? Colors.white70 : Colors.black54),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _selectedDay = dateToDisplay.add(const Duration(days: 1));
                    _focusedDay = _selectedDay!;
                  });
                },
              ),
            ],
          ),
        ),
        const Divider(indent: 32, endIndent: 32),
        Expanded(
          child: Center(
            child: _buildInfoCard(isDarkMode, dateToDisplay, s, expanded: true),
          ),
        ),
      ],
    );
  }

  Widget _buildDayCell(
    DateTime day,
    bool isDarkMode, {
    bool isWeekend = false,
    bool isToday = false,
    bool isSelected = false,
  }) {
    final fastType = fastingService.getFastingType(day);

    Color? bgColor;
    Color textColor = isDarkMode ? Colors.white : Colors.black;
    BoxBorder? border;

    if (fastType != null) {
      bgColor = fastType.color.withOpacity(isDarkMode ? 0.9 : 0.35);
    } else if (isToday) {
      bgColor = AppColors.primary.withOpacity(0.25);
    }

    if (isSelected) {
      border = Border.all(
        color: isDarkMode ? AppColors.primary : AppColors.fastingBackgroundDark,
        width: 2.0,
      );
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: border,
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}', 
        style: TextStyle(
          color: textColor,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        )
      ),
    );
  }

  Widget _buildLegend(AppStrings s) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 6,
        children: FastType.values.map((type) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(type.icon, size: 12, color: type.color), 
              const SizedBox(width: 4),
              Text(
                Translations.getFastLabel(type, languageService.language), 
                style: const TextStyle(fontSize: 11)
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoCard(bool isDarkMode, DateTime? day, AppStrings s, {bool expanded = false}) {
    if (day == null) {
      return Text(s.selectDay);
    }

    final fastType = fastingService.getFastingType(day);
    if (fastType != null) {
      final reason = expanded ? fastingService.getFastingReason(day) : null;
      final (String periodText, String? feastText) =
          reason != null ? Translations.getReasonText(reason, languageService.language) : ('', null);

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              fastType.icon,
              color: fastType.color,
              size: expanded ? 80 : 40
            ),
            const SizedBox(height: 16),
            Text(
              Translations.getFastLabel(fastType, languageService.language),
              style: expanded
                ? Theme.of(context).textTheme.headlineMedium?.copyWith(color: fastType.color, fontWeight: FontWeight.bold)
                : Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              Translations.getFastDescription(fastType, languageService.language),
              textAlign: TextAlign.center,
              style: expanded ? Theme.of(context).textTheme.titleMedium?.copyWith(color: isDarkMode ? Colors.white70 : Colors.black87) : null,
            ),
            if (expanded && reason != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: fastType.color.withOpacity(isDarkMode ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: fastType.color.withOpacity(0.35)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.church_outlined, size: 16, color: fastType.color),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            periodText,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: fastType.color,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    if (feastText != null) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 14,
                              color: isDarkMode ? Colors.amber.shade300 : Colors.amber.shade700),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              feastText,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDarkMode ? Colors.white70 : Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.celebration_outlined, 
          color: Colors.green, 
          size: expanded ? 80 : 40
        ),
        const SizedBox(height: 16),
        Text(
          s.noFasting,
          style: TextStyle(fontSize: expanded ? 28 : 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(s.noFastingDesc, style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
      ],
    );
  }
}
