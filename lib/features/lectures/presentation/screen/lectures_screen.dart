import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/widget/subject_card.dart';
import 'package:bluebits_app/features/lectures/presentation/logic/cubit/lectures_cubit.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/app_search_headers.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/semester_card.dart';
import 'package:bluebits_app/core/widget/year_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LecturesScreen extends StatelessWidget {
  const LecturesScreen({super.key});

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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
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
                      title: state is DisplayYears || state is LecturesInitial
                          ? "مستودع المحاضرات"
                          : state is DisplaySemesters
                          ? state.selectedYear
                          : state is DisplaySubjects
                          ? state
                                .selectedSubject // هنا يعرض اسم الفصل كمسار
                          : "مستودع المحاضرات",
                      subtitle:
                          state is DisplayYears || state is LecturesInitial
                          ? "تصفح وحمل المحاضرات الأكاديمية المنظمة"
                          : state is DisplaySubjects
                          ? "اختر المادة المطلوبة"
                          : 'اختر الفصل الدراسي',
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // 2. شريط البحث
                    const AppSearchBar(
                      hintText: "ابحث عن محاضرة بسرعة (مثال: خوارزميات)...",
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // 3. المحتوى المتغير
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: _buildBodyContent(context, state, screenWidth),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(
    BuildContext context,
    LecturesState state,
    double screenWidth,
  ) {
    // 1. حالة عرض السنوات
    if (state is DisplayYears || state is LecturesInitial) {
      return BlocBuilder<YearCubit, YearState>(
        builder: (context, yearState) {
          if (yearState is YearLoading)
            return const Center(child: CircularProgressIndicator());
          if (yearState is YearError)
            return Center(
              child: Text(
                yearState.message,
                style: const TextStyle(color: Colors.red),
              ),
            );

          if (yearState is YearLoaded) {
            if (yearState.years.isEmpty)
              return const Center(child: Text("لا توجد سنوات دراسية"));

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600 ? 3 : 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.85,
              ),
              itemCount: yearState.years.length,
              itemBuilder: (context, index) {
                final yearItem = yearState.years[index];
                return YearCard(
                  title: yearItem.name ?? "بدون اسم",
                  onTap: () {
                    context.read<LecturesCubit>().displaySemesters(
                      yearItem.name ?? "",
                    );
                    context.read<SemesterCubit>().fetchAllSemesters();
                  },
                );
              },
            );
          }
          return const SizedBox();
        },
      );
    }

    // 2. حالة عرض الفصول والمواد
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: TextButton(
            onPressed: () {
              if (state is DisplaySubjects) {
                context.read<LecturesCubit>().displaySemesters(
                  state.selectedYear,
                );
              } else if (state is DisplaySemesters) {
                context.read<LecturesCubit>().backTOYear();
              }
            },
            child: Text(
              state is DisplaySubjects ? "تغيير الفصل" : "تغيير السنة",
            ),
          ),
        ),

        // عرض الفصول
        if (state is DisplaySemesters)
          BlocBuilder<SemesterCubit, SemesterState>(
            builder: (context, semesterState) {
              if (semesterState is SemesterLoading)
                return const Center(child: CircularProgressIndicator());
              if (semesterState is SemesterLoaded) {
                return Column(
                  children: semesterState.semesters.map((item) {
                    return SemesterCard(
                      title: item.name ?? "بدون اسم",
                      year: state.selectedYear,
                      onTap: () async {
                        // --- تصحيح: استخدام البحث الآمن لتجنب الانهيار (Crash) ---
                        final currentYearState = context
                            .read<YearCubit>()
                            .state;
                        String yearId = "";

                        if (currentYearState is YearLoaded) {
                          // نستخدم firstWhere مع orElse لإرجاع null بدلاً من عمل Crash
                          final matchedYear = currentYearState.years.firstWhere(
                            (y) => y.name == state.selectedYear,
                            orElse: () => currentYearState
                                .years
                                .first, // كخيار احتياطي أو معالجة خطأ
                          );
                          yearId = matchedYear.sId ?? "";
                        }

                        if (yearId.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("حدث خطأ في جلب بيانات السنة"),
                            ),
                          );
                          return;
                        }

                        if (context.mounted) {
                          context
                              .read<SubjectCubit>()
                              .getSubjectsByYearAndSemester(
                                yearId: yearId,
                                semesterId: item.id ?? "",
                              );

                          context.read<LecturesCubit>().displaySubjects(
                            state.selectedYear,
                            item.name ?? "",
                          );
                        }
                      },
                    );
                  }).toList(),
                );
              }
              return const SizedBox();
            },
          ),

        // عرض المواد
        if (state is DisplaySubjects)
          BlocBuilder<SubjectCubit, SubjectState>(
            builder: (context, subjectState) {
              if (subjectState is GetSubjectsLoading)
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              if (subjectState is GetSubjectsFailure)
                return Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(
                    child: Text(
                      subjectState.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );

              if (subjectState is GetSubjectsSuccess) {
                final subjectsList = subjectState.subjectModel.data ?? [];
                if (subjectsList.isEmpty)
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text("لا توجد مواد مضافة")),
                  );

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subjectsList.length,
                  itemBuilder: (context, index) {
                    final subjectItem = subjectsList[index];
                    return SubjectCard(
                      onTap: () {},
                      year: state.selectedYear,
                      title: subjectItem.name ?? "مادة بدون اسم",
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
      ],
    );
  }
}
