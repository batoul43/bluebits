import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/widget/chat_bot_fab.dart';
import 'package:bluebits_app/core/widget/custom_app_bar.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/home/presentation/home_screen.dart';
import 'package:bluebits_app/features/lectures/presentation/logic/cubit/lectures_cubit.dart';
import 'package:bluebits_app/features/lectures/presentation/screen/lectures_screen.dart';
import 'package:bluebits_app/features/question_banks/presentation/logic/cubit/bank_cubit.dart';
import 'package:bluebits_app/features/question_banks/presentation/screens/question_banks_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutApp extends StatelessWidget {
  LayoutApp({super.key});

  final ValueNotifier<int> _selectedDrawerIndex = ValueNotifier(0);

  final List<Widget> _pages = [
    HomeScreen(),
    LecturesScreen(),
    BlocProvider(
      create: (context) => BankCubit()..backTOYear(),
      child: QuestionBanksScreen(),
    ),
    // أضيفي باقي الصفحات هنا
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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
          child: ValueListenableBuilder(
            valueListenable: _selectedDrawerIndex,
            builder: (context, selectedDrawerIndex, child) {
              return IndexedStack(index: selectedDrawerIndex, children: _pages);
            },
          ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StatefulBuilder(
      builder: (context, setStateDrowerTile) {
        bool isSelected = _selectedDrawerIndex.value == index;
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
                  : colorScheme.onSurface.withOpacity(0.7),
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
              setStateDrowerTile(() {
                _selectedDrawerIndex.value = index;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildSideDrawer(double width, BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            accountEmail: Text(
              "Informatics Engineering",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ColorsManager.greyText,
              ),
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
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoading) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return AlertDialog(
                        content: Center(child: CircularProgressIndicator()),
                      );
                    },
                  );
                } else if (state is AuthLogoutSuccess) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SigninScreen()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
                  );
                }
              },
              child: Text(
                "تسجيل الخروج",
                style: TextStyle(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              context.read<AuthCubit>().logout();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
