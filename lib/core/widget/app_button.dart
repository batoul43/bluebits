// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final double? hight;
  final double? width;
  final VoidCallback onPressed;
  const AppButton({
    super.key,
    required this.child,
    this.hight,
    this.width,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width ?? double.infinity,
      height: hight ?? 56.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDarkMode
            ? [
                BoxShadow(
                  color: ColorsManager.mainBlue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.mainBlue,
          elevation: 0,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16),
          ),
        ),

        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
