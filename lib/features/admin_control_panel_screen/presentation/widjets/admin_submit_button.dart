import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminSubmitButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isDestructive;

  const AdminSubmitButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      height: screenWidth * 0.12,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive
              ? theme.colorScheme.error
              : theme.colorScheme.primary,
          foregroundColor: isDestructive
              ? theme.colorScheme.onError
              : theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
