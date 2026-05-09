import 'package:flutter/material.dart';

class SectionTitleWidget extends StatelessWidget {
  const SectionTitleWidget({
    super.key,
    required this.title,
    required this.width,
    required this.context,
  });
  final String title;
  final double width;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.dashboard_customize_outlined,
          color: Theme.of(context).colorScheme.secondary,
          size: width * 0.05,
        ),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
