import 'package:bluebits_app/core/theming/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerIndex = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // تعريف متغيرات الثيم لتسهيل الاستخدام
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // استخدام خلفية السكافولد من الثيم
        backgroundColor: theme.scaffoldBackgroundColor,
        drawer: _buildSideDrawer(screenWidth, context),
        appBar: _buildCustomAppBar(screenWidth, context),
        floatingActionButton: _buildChatBotButton(screenWidth, context),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeBanner(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.03),

                _buildSectionTitle("إحصائياتك اليومية", screenWidth, context),
                SizedBox(height: screenHeight * 0.015),

                // ملاحظة: الألوان الفرعية مثل الأخضر والبرتقالي تبقى ثابتة للتميز
                _buildStatCard(
                  "محاضرات متوفرة",
                  "+150",
                  Icons.insert_drive_file_outlined,
                  ColorsManager.blue,
                  screenWidth,
                  context,
                ),
                _buildStatCard(
                  "مهام منجزة",
                  "1",
                  Icons.check_circle_outline,
                  ColorsManager.green,
                  screenWidth,
                  context,
                ),
                _buildStatCard(
                  "أيام للامتحان",
                  "28",
                  Icons.calendar_today_outlined,
                  ColorsManager.purple,
                  screenWidth,
                  context,
                ),
                _buildStatCard(
                  "معدل الإنجاز",
                  "50%",
                  Icons.trending_up,
                  ColorsManager.orange,
                  screenWidth,
                  context,
                ),

                SizedBox(height: screenHeight * 0.03),

                _buildSectionTitle("آخر التحديثات", screenWidth, context),
                SizedBox(height: screenHeight * 0.015),
                _buildUpdateItem(
                  "تمت إضافة بنك أسئلة مادة \"الذكاء الاصطناعي\".",
                  ColorsManager.blue,
                  screenWidth,
                  context,
                ),
                _buildUpdateItem(
                  "رفع محاضرات الأسبوع الخامس لمواد السنة الثالثة.",
                  ColorsManager.purple,
                  screenWidth,
                  context,
                ),
                _buildUpdateItem(
                  "تحديث نظام الـ Todo ليدعم تتبع المحاضرات بدقة.",
                  ColorsManager.purpleAccent,
                  screenWidth,
                  context,
                ),

                SizedBox(height: screenHeight * 0.03),
                _buildGamificationCard(screenWidth, context),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // بناء القائمة الجانبية مع ألوان ديناميكية
  Widget _buildSideDrawer(double width, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      width: width * 0.75,
      backgroundColor: colorScheme.surface, // يتغير حسب الثيم
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: colorScheme.surface),
            currentAccountPicture: CircleAvatar(
              backgroundColor: colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: width * 0.1,
                color: colorScheme.primary,
              ),
            ),
            accountName: Text(
              "بتول كبة",
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: width * 0.045,
              ),
            ),
            accountEmail: Text(
              "Informatics Engineering",
              style: TextStyle(color: ColorsManager.greyText),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerTile(
                  0,
                  Icons.home_outlined,
                  "الرئيسية",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  1,
                  Icons.book_outlined,
                  "المحاضرات",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  2,
                  Icons.quiz_outlined,
                  "بنوك الأسئلة",
                  width,
                  context,
                ),
                _buildDrawerTile(
                  3,
                  Icons.task_alt,
                  "قائمة المهام",
                  width,
                  context,
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: ColorsManager.redaccent),
            title: const Text(
              "تسجيل الخروج",
              style: TextStyle(color: ColorsManager.redaccent),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
    int index,
    IconData icon,
    String title,
    double width,
    BuildContext context,
  ) {
    final bool isSelected = _selectedDrawerIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? colorScheme.onPrimary : ColorsManager.blueGrey,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          setState(() => _selectedDrawerIndex = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(double width, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: colorScheme.surface,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("Blue Bits", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 8),
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

  Widget _buildWelcomeBanner(double width, double height) {
    return Container(
      width: width,
      padding: EdgeInsets.all(width * 0.06),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    double width,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.06,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: width * 0.07),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(
    String text,
    Color sideColor,
    double width,
    BuildContext context,
  ) {
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

  Widget _buildSectionTitle(String title, double width, BuildContext context) {
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

  Widget _buildChatBotButton(double width, BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.smart_toy_outlined),
    );
  }
}
