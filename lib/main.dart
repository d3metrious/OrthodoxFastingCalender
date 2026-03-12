import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const FastingCalendarApp());
}

class FastingCalendarApp extends StatelessWidget {
  const FastingCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Church Fasting Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalendarPage(),
    );
  }
}

/// A simple service to handle fasting logic
class FastingService {
  static final Map<DateTime, String> _fixedFasts = {
    DateTime.utc(2023, 12, 24): 'Nativity Fast',
    DateTime.utc(2023, 12, 25): 'Feast of the Nativity',
  };

  static String? getFastingType(DateTime date) {
    // 1. Check fixed dates first
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    if (_fixedFasts.containsKey(normalizedDate)) {
      return _fixedFasts[normalizedDate];
    }

    // 2. Weekly fasts: Wednesday and Friday
    if (date.weekday == DateTime.wednesday) return 'Wednesday Fast';
    if (date.weekday == DateTime.friday) return 'Friday Fast';

    return null;
  }
}

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Church Fasting Calendar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            // Logic to show a marker if it's a fasting day
            eventLoader: (day) {
              final fast = FastingService.getFastingType(day);
              return fast != null ? [fast] : [];
            },
            calendarStyle: const CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: _buildInfoCard(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    if (_selectedDay == null) {
      return const Text('Select a day to see fasting details.');
    }

    final fastType = FastingService.getFastingType(_selectedDay!);
    if (fastType != null) {
      return Card(
        color: Colors.orange.shade50,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.restaurant_menu, color: Colors.orange),
              const SizedBox(height: 8),
              Text(
                fastType,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Text('Standard Fasting rules apply.'),
            ],
          ),
        ),
      );
    }

    return const Text('No fasting today.');
  }
}
