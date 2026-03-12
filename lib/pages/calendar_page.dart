import 'package:fastingcalender/models/app_font.dart';
import 'package:fastingcalender/models/app_language.dart';
import 'package:fastingcalender/models/fast_type.dart';
import 'package:fastingcalender/services/fasting_service.dart';
import 'package:fastingcalender/services/theme_service.dart';
import 'package:fastingcalender/services/language_service.dart';
import 'package:fastingcalender/utils/app_colors.dart';
import 'package:fastingcalender/utils/translations.dart';
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
            actions: [
              IconButton(
                icon: const Icon(Icons.today),
                tooltip: s.today,
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime.now();
                    _selectedDay = _focusedDay;
                  });
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.settings),
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
            physics: const ClampingScrollPhysics(), // Better interaction with calendar swipes
            children: [
              _buildMonthView(isDarkMode, s, safeLocale),
              _buildDayView(isDarkMode, s, safeLocale),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_month),
                label: s.month,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.today),
                label: s.day,
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
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          availableGestures: AvailableGestures.horizontalSwipe, // Explicitly allow horizontal swipes for month changes
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
                    DateFormat('EEEE', locale).format(dateToDisplay),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    DateFormat('MMMM d, yyyy', locale).format(dateToDisplay),
                    style: Theme.of(context).textTheme.bodyMedium,
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
        const Divider(),
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
        color: AppColors.primary,
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
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: type.color.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
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
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu, 
              color: fastType.color, 
              size: expanded ? 80 : 40
            ),
            const SizedBox(height: 16),
            Text(
              Translations.getFastLabel(fastType, languageService.language),
              style: expanded 
                ? Theme.of(context).textTheme.headlineMedium?.copyWith(color: fastType.color)
                : Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              Translations.getFastDescription(fastType, languageService.language), 
              textAlign: TextAlign.center,
              style: expanded ? Theme.of(context).textTheme.titleMedium : null,
            ),
            if (expanded) ...[
              const SizedBox(height: 40),
              Text(
                s.fastingRules,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  s.fastingEncouragement,
                  textAlign: TextAlign.center,
                ),
              ),
            ]
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.celebration, 
          color: Colors.green, 
          size: expanded ? 80 : 40
        ),
        const SizedBox(height: 16),
        Text(
          s.noFasting,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(s.noFastingDesc),
      ],
    );
  }
}
