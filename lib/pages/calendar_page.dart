import 'package:fastingcalender/models/app_font.dart';
import 'package:fastingcalender/models/fast_type.dart';
import 'package:fastingcalender/services/fasting_service.dart';
import 'package:fastingcalender/services/theme_service.dart';
import 'package:fastingcalender/utils/app_colors.dart';
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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Today',
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
              switch (value) {
                case 'theme_system':
                  themeService.setThemeMode(ThemeMode.system);
                case 'theme_light':
                  themeService.setThemeMode(ThemeMode.light);
                case 'theme_dark':
                  themeService.setThemeMode(ThemeMode.dark);
                case 'font_sans':
                  themeService.setFont(AppFont.sans);
                case 'font_serif':
                  themeService.setFont(AppFont.serif);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text('Theme', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const PopupMenuItem(value: 'theme_system', child: Text('Device Default')),
              const PopupMenuItem(value: 'theme_light', child: Text('Light Mode')),
              const PopupMenuItem(value: 'theme_dark', child: Text('Dark Mode')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                enabled: false,
                child: Text('Font', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const PopupMenuItem(value: 'font_sans', child: Text('Noto Sans')),
              const PopupMenuItem(value: 'font_serif', child: Text('Noto Serif')),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          _buildMonthView(isDarkMode),
          _buildDayView(isDarkMode),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Month',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Day',
          ),
        ],
      ),
    );
  }

  Widget _buildMonthView(bool isDarkMode) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
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
        _buildLegend(),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: _buildInfoCard(isDarkMode, _selectedDay),
          ),
        ),
      ],
    );
  }

  Widget _buildDayView(bool isDarkMode) {
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
                    DateFormat('EEEE').format(dateToDisplay),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    DateFormat('MMMM d, yyyy').format(dateToDisplay),
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
            child: _buildInfoCard(isDarkMode, dateToDisplay, expanded: true),
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

  Widget _buildLegend() {
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
              Text(type.label, style: const TextStyle(fontSize: 11)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoCard(bool isDarkMode, DateTime? day, {bool expanded = false}) {
    if (day == null) {
      return const Text('Select a day to see fasting details.');
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
              fastType.label,
              style: expanded 
                ? Theme.of(context).textTheme.headlineMedium?.copyWith(color: fastType.color)
                : Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              fastType.description, 
              textAlign: TextAlign.center,
              style: expanded ? Theme.of(context).textTheme.titleMedium : null,
            ),
            if (expanded) ...[
              const SizedBox(height: 40),
              const Text(
                'Fasting Rules',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'On this day, the faithful are encouraged to observe the traditional fasting guidelines according to their tradition.',
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
        const Text(
          'No Fasting',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text('Standard foods are permitted today.'),
      ],
    );
  }
}
