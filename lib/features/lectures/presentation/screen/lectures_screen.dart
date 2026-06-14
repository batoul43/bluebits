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
        child: BlocBuilder<LecturesCubit, LecturesState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. عنوان الصفحة ووصفها
                  PageHeader(
                    title: state is DisplayYears || state is LecturesInitial
                        ? "مستودع المحاضرات"
                        : state is DisplaySemesters
                        ? state.selectedYear
                        : state is DisplaySubjects
                        ? state.selectedSubject
                        : "مستودع المحاضرات",
                    subtitle: state is DisplayYears || state is LecturesInitial
                        ? "تصفح وحمل المحاضرات الأكاديمية المنظمة"
                        : state is DisplaySubjects
                        ? "اختر المادة المطلوبة"
                        : 'اختر الفصل الدراسي',
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // 2. شريط البحث الموحد
                  AppSearchBar(
                    hintText: "ابحث عن محاضرة بسرعة (مثال: خوارزميات)...",
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  // 3. حاوية البطاقات (الجسم الرئيسي للشاشة)
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    // تم تبسيط الشروط المنطقية هنا
                    child: (state is DisplayYears || state is LecturesInitial)
                        ? BlocBuilder<YearCubit, YearState>(
                            builder: (context, yearState) {
                              if (yearState is YearLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (yearState is YearError) {
                                return Center(
                                  child: Text(
                                    yearState.message,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                );
                              } else if (yearState is YearLoaded) {
                                final yearsList = yearState.years;

                                if (yearsList.isEmpty) {
                                  return const Center(
                                    child: Text(
                                      "لا توجد سنوات دراسية مضافة بعد",
                                    ),
                                  );
                                }

                                return Expanded(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: screenWidth > 600
                                              ? 3
                                              : 2,
                                          crossAxisSpacing: 15,
                                          mainAxisSpacing: 15,
                                          childAspectRatio: 0.85,
                                        ),
                                    itemCount: yearsList.length,
                                    itemBuilder: (context, index) {
                                      final yearItem = yearsList[index];
                                      final yearTitle =
                                          yearItem.name?.toString() ??
                                          "بدون اسم";
                                      final selectedYear =
                                          yearItem.name?.toString() ?? "";

                                      return YearCard(
                                        title: yearTitle,
                                        onTap: () {
                                          context
                                              .read<LecturesCubit>()
                                              .displaySemesters(selectedYear);
                                        },
                                      );
                                    },
                                  ),
                                );
                              }
                              // كحالة افتراضية
                              return const SizedBox();
                            },
                          )
                        : Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  child: Text(
                                    state is DisplaySubjects
                                        ? "تغيير الفصل"
                                        : "تغيير السنة",
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (state is DisplaySubjects) {
                                      context
                                          .read<LecturesCubit>()
                                          .displaySemesters(state.selectedYear);
                                    } else if (state is DisplaySemesters) {
                                      context
                                          .read<LecturesCubit>()
                                          .backTOYear();
                                    }
                                  },
                                ),
                              ),
                              if (state is DisplaySemesters)
                                Column(
                                  children: [
                                    SemesterCard(
                                      title: 'الفصل الأول',
                                      onTap: () {
                                        context
                                            .read<LecturesCubit>()
                                            .displaySubjects(
                                              state.selectedYear,
                                              'الفصل الأول',
                                            );
                                      },
                                      year: state.selectedYear,
                                    ),
                                    SemesterCard(
                                      title: 'الفصل الثاني',
                                      onTap: () {
                                        context
                                            .read<LecturesCubit>()
                                            .displaySubjects(
                                              state.selectedYear,
                                              'الفصل الثاني',
                                            );
                                      },
                                      year: state.selectedYear,
                                    ),
                                  ],
                                ),
                              if (state is DisplaySubjects)
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return SubjectCard(
                                      onTap: () {},
                                      year: state.selectedYear,
                                      title: 'المادة ${index + 1}',
                                    );
                                  },
                                ),
                            ],
                          ),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
