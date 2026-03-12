import 'package:fastingcalender/models/app_font.dart';
import 'package:fastingcalender/pages/calendar_page.dart';
import 'package:fastingcalender/services/fasting_service.dart';
import 'package:fastingcalender/services/theme_service.dart';
import 'package:fastingcalender/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return ListenableBuilder(
      listenable: themeService,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: fastingService,
          builder: (context, child) {
            final TextTheme textTheme = themeService.appFont == AppFont.serif
                ? GoogleFonts.notoSerifTextTheme()
                : GoogleFonts.notoSansTextTheme();

            final TextTheme darkTextTheme = themeService.appFont == AppFont.serif
                ? GoogleFonts.notoSerifTextTheme(ThemeData(brightness: Brightness.dark).textTheme)
                : GoogleFonts.notoSansTextTheme(ThemeData(brightness: Brightness.dark).textTheme);

            return MaterialApp(
              title: 'Church Fasting Calendar',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary,
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
                textTheme: textTheme,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppColors.primary,
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
                textTheme: darkTextTheme,
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
