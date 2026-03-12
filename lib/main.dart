import 'package:flutter/material.dart';
import 'pages/calendar_page.dart';
import 'utils/app_colors.dart';
import 'services/theme_service.dart';
import 'services/fasting_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize both services
  await themeService.init();
  await fastingService.init();
  
  runApp(const FastingCalendarApp());
}

class FastingCalendarApp extends StatelessWidget {
  const FastingCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder can listen to multiple change notifiers using a Column of builders, 
    // but a cleaner way for multiple is using `MultiListenableBuilder` or just nested builders.
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: fastingService,
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
              themeMode: themeService.themeMode,
              home: const CalendarPage(),
            );
          },
        );
      },
    );
  }
}
