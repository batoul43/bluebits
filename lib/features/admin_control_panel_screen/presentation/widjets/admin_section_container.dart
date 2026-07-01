import 'package:flutter/material.dart';

class AdminSectionContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const AdminSectionContainer({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: screenWidth * 0.04,
            offset: Offset(0, screenWidth * 0.015),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 24), // الأيقونة الخاصة بك
              const SizedBox(width: 10), // المسافة
              Expanded(
                // <--- قمنا بإضافة Expanded هنا لاحتواء النص
                child: Text(
                  title, // المتغير الذي يحمل النص "إدارة المحاضرات..."
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  // يمكنك إضافة هذا السطر لضمان عدم حدوث مشاكل في حال كان النص طويلاً جداً
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 0.5),
          child,
        ],
      ),
    );
  }
}
