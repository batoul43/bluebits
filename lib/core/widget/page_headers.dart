import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const PageHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          // يستخدم الإعدادات المحددة في AppTheme (اللون والخط العريض)
          style: theme.textTheme.displayLarge,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          // يستخدم الإعدادات المحددة في AppTheme للخطوط الثانوية
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
