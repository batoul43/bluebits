import 'package:bluebits_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: ColorsManager.mainBlue,
    scaffoldBackgroundColor: ColorsManager.lightBackground,
    iconTheme: IconThemeData(color: ColorsManager.iconscolor),
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: ColorsManager.mainBlue,
      secondary: ColorsManager.lightSecondary,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorsManager.textBlack,
      ),
      bodyLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: ColorsManager.textBlack,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: ColorsManager.textGrey),
    ),
    inputDecorationTheme: _buildInputTheme(isDark: false),
    elevatedButtonTheme: _buildButtonTheme(isDark: false),
  );
  static ThemeData darkTheme = ThemeData(
    iconTheme: IconThemeData(color: ColorsManager.iconscolor),
    primaryColor: ColorsManager.darkAccentCyan,
    scaffoldBackgroundColor: ColorsManager.darkBackground,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: ColorsManager.darkAccentCyan,
      secondary: ColorsManager.darkSecondary,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorsManager.textWhite,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: ColorsManager.textWhite,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: ColorsManager.textGrey),
    ),
    inputDecorationTheme: _buildInputTheme(isDark: true),
    elevatedButtonTheme: _buildButtonTheme(isDark: true),
  );
  static InputDecorationTheme _buildInputTheme({required bool isDark}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark
          ? ColorsManager.darkSecondary
          : ColorsManager.lightSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isDark
              ? ColorsManager.darkAccentCyan.withOpacity(0.2)
              : ColorsManager.mainBlue.withOpacity(0.2),
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),

        borderSide: BorderSide(
          color: isDark ? ColorsManager.darkAccentCyan : ColorsManager.mainBlue,
          width: 2,
        ),
      ),
    );
  }

  static ElevatedButtonThemeData _buildButtonTheme({required bool isDark}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? ColorsManager.darkAccentCyan
            : ColorsManager.mainBlue,
        foregroundColor: isDark
            ? ColorsManager.darkBackground
            : ColorsManager.lightSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        elevation: 0,
      ),
    );
  }
}
