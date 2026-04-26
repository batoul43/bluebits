import 'package:bluebits_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SizedBox(
      width: size.width - 18 - 18, // ليأخذ العرض الكامل كما في التصميم
      height: 55, // ارتفاع مريح ومناسب للضغط
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.darkAccentCyan,
          foregroundColor: ColorsManager.textWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // زوايا منحنية تشبه الصور
          ),
          elevation: 5,
          shadowColor: ColorsManager.darkAccentCyan.withOpacity(
            0.4,
          ), // تأثير توهج خفيف
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
