import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/fasting_tradition.dart';
import '../services/fasting_service.dart';
import '../services/theme_service.dart';
import '../utils/app_colors.dart';

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
      appBar: AppBar(
        title: const Text('Church Fasting Calendar'),
        backgroundColor: AppColors.primary.withOpacity(0.1),
        actions: [
          // Theme Selector
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.palette),
            tooltip: 'Change Theme',
            onSelected: (mode) => themeService.setThemeMode(mode),
            itemBuilder: (context) => [
              const PopupMenuItem(value: ThemeMode.system, child: Text('Device Default')),
              const PopupMenuItem(value: ThemeMode.light, child: Text('Light Mode')),
              const PopupMenuItem(value: ThemeMode.dark, child: Text('Dark Mode')),
            ],
          ),
          // Tradition Selector
          PopupMenuButton<FastingTradition>(
            icon: const Icon(Icons.settings),
            tooltip: 'Change Tradition',
            onSelected: (tradition) => fastingService.setTradition(tradition),
            itemBuilder: (context) => FastingTradition.values.map((tradition) {
              return PopupMenuItem(
                value: tradition,
                child: Text(tradition.displayName),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
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
              markerDecoration: const BoxDecoration(
                color: AppColors.fastingMarker,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              weekendTextStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Selected Tradition: ${fastingService.tradition.displayName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Center(
              child: _buildInfoCard(isDarkMode),
            ),
          ),
        ],
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
        color: isDarkMode ? AppColors.fastingBackgroundDark : AppColors.fastingBackgroundLight,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.restaurant_menu, color: AppColors.accent),
              const SizedBox(height: 8),
              Text(
                fastType,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text('Standard Fasting rules apply.', textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return const Text('No fasting today.', style: TextStyle(color: AppColors.noFastingText));
  }
}
