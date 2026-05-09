import 'package:flutter/material.dart';

class UpdateItemWidget extends StatelessWidget {
  const UpdateItemWidget({
    super.key,
    required this.text,
    required this.sideColor,
    required this.width,
    required this.context,
  });
  final String text;
  final Color sideColor;
  final double width;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border(right: BorderSide(color: sideColor, width: 4)),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
