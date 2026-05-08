import 'package:bluebits_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // --- الثيم الفاتح (Light Theme) ---
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: ColorsManager.blue,
    scaffoldBackgroundColor: ColorsManager.lightBlue,

    colorScheme: ColorScheme.light(
      primary: ColorsManager.blue,
      onPrimary: ColorsManager.white,
      secondary: ColorsManager.blueText, // تم استخدامه للعناوين المميزة
      surface: ColorsManager.white,
      onSurface: ColorsManager.blackText,
      error: ColorsManager.redaccent,
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorsManager.blueText, // استخدام اسم اللون الجديد للنصوص
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorsManager.blueText,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: ColorsManager.blackText),
      bodyMedium: TextStyle(fontSize: 14, color: ColorsManager.greyText),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.white,
      elevation: 0,
      iconTheme: IconThemeData(color: ColorsManager.blueGrey),
      titleTextStyle: TextStyle(
        color: ColorsManager.blueText,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    inputDecorationTheme: _buildInputTheme(isDark: false),
    elevatedButtonTheme: _buildButtonTheme(isDark: false),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorsManager.blue,
      foregroundColor: ColorsManager.white,
    ),
  );

  // --- الثيم الداكن (Dark Theme) ---
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: ColorsManager.cyan,
    scaffoldBackgroundColor: ColorsManager.darkBlue,

    colorScheme: ColorScheme.dark(
      primary: ColorsManager.cyan,
      onPrimary: ColorsManager.darkBlue,
      secondary: ColorsManager.deepNavy,
      surface: ColorsManager.deepNavy,
      onSurface: ColorsManager.whiteText,
    ),

    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorsManager.whiteText,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: ColorsManager.whiteText,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: ColorsManager.whiteText),
      bodyMedium: TextStyle(fontSize: 14, color: ColorsManager.darkGreyText),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: ColorsManager.darkBlue,
      elevation: 0,
      iconTheme: IconThemeData(color: ColorsManager.whiteText),
    ),

    inputDecorationTheme: _buildInputTheme(isDark: true),
    elevatedButtonTheme: _buildButtonTheme(isDark: true),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ColorsManager.cyan,
      foregroundColor: ColorsManager.darkBlue,
    ),
  );

  static InputDecorationTheme _buildInputTheme({required bool isDark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? ColorsManager.deepNavy : ColorsManager.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark
              ? ColorsManager.cyan.withOpacity(0.2)
              : ColorsManager.blue.withOpacity(0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark ? ColorsManager.cyan : ColorsManager.blue,
          width: 2,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _buildButtonTheme({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? ColorsManager.cyan : ColorsManager.blue,
        foregroundColor: isDark ? ColorsManager.darkBlue : ColorsManager.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    );
  }
}
