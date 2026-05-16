import 'package:flutter/material.dart';

class SemesterCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final String year;

  const SemesterCard({
    super.key,
    required this.title,
    required this.onTap,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02,
        horizontal: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        color: colorScheme
            .surface, // يتغير حسب الثيم (White في الفاتح و DeepNavy في الداكن)
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenWidth * 0.03,
        ),
        child: Row(
          children: [
            // الأيقونة جهة اليسار كما في الصورة
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: InkWell(
                onTap: onTap,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: screenWidth * 0.08,
                  color: colorScheme.primary.withOpacity(0.6),
                ),
              ),
            ),
            Spacer(),
            // النص جهة اليمين (يدعم RTL تلقائياً)
            Text(
              title,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
