import 'package:flutter/material.dart';

class ColorsManager {
  // --- الألوان الأساسية (Main Palette) ---
  static const Color blue = Color(0xFF247CFF); // اللون الأساسي للتطبيق
  static const Color darkBlue = Color(0xFF0D1B2E); // خلفية الوضع الليلي
  static const Color deepNavy = Color(0xFF1A2B42); // اللون الثانوي للوضع الليلي
  static const Color cyan = Color(0xFF00E5FF); // لون الأكشن في الوضع الليلي
  static const Color lightBlue = Color(0xFFF4F7FF); // خلفية الوضع الفاتح

  // --- ألوان النصوص (Text Specific) ---
  static const Color blueText = Color(0xFF1A237E); // للعناوين في الوضع الفاتح
  static const Color whiteText = Color(0xFFFFFFFF);
  static const Color blackText = Color(0xFF1E293B);
  static const Color greyText = Color(0xFF64748c);
  static const Color darkGreyText = Color(0xFF9E9E9E);

  // --- الألوان الإضافية والتنبيهات ---
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color black = Colors.black;
  static const Color redaccent = Colors.redAccent;
  static const Color green = Colors.green;
  static const Color orange = Colors.orange;
  static const Color purple = Colors.purple;
  static const Color purpleAccent = Colors.purpleAccent;
  static const Color blueGrey = Colors.blueGrey;

  // --- التدرجات (Gradients) ---
  static const List<Color> backgroundGradient = [
    Color(0xFF04466C),
    Color(0xFF092D6B),
    Color(0xff08101F),
  ];

  static const List<Color> welcomeCardGradient = [
    Color(0xFF2962FF),
    Color(0xFF536DFE),
  ];
}
