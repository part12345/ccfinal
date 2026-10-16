import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF5B4BDB);
  static const Color primaryLight = Color(0xFFF0EEFF);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleLight = Color(0xFFF3E8FF);
  static const Color blue = Color(0xFF3984F6);
  static const Color blueLight = Color(0xFFEAF3FF);
  static const Color green = Color(0xFF0FAF86);
  static const Color greenLight = Color(0xFFE4FAF2);
  static const Color orange = Color(0xFFEF9A36);
  static const Color orangeLight = Color(0xFFFFF4E3);
  static const Color red = Color(0xFFE65B70);
  static const Color redLight = Color(0xFFFFE9ED);
  static const Color background = Color(0xFFF6F7FC);
  static const Color card = Colors.white;
  static const Color textDark = Color(0xFF202044);
  static const Color textMedium = Color(0xFF777B98);
  static const Color border = Color(0xFFE8E9F3);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: Colors.white,
    ).copyWith(
      primary: AppColors.primary,
      secondary: AppColors.purple,
      onSurface: AppColors.textDark,
      onSurfaceVariant: AppColors.textMedium,
      outline: AppColors.border,
      surfaceContainerHighest: const Color(0xFFF0EFFB),
    ),
    fontFamily: 'Arial',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      foregroundColor: AppColors.textDark,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textDark, letterSpacing: -0.5),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      hintStyle: const TextStyle(color: Color(0xFF9A9DB4), fontSize: 13),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: AppColors.border)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: Colors.white,
      indicatorColor: const Color(0xFFEAE7FF),
      elevation: 12,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(fontSize: 11, fontWeight: states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500, color: states.contains(WidgetState.selected) ? AppColors.primary : AppColors.textMedium)),
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(size: 22, color: states.contains(WidgetState.selected) ? AppColors.primary : AppColors.textMedium)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary, foregroundColor: Colors.white,
      elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    )),
    dividerColor: AppColors.border,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D1020),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFA99CFF), onPrimary: Color(0xFF17132E),
      secondary: Color(0xFFC4B5FD), surface: Color(0xFF171B2D), onSurface: Color(0xFFF5F4FF),
      onSurfaceVariant: Color(0xFFB3B8D0), outline: Color(0xFF30364F),
      primaryContainer: Color(0xFF30295B), onPrimaryContainer: Color(0xFFECE8FF),
      surfaceContainerHighest: Color(0xFF232641),
      error: Color(0xFFFF8A9A), onError: Color(0xFF310909),
    ),
    fontFamily: 'Arial',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0D1020), foregroundColor: Color(0xFFF5F4FF), elevation: 0,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFFF5F4FF), letterSpacing: -0.5),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: const Color(0xFF1B2036),
      labelStyle: const TextStyle(color: Color(0xFFB3B8D0)), hintStyle: const TextStyle(color: Color(0xFF8991AF)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF30364F))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF30364F))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFA99CFF), width: 1.5)),
    ),
    cardTheme: CardThemeData(color: const Color(0xFF171B2D), elevation: 0, margin: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: const BorderSide(color: Color(0xFF30364F)))),
    navigationBarTheme: NavigationBarThemeData(
      height: 72, backgroundColor: const Color(0xFF15192A), indicatorColor: const Color(0xFF30295B), elevation: 12,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(fontSize: 11, fontWeight: states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500, color: states.contains(WidgetState.selected) ? const Color(0xFFA99CFF) : const Color(0xFFB3B8D0))),
      iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(size: 22, color: states.contains(WidgetState.selected) ? const Color(0xFFA99CFF) : const Color(0xFFB3B8D0))),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA99CFF), foregroundColor: const Color(0xFF17132E), elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), textStyle: const TextStyle(fontWeight: FontWeight.w700))),
    dividerColor: const Color(0xFF30364F),
  );
}
