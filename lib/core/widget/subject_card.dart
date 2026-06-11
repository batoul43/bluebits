import 'package:bluebits_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final String title;
  final String year;
  final VoidCallback onTap;
  final bool? isbank;
  final Icon? icon;
  const SubjectCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.year,
    this.isbank,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة لضبط الأبعاد بشكل متناسب
    final double screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      // مسافات خارجية لضمان التباعد بين الكروت كما في الصورة
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02,
        horizontal: screenWidth * 0.05,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          // الارتفاع متناسب مع عرض الشاشة
          height: screenWidth * 0.22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // يستخدم لون الـ surface ليدعم الوضع الداكن والفاتح تلقائياً
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              // حدود رقيقة جداً بلون خفيف كما في التصميم
              color: colorScheme.onSurface.withOpacity(0.08),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    // التحكم في لون النص ليكون واضحاً حسب الثيم
                    color: colorScheme.onSurface.withOpacity(0.85),
                    fontWeight: FontWeight.w500,
                    fontSize: screenWidth * 0.045,
                  ),
                ),
                isbank == true
                    ? Icon(
                        Icons.help_outline_rounded,
                        color: ColorsManager.orange,
                        size: 22,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
