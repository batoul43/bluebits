import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/widget/subject_card.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:bluebits_app/core/widget/year_card.dart';
import 'package:bluebits_app/features/question_banks/presentation/logic/cubit/bank_cubit.dart';
import 'package:bluebits_app/features/question_banks/presentation/widget/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionBanksScreen extends StatelessWidget {
  QuestionBanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery لجعل التصميم متجاوباً كما ناقشنا سابقاً
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: BlocBuilder<BankCubit, BankState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, // نفس هوامش صفحة الـ Home
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is! BankQuestion)
                    const PageHeader(
                      title: "مستودع الأسئلة",
                      subtitle:
                          "اختر السنة والفصل والمادة لعرض الأسئلة المتاحة",
                    ),
                  SizedBox(height: screenHeight * 0.03),

                  // 3. حاوية البطاقات (الجسم الرئيسي للشاشة)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface, // اللون الأبيض من الثيم
                      borderRadius: BorderRadius.circular(
                        25,
                      ), // نفس انحناء بطاقات الـ Home
                    ),
                    child: state is BankYear
                        // الربط مع YearCubit لعرض السنوات من الـ API
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
                                    style: TextStyle(
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                );
                              } else if (yearState is YearLoaded) {
                                final yearsList = yearState.years;
                                if (yearsList.isEmpty) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        "لا توجد سنوات دراسية مضافة بعد",
                                      ),
                                    ),
                                  );
                                }

                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
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
                                    return YearCard(
                                      title: yearItem.name ?? "بدون اسم",
                                      onTap: () {
                                        final selectedYearId = yearItem.sId!;
                                        context
                                            .read<SubjectCubit>()
                                            .getSubjectsByYear(selectedYearId);
                                        // إرسال السنة المحددة إلى BankCubit
                                        context
                                            .read<BankCubit>()
                                            .displaySubjects(
                                              yearItem.name ?? "",
                                            );
                                      },
                                    );
                                  },
                                );
                              }
                              return const SizedBox();
                            },
                          )
                        : state is! BankYear
                        ? Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: TextButton(
                                  child: Text(
                                    "تغيير السنة",
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  onPressed: () {
                                    context.read<BankCubit>().backTOYear();
                                  },
                                ),
                              ),
                              state is BankSubject
                                  ? BlocBuilder<SubjectCubit, SubjectState>(
                                      builder: (context, subjectState) {
                                        if (subjectState
                                            is GetSubjectsByYearAnsSemester) {
                                          final subjects = subjectState
                                              .subjectsByYearSemester
                                              .data
                                              ?.subjects;
                                          if (subjects == null ||
                                              subjects.isEmpty) {
                                            return const Center(
                                              child: Text(
                                                "لا توجد مواد لهذه السنة حالياً",
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: subjects.length,
                                            itemBuilder: (context, index) {
                                              final subject = subjects[index];
                                              return SubjectCard(
                                                isbank: true,
                                                onTap: () {
                                                  context
                                                      .read<BankCubit>()
                                                      .displayQuestion(
                                                        state.selectedYear,
                                                        subject.name ?? "",
                                                      );
                                                },
                                                year: state.selectedYear,
                                                title:
                                                    subject.name ?? "بدون اسم",
                                                icon: const Icon(
                                                  Icons.question_answer,
                                                ),
                                              );
                                            },
                                          );
                                        } else if (subjectState
                                            is GetSubjectsLoading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (subjectState
                                            is GetSubjectsFailure) {
                                          return Center(
                                            child: Text(
                                              subjectState.errorMessage,
                                              style: TextStyle(
                                                color: theme.colorScheme.error,
                                              ),
                                            ),
                                          );
                                        }
                                        return const Center(
                                          child: Text("لا توجد مواد مطبقة"),
                                        );
                                      },
                                    )
                                  : state is BankQuestion
                                  ? QuestionCard(questions: state.questions)
                                  : const SizedBox(),
                            ],
                          )
                        : const Center(
                            child:
                                CircularProgressIndicator(), // تم إزالة الـ Expanded لتجنب انهيار الواجهة
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
