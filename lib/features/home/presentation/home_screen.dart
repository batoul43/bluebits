import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/home/presentation/widget/section_title_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/state_card_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/update_item_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/wellcom_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child:
          // Scaffold(
          //   // استخدام خلفية السكافولد من الثيم
          //   // backgroundColor: theme.scaffoldBackgroundColor,
          //   // drawer: _buildSideDrawer(screenWidth, context),
          //   // appBar: CustomAppBar(),
          //   // floatingActionButton: ChatBotFab(),
          //   body:
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WellcomWidget(
                    screenWidth,
                    screenHeight,
                    height: screenHeight * 0.3,
                    width: screenWidth * 0.9,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  SectionTitleWidget(
                    title: "إحصائياتك اليومية",
                    width: screenWidth,
                    context: context,
                  ),
                  SizedBox(height: screenHeight * 0.015),

                  // ملاحظة: الألوان الفرعية مثل الأخضر والبرتقالي تبقى ثابتة للتميز
                  StateCardWidget(
                    title: "محاضرات متوفرة",
                    value: "+150",
                    icon: Icons.insert_drive_file_outlined,
                    color: ColorsManager.blue,
                    width: screenWidth,
                    context: context,
                  ),
                  StateCardWidget(
                    title: "مهام منجزة",
                    value: "1",
                    icon: Icons.check_circle_outline,
                    color: ColorsManager.green,
                    width: screenWidth,
                    context: context,
                  ),
                  StateCardWidget(
                    title: "أيام للامتحان",
                    value: "28",
                    icon: Icons.calendar_today_outlined,
                    color: ColorsManager.purple,
                    width: screenWidth,
                    context: context,
                  ),
                  StateCardWidget(
                    title: 'معدل الإنجاز',
                    value: '50%',
                    icon: Icons.trending_up,
                    color: ColorsManager.orange,
                    width: screenWidth,
                    context: context,
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  SectionTitleWidget(
                    title: "آخر التحديثات",
                    width: screenWidth,
                    context: context,
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  UpdateItemWidget(
                    text: "تمت إضافة بنك أسئلة مادة \"الذكاء الاصطناعي\".",
                    sideColor: ColorsManager.blue,
                    width: screenWidth,
                    context: context,
                  ),
                  UpdateItemWidget(
                    text: "رفع محاضرات الأسبوع الخامس لمواد السنة الثالثة.",
                    sideColor: ColorsManager.purple,
                    width: screenWidth,
                    context: context,
                  ),
                  UpdateItemWidget(
                    text: "تحديث نظام الـ Todo ليدعم تتبع المحاضرات بدقة.",
                    sideColor: ColorsManager.orange,
                    width: screenWidth,
                    context: context,
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  _buildGamificationCard(screenWidth, context),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            ),
          ),
    );
    // );
  }

  Widget _buildGamificationCard(double width, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.06),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            color: ColorsManager.orange,
            size: width * 0.12,
          ),
          const SizedBox(height: 15),
          Text("نظام التحفيز", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            "أنهِ مهامك الأكاديمية لتحصل على نقاط وتنافس مع زملائك.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
