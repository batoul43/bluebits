import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/widget/chat_bot_fab.dart';
import 'package:bluebits_app/core/widget/custom_app_bar.dart';
import 'package:bluebits_app/features/home/presentation/widget/section_title_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/state_card_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/update_item_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/wellcom_widget.dart';
import 'package:bluebits_app/features/lectures/presentation/screen/lectures_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // تعريف متغيرات الثيم لتسهيل الاستخدام
    final theme = Theme.of(context);

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

  // // بناء القائمة الجانبية مع ألوان ديناميكية
  // Widget _buildSideDrawer(double width, BuildContext context) {
  //   final colorScheme = Theme.of(context).colorScheme;
  //   return Drawer(
  //     width: width * 0.75,
  //     backgroundColor: colorScheme.surface, // يتغير حسب الثيم
  //     child: Column(
  //       children: [
  //         UserAccountsDrawerHeader(
  //           decoration: BoxDecoration(color: colorScheme.surface),
  //           currentAccountPicture: CircleAvatar(
  //             backgroundColor: colorScheme.primary.withOpacity(0.1),
  //             child: Icon(
  //               Icons.person,
  //               size: width * 0.1,
  //               color: colorScheme.primary,
  //             ),
  //           ),
  //           accountName: Text(
  //             "بتول كبة",
  //             style: TextStyle(
  //               color: colorScheme.onSurface,
  //               fontWeight: FontWeight.bold,
  //               fontSize: width * 0.045,
  //             ),
  //           ),
  //           accountEmail: Text(
  //             "Informatics Engineering",
  //             style: TextStyle(color: ColorsManager.greyText),
  //           ),
  //         ),
  //         Expanded(
  //           child: ListView(
  //             padding: EdgeInsets.zero,
  //             children: [
  //               _buildDrawerTile(
  //                 0,
  //                 Icons.home_outlined,
  //                 "الرئيسية",
  //                 width,
  //                 context,
  //               ),
  //               _buildDrawerTile(
  //                 1,
  //                 Icons.book_outlined,
  //                 "المحاضرات",
  //                 width,
  //                 context,
  //               ),
  //               _buildDrawerTile(
  //                 2,
  //                 Icons.quiz_outlined,
  //                 "بنوك الأسئلة",
  //                 width,
  //                 context,
  //               ),
  //               _buildDrawerTile(
  //                 3,
  //                 Icons.task_alt,
  //                 "قائمة المهام",
  //                 width,
  //                 context,
  //               ),
  //             ],
  //           ),
  //         ),
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.logout, color: ColorsManager.redaccent),
  //           title: const Text(
  //             "تسجيل الخروج",
  //             style: TextStyle(color: ColorsManager.redaccent),
  //           ),
  //           onTap: () {},
  //         ),
  //         const SizedBox(height: 20),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildDrawerTile(
  //   int index,
  //   IconData icon,
  //   String title,
  //   double width,
  //   BuildContext context,
  // ) {
  //   final bool isSelected = _selectedDrawerIndex == index;
  //   final colorScheme = Theme.of(context).colorScheme;

  //   return StatefulBuilder(
  //     builder: (context, setStateDrowerTile) {
  //       return Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //         decoration: BoxDecoration(
  //           color: isSelected ? colorScheme.primary : Colors.transparent,
  //           borderRadius: BorderRadius.circular(15),
  //         ),
  //         child: ListTile(
  //           leading: Icon(
  //             icon,
  //             color: isSelected
  //                 ? colorScheme.onPrimary
  //                 : ColorsManager.blueGrey,
  //           ),
  //           title: Text(
  //             title,
  //             style: TextStyle(
  //               color: isSelected
  //                   ? colorScheme.onPrimary
  //                   : colorScheme.onSurface,
  //               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
  //             ),
  //           ),
  //           onTap: () {
  //             setStateDrowerTile(() => _selectedDrawerIndex = index);
  //             Navigator.pop(context);
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) {
  //                   // هنا يمكنك توجيه المستخدم إلى الشاشة المناسبة بناءً على index
  //                   switch (index) {
  //                     case 0:
  //                       return HomeScreen(); // أو أي شاشة رئيسية أخرى
  //                     case 1:
  //                       return LecturesScreen();
  //                   }
  //                   return HomeScreen();
  //                 },
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // PreferredSizeWidget _buildCustomAppBar(double width, BuildContext context) {
  //   final colorScheme = Theme.of(context).colorScheme;
  //   return AppBar(
  //     backgroundColor: colorScheme.surface,
  //     title: Row(
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Text("Blue Bits", style: Theme.of(context).textTheme.titleMedium),
  //         const SizedBox(width: 8),
  //         Container(
  //           padding: const EdgeInsets.all(6),
  //           decoration: BoxDecoration(
  //             color: colorScheme.primary,
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: Icon(
  //             Icons.psychology,
  //             color: colorScheme.onPrimary,
  //             size: width * 0.06,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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

  // Widget _buildChatBotButton(double width, BuildContext context) {
  //   return FloatingActionButton(
  //     onPressed: () {},
  //     child: const Icon(Icons.smart_toy_outlined),
  //   );
  // }
}
