import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/widget/chat_bot_fab.dart';
import 'package:bluebits_app/core/widget/custom_app_bar.dart';
import 'package:bluebits_app/features/home/presentation/home_screen.dart';
import 'package:bluebits_app/features/lectures/presentation/logic/cubit/lectures_cubit.dart';
import 'package:bluebits_app/features/lectures/presentation/screen/lectures_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutApp extends StatefulWidget {
  LayoutApp({super.key});

  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  int _selectedDrawerIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    LecturesScreen(),
    // أضيفي باقي الصفحات هنا
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // تعريف متغيرات الثيم لتسهيل الاستخدام
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: _buildSideDrawer(screenWidth, context),
      appBar: CustomAppBar(),
      floatingActionButton: ChatBotFab(),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => LecturesCubit()..backTOYear(),
          child: IndexedStack(index: _selectedDrawerIndex, children: _pages),
        ),
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

    return StatefulBuilder(
      builder: (context, setStateDrowerTile) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected
                  ? colorScheme.onPrimary
                  : ColorsManager.blueGrey,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            onTap: () {
              setState(() => _selectedDrawerIndex = index);

              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

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
}
