import 'package:flutter/material.dart';
import 'package:bluebits_app/core/theming/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showMenu;

  const CustomAppBar({super.key, this.title, this.showMenu = true});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      // أيقونة القائمة الجانبية
      leading: showMenu
          ? IconButton(
              icon: const Icon(Icons.menu, color: ColorsManager.blueGrey),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : null,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title ?? "Blue Bits",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          // شعار التطبيق (الدماغ)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.psychology,
              color: colorScheme.onPrimary,
              size: width * 0.06,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
