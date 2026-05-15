import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;

  const AppSearchBar({super.key, required this.hintText, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // جلب الثيم الحالي للوصول إلى الألوان
    final theme = Theme.of(context);

    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        // الأيقونة تأخذ لونها الآن من لون bodyMedium المعرف في الثيم
        prefixIcon: Icon(
          Icons.search,
          color: theme.textTheme.bodyMedium?.color,
        ),
        // التصميم (Borders & FillColor) يتم جلبه تلقائياً من AppTheme عبر inputDecorationTheme
      ),
    );
  }
}
