import 'package:fastingcalender/models/fast_type.dart';
import 'package:fastingcalender/services/fasting_service.dart';
import 'package:fastingcalender/services/theme_service.dart';
import 'package:fastingcalender/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Settings bar
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.settings),
                tooltip: 'Settings',
                onSelected: (value) {
                  switch (value) {
                    case 'theme_system':
                      themeService.setThemeMode(ThemeMode.system);
                    case 'theme_light':
                      themeService.setThemeMode(ThemeMode.light);
                    case 'theme_dark':
                      themeService.setThemeMode(ThemeMode.dark);
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
                ],
              ),
            ),
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                final fast = fastingService.getFastingType(day);
                return fast != null ? [fast] : [];
              },
              calendarStyle: CalendarStyle(
                markersMaxCount: 0,
                defaultTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                weekendTextStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) => _buildDayCell(
                  day, isDarkMode,
                  isWeekend: day.weekday == DateTime.saturday || day.weekday == DateTime.sunday,
                ),
                todayBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, isDarkMode, isToday: true),
                selectedBuilder: (context, day, focusedDay) =>
                    _buildDayCell(day, isDarkMode, isSelected: true),
              ),
            ),
            const SizedBox(height: 20),
            // Legend
            _buildLegend(),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: _buildInfoCard(isDarkMode),
              ),
            ),
          ],
        ),
      ),
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
    Color textColor;

    if (isSelected) {
      bgColor = AppColors.primary;
      textColor = Colors.white;
    } else if (fastType != null) {
      bgColor = fastType.color.withOpacity(0.35);
      textColor = isDarkMode ? Colors.white : Colors.black;
    } else if (isToday) {
      bgColor = AppColors.primary.withOpacity(0.25);
      textColor = isDarkMode ? Colors.white : Colors.black;
    } else {
      bgColor = null;
      textColor = isWeekend
          ? (isDarkMode ? Colors.white70 : Colors.black54)
          : (isDarkMode ? Colors.white : Colors.black);
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: bgColor != null
          ? BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6))
          : null,
      alignment: Alignment.center,
      child: Text('${day.day}', style: TextStyle(color: textColor)),
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

  Widget _buildInfoCard(bool isDarkMode) {
    if (_selectedDay == null) {
      return const Text('Select a day to see fasting details.');
    }

    final fastType = fastingService.getFastingType(_selectedDay!);
    if (fastType != null) {
      return Card(
        color: fastType.color.withOpacity(isDarkMode ? 0.25 : 0.15),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.restaurant_menu, color: fastType.color),
              const SizedBox(height: 8),
              Text(
                fastType.label,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(fastType.description, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return const Text('No fasting today.', style: TextStyle(color: AppColors.noFastingText));
  }
}
