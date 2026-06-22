import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/lessonslacture/lessonlecturecubit/lesson_lecture_cubit.dart';
import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/theming/colors.dart'; // الاعتماد على الألوان المخصصة للتطبيق
import 'package:bluebits_app/core/widget/subject_card.dart';
import 'package:bluebits_app/features/lectures/presentation/logic/cubit/lectures_cubit.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/app_search_headers.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/semester_card.dart';
import 'package:bluebits_app/core/widget/year_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key});

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  // حفظ المتغيرات داخل الـ State لضمان عدم فقدانها عند تحديث الواجهات
  String _yearId = '';
  String _semesterId = '';
  String _subjectId = '';
  String _selectedType = '';

  // دالة احترافية لفتح الروابط تتفادى قيود أندرويد 11+
  Future<void> _openLectureUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) {
      _showSnackBar("رابط المحاضرة غير متوفر حالياً", ColorsManager.orange);
      return;
    }

    final Uri url = Uri.parse(urlString);
    try {
      // محاولة الفتح في تطبيق خارجي أو المتصفح مباشرة
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      try {
        // محاولة بديلة في حال فشل الوضع الخارجي
        await launchUrl(url, mode: LaunchMode.platformDefault);
      } catch (innerError) {
        _showSnackBar("عذراً، تعذر فتح الرابط", ColorsManager.redaccent);
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            color: ColorsManager.white, // النص دائمًا أبيض فوق ألوان التنبيهات
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: BlocListener<SemesterCubit, SemesterState>(
          listener: (context, state) {
            if (state is SemesterError) {
              _showSnackBar(state.message, theme.colorScheme.error);
            }
          },
          child: BlocBuilder<LecturesCubit, LecturesState>(
            builder: (context, state) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. عنوان الصفحة
                    PageHeader(
                      title: _getPageTitle(state),
                      subtitle: _getPageSubtitle(state),
                    ),
                    const SizedBox(height: 20),

                    // 2. شريط البحث
                    const AppSearchBar(hintText: "ابحث عن محاضرة بسرعة..."),
                    const SizedBox(height: 25),

                    // 3. المحتوى الديناميكي المصمم بشكل متناسق واحترافي
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsManager.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _buildBodyContent(
                        context,
                        state,
                        screenWidth,
                        theme,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getPageTitle(LecturesState state) {
    if (state is DisplayYears || state is LecturesInitial)
      return "مستودع المحاضرات";
    if (state is DisplaySemesters) return state.selectedYear;
    if (state is DisplaySubjects) return state.selectedSemester;
    if (state is DisplayTypes) return state.selectedSubject;
    if (state is DisplayLecturesList) {
      return "${state.selectedSubject} - ${state.selectedType == 'theoretical' ? 'نظري' : 'عملي'}";
    }
    return "مستودع المحاضرات";
  }

  String _getPageSubtitle(LecturesState state) {
    if (state is DisplayYears || state is LecturesInitial)
      return "تصفح وحمل المحاضرات الأكاديمية المنظمة";
    if (state is DisplaySemesters) return 'اختر الفصل الدراسي';
    if (state is DisplaySubjects) return "اختر المادة المطلوبة";
    if (state is DisplayTypes) return "حدد نوع المحاضرات";
    if (state is DisplayLecturesList)
      return "قائمة المحاضرات المتاحة للتحميل والقراءة";
    return "";
  }

  Widget _buildBodyContent(
    BuildContext context,
    LecturesState state,
    double screenWidth,
    ThemeData theme,
  ) {
    // === 1. عرض السنوات الأكاديمية ===
    if (state is DisplayYears || state is LecturesInitial) {
      return BlocBuilder<YearCubit, YearState>(
        builder: (context, yearState) {
          if (yearState is YearLoading) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            );
          }
          if (yearState is YearError) {
            return Center(
              child: Text(
                yearState.message,
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          if (yearState is YearLoaded) {
            if (yearState.years.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد سنوات دراسية متاحة حالياً",
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: yearState.years.length,
              itemBuilder: (context, index) {
                final yearItem = yearState.years[index];
                return YearCard(
                  title: yearItem.name ?? "بدون اسم",
                  onTap: () {
                    setState(() {
                      _yearId = yearItem.sId ?? "";
                    });
                    context.read<LecturesCubit>().displaySemesters(
                      yearItem.name ?? "",
                    );
                    context.read<SemesterCubit>().fetchAllSemesters();
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      );
    }

    // === زر الرجوع الموحد لجميع المراحل ===
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
            ),
            onPressed: () {
              if (state is DisplaySemesters) {
                context.read<LecturesCubit>().backToYears();
              } else if (state is DisplaySubjects) {
                context.read<LecturesCubit>().displaySemesters(
                  state.selectedYear,
                );
              } else if (state is DisplayTypes) {
                context.read<LecturesCubit>().displaySubjects(
                  state.selectedYear,
                  state.selectedSemester,
                );
              } else if (state is DisplayLecturesList) {
                context.read<LecturesCubit>().displayTypes(
                  state.selectedYear,
                  state.selectedSemester,
                  state.selectedSubject,
                );
              }
            },
            icon: const Icon(Icons.arrow_forward_ios, size: 14),
            label: const Text(
              "رجوع",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Divider(height: 20, color: ColorsManager.blueGrey.withOpacity(0.2)),

        // === 2. عرض الفصول الدراسية ===
        if (state is DisplaySemesters)
          BlocBuilder<SemesterCubit, SemesterState>(
            builder: (context, semesterState) {
              if (semesterState is SemesterLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                );
              }
              if (semesterState is SemesterLoaded) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: semesterState.semesters.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = semesterState.semesters[index];
                    return SemesterCard(
                      title: item.name ?? "بدون اسم",
                      year: state.selectedYear,
                      onTap: () {
                        if (_yearId.isEmpty) return;
                        setState(() {
                          _semesterId = item.id ?? "";
                        });
                        context
                            .read<SubjectCubit>()
                            .getSubjectsByYearAndSemester(
                              yearId: _yearId,
                              semesterId: _semesterId,
                            );
                        context.read<LecturesCubit>().displaySubjects(
                          state.selectedYear,
                          item.name ?? "",
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),

        // === 3. عرض المواد الدراسية ===
        if (state is DisplaySubjects)
          BlocBuilder<SubjectCubit, SubjectState>(
            builder: (context, subjectState) {
              if (subjectState is GetSubjectsLoading) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              }
              if (subjectState is GetSubjectsFailure) {
                return Center(
                  child: Text(
                    subjectState.errorMessage,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              if (subjectState is GetSubjectsByYearAnsSemester) {
                final subjectsList =
                    subjectState.subjectsByYearSemester.data?.subjects ?? [];
                if (subjectsList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "لا توجد مواد دراسية مضافة",
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subjectsList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final subjectItem = subjectsList[index];
                    return SubjectCard(
                      title: subjectItem.name ?? "مادة بدون اسم",
                      year: state.selectedYear,
                      onTap: () {
                        setState(() {
                          _subjectId = subjectItem.sId ?? "";
                        });
                        context.read<LecturesCubit>().displayTypes(
                          state.selectedYear,
                          state.selectedSemester,
                          subjectItem.name ?? "مادة بدون اسم",
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),

        // === 4. عرض تصنيفات المحاضرة (نظري / عملي) ===
        if (state is DisplayTypes)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: _buildTypeSelectionCard(
                    context,
                    title: "المحاضرات النظرية",
                    icon: Icons.menu_book_rounded,
                    color: theme.colorScheme.primary,
                    onTap: () async {
                      setState(() {
                        _selectedType = 'theoretical';
                      });
                      await _fetchLectures(context, state);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTypeSelectionCard(
                    context,
                    title: "المحاضرات العملية",
                    icon: Icons.biotech_rounded,
                    color: ColorsManager.green, // من ملف الألوان الخاص بك
                    onTap: () async {
                      setState(() {
                        _selectedType = 'practical';
                      });
                      await _fetchLectures(context, state);
                    },
                  ),
                ),
              ],
            ),
          ),

        // === 5. عرض قائمة المحاضرات النهائية ===
        if (state is DisplayLecturesList)
          BlocBuilder<LessonLectureCubit, LessonLectureState>(
            builder: (context, lectureState) {
              if (lectureState is LessonLectureLoading) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                );
              }
              if (lectureState is LessonLectureError) {
                return Center(
                  child: Text(
                    lectureState.message,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              if (lectureState is LessonLecturesLoaded) {
                final lectures = lectureState.lessonLectures;
                if (lectures.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "لا توجد محاضرات متوفرة في هذا القسم حالياً",
                        style: TextStyle(color: ColorsManager.greyText),
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: lectures.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lecture = lectures[index];
                    final String fileType = (lecture.fileType ?? 'pdf')
                        .toUpperCase();

                    // تحويل حجم الملف ليظهر بالميغابايت بشكل صحيح (MB)
                    final String fileSizeFormatted = lecture.fileSize != null
                        ? '${(lecture.fileSize! / (1024 * 1024)).toStringAsFixed(2)} MB'
                        : 'غير محدد';

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: ColorsManager.blueGrey.withOpacity(0.2),
                        ),
                      ),
                      color: theme
                          .scaffoldBackgroundColor, // استخدام لون خلفية الثيم الداخلي
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorsManager.redaccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.picture_as_pdf_rounded,
                            color: ColorsManager.redaccent,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          lecture.title ?? "محاضرة بدون عنوان",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (lecture.description != null &&
                                  lecture.description!.isNotEmpty)
                                Text(
                                  lecture.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: ColorsManager.greyText,
                                    fontSize: 13,
                                  ),
                                ),
                              const SizedBox(height: 8),

                              // تم استخدام Wrap لضمان عدم حدوث طفح بالشاشة (Overflow) لو زاد حجم النص
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      fileType,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.data_usage_rounded,
                                    size: 14,
                                    color: ColorsManager.greyText,
                                  ),
                                  Text(
                                    fileSizeFormatted,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: ColorsManager.greyText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_circle_left_rounded,
                          color: theme.colorScheme.primary,
                          size: 30,
                        ),
                        onTap: () => _openLectureUrl(lecture.fileUrl),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
      ],
    );
  }

  Future<void> _fetchLectures(BuildContext context, DisplayTypes state) async {
    final token = await CachHelper.getValue('Token');
    if (!context.mounted) return;

    context.read<LessonLectureCubit>().fetchLecturesByYearSemesterSubjectType(
      token,
      _yearId,
      _semesterId,
      _subjectId,
      _selectedType,
    );

    context.read<LecturesCubit>().displayLecturesList(
      state.selectedYear,
      state.selectedSemester,
      state.selectedSubject,
      _selectedType,
    );
  }

  Widget _buildTypeSelectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
