import 'package:flutter/material.dart';

class AdminSimpleDropdown extends StatelessWidget {
  final String hint;
  final ValueNotifier<String?> notifier;
  final List<String> items;

  const AdminSimpleDropdown({
    super.key,
    required this.hint,
    required this.notifier,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<String?>(
      valueListenable: notifier,
      builder: (context, value, child) {
        return DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.primary,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
          hint: Text(
            hint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: theme.textTheme.bodyLarge),
            );
          }).toList(),
          onChanged: (newValue) {
            notifier.value = newValue;
          },
          validator: (val) => val == null ? 'مطلوب' : null,
        );
      },
    );
  }
}
