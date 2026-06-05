import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/layout/layout_app.dart';
import 'package:flutter/material.dart';

class WellcomWidget extends StatelessWidget {
  const WellcomWidget(
    double screenWidth,
    double screenHeight, {
    super.key,
    required this.height,
    required this.width,
  });
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.06),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ColorsManager.welcomeCardGradient,
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(width * 0.06),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "أهلاً بك في منصة Blue Bits",
            style: theme.textTheme.displayLarge?.copyWith(
              // هنا نستخدم لون ثابت (White) فقط إذا كان الجرادينت دائماً غامق
              // أو نستخدم onPrimary ليكون متوافقاً مع الثيم
              color: ColorsManager.white,
              fontSize: width * 0.07, // نحافظ على التجاوب مع الحجم
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      LayoutApp(selectedDrawerIndex: ValueNotifier<int>(1)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.white.withOpacity(0.95),
              foregroundColor: ColorsManager.blue,
            ),
            child: const Text("ابدأ الدراسة"),
          ),
        ],
      ),
    );
  }
}
