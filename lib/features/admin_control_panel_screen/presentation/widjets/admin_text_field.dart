import 'package:flutter/material.dart';

class AdminTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isNumber;
  final int maxLines;

  const AdminTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.isNumber = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }
}
