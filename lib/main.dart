import 'package:flutter/material.dart';
import 'pages/calendar_page.dart';

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
