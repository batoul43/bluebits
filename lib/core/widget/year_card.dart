import 'package:flutter/material.dart';

class YearCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const YearCard({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // إعدادات الميديا كويري للحصول على أبعاد الشاشة
    final double screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      // استخدام الميديا كويري لتحديد الارتفاع والعرض بشكل نسبي لضمان التناسق
      constraints: BoxConstraints(
        minHeight:
            screenWidth * 0.35, // يضمن عدم صغر البطاقة في الشاشات الصغيرة
      ),
      decoration: BoxDecoration(
        // استخدام لون الـ surface من الثيم بدلاً من الأبيض الثابت ليدعم الوضع الداكن
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(
          screenWidth * 0.05,
        ), // زوايا منحنية متناسبة مع الشاشة
        border: Border.all(
          // استخدام لون primary شفاف قليلاً بدلاً من اللون الثابت
          color: colorScheme.primary.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.03), // حواف داخلية مرنة
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  // حجم الأيقونة يتغير نسبياً مع حجم الشاشة
                  size: screenWidth * 0.12,
                  color: colorScheme.primary.withOpacity(0.7),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    // الخط سيأخذ لونه تلقائياً من onSurface (أبيض في الداكن، كحلي في الفاتح)
                    color: colorScheme.onSurface,
                    fontSize: screenWidth * 0.04, // حجم خط مرن
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
