import 'package:bluebits_app/core/constant/constant.dart';
import 'package:bluebits_app/core/shares/acadimic_tasks/logic/academic_task_cubit.dart';
import 'package:bluebits_app/core/shares/announcement/logic/announcement_cubit.dart';
import 'package:bluebits_app/core/shares/lessonslacture/lessonlecturecubit/lesson_lecture_cubit.dart';
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/home/presentation/widget/section_title_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/state_card_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/update_item_widget.dart';
import 'package:bluebits_app/features/home/presentation/widget/wellcom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // متغير لحفظ السنة الدراسية المحددة للفلترة
  String? selectedYear;

  @override
  void initState() {
    super.initState();
    context.read<AnnouncementCubit>().fetchAllAnnouncements();
    context.read<LessonLectureCubit>().fetchAllLectures();
    context.read<AcademicTaskCubit>().fetchAllAcademicTasks();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),

              SectionTitleWidget(
                title: "إحصائياتك اليومية",
                width: screenWidth,
                context: context,
              ),
              SizedBox(height: screenHeight * 0.015),

              // ==========================================
              // قسم إحصاء المحاضرات ديناميكياً حسب السنة والمادة
              // ==========================================
              BlocBuilder<LessonLectureCubit, LessonLectureState>(
                builder: (context, state) {
                  if (state is LessonLectureLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (state is LessonLecturesLoaded) {
                    final lectures = state.lessonLectures;

                    if (lectures.isEmpty) {
                      return StateCardWidget(
                        title: "محاضرات متوفرة",
                        value: "0",
                        icon: Icons.insert_drive_file_outlined,
                        color: ColorsManager.blue,
                        width: screenWidth,
                        context: context,
                      );
                    }

                    // 1. استخراج قائمة السنوات المتاحة من المسار: l.subjectId -> yearId -> name
                    final availableYears = lectures
                        .map(
                          (l) =>
                              l.subjectId?.yearId?.name?.toString() ??
                              'غير محدد',
                        )
                        .toSet()
                        .toList();

                    // تحديد السنة الأولى كافتراضية
                    selectedYear ??= availableYears.isNotEmpty
                        ? availableYears.first
                        : null;

                    // 2. فلترة المحاضرات حسب السنة المحددة
                    final filteredLectures = lectures.where((l) {
                      final yearName =
                          l.subjectId?.yearId?.name?.toString() ?? 'غير محدد';
                      return yearName == selectedYear;
                    }).toList();

                    // 3. حساب عدد المحاضرات لكل مادة داخل السنة المحددة
                    final Map<String, int> subjectCounts = {};
                    for (final lecture in filteredLectures) {
                      final subjectName =
                          lecture.subjectId?.name?.toString() ??
                          'مادة غير محددة';
                      subjectCounts[subjectName] =
                          (subjectCounts[subjectName] ?? 0) + 1;
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // قائمة اختيار السنة الدراسية
                        if (availableYears.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: ColorsManager.blue.withOpacity(0.3),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedYear,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: ColorsManager.blue,
                                ),
                                hint: const Text("اختر السنة الدراسية"),
                                items: availableYears.map((year) {
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text(
                                      "السنة الدراسية: $year",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedYear = value;
                                  });
                                },
                              ),
                            ),
                          ),

                        // إجمالي المحاضرات للسنة المحددة
                        StateCardWidget(
                          title: "إجمالي محاضرات $selectedYear",
                          value: filteredLectures.length.toString(),
                          icon: Icons.insert_drive_file_outlined,
                          color: ColorsManager.blue,
                          width: screenWidth,
                          context: context,
                        ),

                        // قائمة المحاضرات المحصاة لكل مادة
                        if (subjectCounts.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: Text("لا توجد محاضرات مضافة لهذه السنة"),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: subjectCounts.length,
                            itemBuilder: (context, index) {
                              final subjectName = subjectCounts.keys.elementAt(
                                index,
                              );
                              final count = subjectCounts[subjectName]!;

                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: StateCardWidget(
                                  title: "محاضرات $subjectName",
                                  value: count.toString(),
                                  icon: Icons.menu_book_rounded,
                                  color: ColorsManager.blue,
                                  width: screenWidth,
                                  context: context,
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  } else if (state is LessonLectureError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  return StateCardWidget(
                    title: "محاضرات متوفرة",
                    value: "...",
                    icon: Icons.insert_drive_file_outlined,
                    color: ColorsManager.blue,
                    width: screenWidth,
                    context: context,
                  );
                },
              ),
              // ==========================================

              SizedBox(height: screenHeight * 0.015),

              // بطاقة المهام المنجزة
              ValueListenableBuilder<int>(
                valueListenable: completedTasksNotifier,
                builder: (context, completedCount, child) {
                  return StateCardWidget(
                    title: "مهام شخصية منجزة",
                    value: completedCount.toString(),
                    icon: Icons.check_circle_outline,
                    color: ColorsManager.green,
                    width: screenWidth,
                    context: context,
                  );
                },
              ),

              // بطاقات إحصائيات المهام الأكاديمية (مفتوحة ومغلقة)
              BlocBuilder<AcademicTaskCubit, AcademicTaskState>(
                builder: (context, state) {
                  String openTasksCount = "...";
                  String closedTasksCount = "...";

                  if (state is AcademicTasksLoaded) {
                    openTasksCount = state.tasks
                        .where((task) => task.status != 'closed')
                        .length
                        .toString();
                    closedTasksCount = state.tasks
                        .where((task) => task.status == 'closed')
                        .length
                        .toString();
                  } else if (state is AcademicTaskError) {
                    openTasksCount = "0";
                    closedTasksCount = "0";
                  }

                  return Column(
                    children: [
                      StateCardWidget(
                        title: "مهام أكاديمية مفتوحة",
                        value: openTasksCount,
                        icon: Icons.assignment_outlined,
                        color: ColorsManager.orange,
                        width: screenWidth,
                        context: context,
                      ),
                      StateCardWidget(
                        title: "مهام أكاديمية مغلقة",
                        value: closedTasksCount,
                        icon: Icons.task_alt,
                        color: ColorsManager.blue,
                        width: screenWidth,
                        context: context,
                      ),
                    ],
                  );
                },
              ),

              // StateCardWidget(
              //   title: "أيام للامتحان",
              //   value: "28",
              //   icon: Icons.calendar_today_outlined,
              //   color: ColorsManager.purple,
              //   width: screenWidth,
              //   context: context,
              // ),
              SizedBox(height: screenHeight * 0.03),

              // عنوان الإعلانات
              SectionTitleWidget(
                title: "الإعلانات",
                width: screenWidth,
                context: context,
              ),
              SizedBox(height: screenHeight * 0.015),

              // ودجت الإعلانات الديناميكية
              _buildAnnouncementsSection(screenWidth, screenHeight),

              SizedBox(height: screenHeight * 0.03),
              _buildGamificationCard(screenWidth, context),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementsSection(double screenWidth, double screenHeight) {
    return BlocBuilder<AnnouncementCubit, AnnouncementState>(
      builder: (context, state) {
        if (state is AnnouncementLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AnnouncementError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (state is AnnouncementsLoaded) {
          final announcements = state.announcements;

          if (announcements == null || announcements.isEmpty) {
            return const Center(child: Text("لا توجد إعلانات حالياً"));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
              final colors = [
                ColorsManager.blue,
                ColorsManager.purple,
                ColorsManager.orange,
              ];
              final sideColor = colors[index % colors.length];

              return Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                child: UpdateItemWidget(
                  text: "${announcement.title}\n${announcement.content}",
                  sideColor: sideColor,
                  width: screenWidth,
                  context: context,
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
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
}
