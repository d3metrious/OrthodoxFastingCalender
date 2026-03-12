import 'package:fastingcalender/models/app_font.dart';
import 'package:fastingcalender/pages/calendar_page.dart';
import 'package:fastingcalender/services/fasting_service.dart';
import 'package:fastingcalender/services/theme_service.dart';
import 'package:fastingcalender/services/language_service.dart';
import 'package:fastingcalender/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting data
  await initializeDateFormatting();

  // Initialize all services
  await themeService.init();
  await fastingService.init();
  await languageService.init();

  runApp(const FastingCalendarApp());
}

class FastingCalendarApp extends StatelessWidget {
  const FastingCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Combine all services into a single listenable
    return ListenableBuilder(
      listenable: Listenable.merge([themeService, fastingService, languageService]),
      builder: (context, child) {
        final TextTheme textTheme = themeService.appFont == AppFont.serif
            ? GoogleFonts.notoSerifTextTheme()
            : GoogleFonts.notoSansTextTheme();

        final TextTheme darkTextTheme = themeService.appFont == AppFont.serif
            ? GoogleFonts.notoSerifTextTheme(ThemeData(brightness: Brightness.dark).textTheme)
            : GoogleFonts.notoSansTextTheme(ThemeData(brightness: Brightness.dark).textTheme);

        return MaterialApp(
          title: 'Church Fasting Calendar',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: AppColors.fastingBackgroundLight,
            useMaterial3: true,
            textTheme: textTheme,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              brightness: Brightness.dark,
            ).copyWith(
              surface: AppColors.fastingBackgroundDark,
            ),
            scaffoldBackgroundColor: AppColors.fastingBackgroundDark,
            useMaterial3: true,
            textTheme: darkTextTheme,
          ),
          themeMode: themeService.themeMode,
          home: const CalendarPage(),
        );
      },
    );
  }
}
