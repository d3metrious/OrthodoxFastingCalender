import 'package:flutter/material.dart';
import 'pages/calendar_page.dart';
import 'utils/app_colors.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const FastingCalendarApp());
}

class FastingCalendarApp extends StatelessWidget {
  const FastingCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder listens to themeService and rebuilds whenever notifyListeners() is called
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        return MaterialApp(
          title: 'Church Fasting Calendar',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          // Now controlled by our service
          themeMode: themeService.themeMode,
          home: const CalendarPage(),
        );
      },
    );
  }
}
