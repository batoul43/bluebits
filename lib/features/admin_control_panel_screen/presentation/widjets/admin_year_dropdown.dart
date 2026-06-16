import 'package:bluebits_app/core/shares/years/models/year_model.dart';
import 'package:flutter/material.dart';

class AdminYearDropdown extends StatelessWidget {
  final String hint;
  final ValueNotifier<String?> notifier;
  final List<Data> yearsList;

  const AdminYearDropdown({
    super.key,
    required this.hint,
    required this.notifier,
    required this.yearsList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<String?>(
      valueListenable: notifier,
      builder: (context, value, child) {
        // حماية الواجهة في حال تم حذف السنة التي كانت محددة مسبقاً
        final isValueValid = yearsList.any((element) => element.sId == value);
        final safeValue = isValueValid ? value : null;

        return DropdownButtonFormField<String>(
          value: safeValue,
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
          items: yearsList.map((yearItem) {
            return DropdownMenuItem<String>(
              value: yearItem.sId,
              child: Text(
                yearItem.name ?? 'بدون اسم',
                style: theme.textTheme.bodyLarge,
              ),
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
