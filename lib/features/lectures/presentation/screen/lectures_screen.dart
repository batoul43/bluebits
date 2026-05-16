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
    // استخدام MediaQuery لجعل التصميم متجاوباً كما ناقشنا سابقاً
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
                horizontal: screenWidth * 0.05, // نفس هوامش صفحة الـ Home
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. عنوان الصفحة ووصفها
                  PageHeader(
                    title: state is DisplaySemesters
                        ? state.selectedYear
                        : state is DisplaySubjects
                        ? state.selectedSubject
                        : "مستودع المحاضرات",
                    subtitle: state is DisplayYears
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
                      color: theme.colorScheme.surface, // اللون الأبيض من الثيم
                      borderRadius: BorderRadius.circular(
                        25,
                      ), // نفس انحناء بطاقات الـ Home
                    ),
                    child: state is DisplayYears
                        ? GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: screenWidth > 600 ? 3 : 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.85,
                            children: [
                              YearCard(
                                title: "السنة الأولى",
                                onTap: () {
                                  context
                                      .read<LecturesCubit>()
                                      .displaySemesters("السنة الأولى");
                                },
                              ),
                              YearCard(
                                title: "السنة الثانية",
                                onTap: () {
                                  context
                                      .read<LecturesCubit>()
                                      .displaySemesters("السنة الثانية");
                                },
                              ),
                              YearCard(
                                title: "السنة الثالثة",
                                onTap: () {
                                  context
                                      .read<LecturesCubit>()
                                      .displaySemesters("السنة الثالثة");
                                },
                              ),
                              YearCard(
                                title: "السنة الرابعة",
                                onTap: () {
                                  context
                                      .read<LecturesCubit>()
                                      .displaySemesters("السنة الرابعة");
                                },
                              ),
                            ],
                          )
                        : state is! DisplayYears
                        ? (Column(
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
                                      // العودة من المواد إلى الفصول
                                      context
                                          .read<LecturesCubit>()
                                          .displaySemesters(state.selectedYear);
                                    } else if (state is DisplaySemesters) {
                                      // العودة من الفصول إلى السنوات
                                      context
                                          .read<LecturesCubit>()
                                          .backTOYear();
                                    }
                                  },
                                ),
                              ),

                              state is DisplaySemesters
                                  ? Column(
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
                                    )
                                  : state is DisplaySubjects
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          5, // Replace with actual number of subjects
                                      itemBuilder: (context, index) {
                                        return SubjectCard(
                                          onTap: () {},
                                          year: state.selectedYear,
                                          title: 'المادة ${index + 1}',
                                        );
                                      },
                                    )
                                  : SizedBox(),
                            ],
                          ))
                        : Center(
                            child: Expanded(child: CircularProgressIndicator()),
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
