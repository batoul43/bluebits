import 'package:bluebits_app/core/theming/colors.dart';
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
            "أهلاً بك في منصة\nBlue Bits",
            style: TextStyle(
              color: ColorsManager.white,
              fontSize: width * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.white,
              foregroundColor: ColorsManager.blue,
            ),
            child: const Text("ابدأ الدراسة"),
          ),
        ],
      ),
    );
  }
}
