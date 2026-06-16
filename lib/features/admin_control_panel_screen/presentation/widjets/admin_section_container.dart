import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              Icon(icon, color: color, size: screenWidth * 0.07),
              SizedBox(width: screenWidth * 0.03),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
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
