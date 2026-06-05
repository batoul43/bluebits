import 'package:bluebits_app/core/widget/subject_card.dart';
import 'package:bluebits_app/core/widget/page_headers.dart';
import 'package:bluebits_app/core/widget/year_card.dart';
import 'package:bluebits_app/features/question_banks/presentation/logic/cubit/bank_cubit.dart';
import 'package:bluebits_app/features/question_banks/presentation/widget/question_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionBanksScreen extends StatelessWidget {
  const QuestionBanksScreen({super.key});

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
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05, // نفس هوامش صفحة الـ Home
                vertical: screenHeight * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is! BankQuestion)
                    PageHeader(
                      title: "مستودع الأسئلة",
                      subtitle:
                          "اختر السنة والفصل والمادة لعرض الأسئلة المتاحة",
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
                    child: state is BankYear
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
                                  context.read<BankCubit>().displaySubjects(
                                    "السنة الأولى",
                                  );
                                },
                              ),
                              YearCard(
                                title: "السنة الثانية",
                                onTap: () {
                                  context.read<BankCubit>().displaySubjects(
                                    "السنة الثانية",
                                  );
                                },
                              ),
                              YearCard(
                                title: "السنة الثالثة",
                                onTap: () {
                                  context.read<BankCubit>().displaySubjects(
                                    "السنة الثالثة",
                                  );
                                },
                              ),
                              YearCard(
                                title: "السنة الرابعة",
                                onTap: () {
                                  context.read<BankCubit>().displaySubjects(
                                    "السنة الرابعة",
                                  );
                                },
                              ),
                            ],
                          )
                        : state is! BankYear
                        ? (Column(
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
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: state
                                          .subjects
                                          .length, // Replace with actual number of subjects
                                      itemBuilder: (context, index) {
                                        return state.subjects.isEmpty
                                            ? Center(
                                                child: Text(
                                                  "لا تتوفر بنوك لهذه السنة حاليا",
                                                ),
                                              )
                                            : SubjectCard(
                                                isbankorTask: true,
                                                onTap: () {
                                                  context
                                                      .read<BankCubit>()
                                                      .displayQuestion(
                                                        state.selectedYear,
                                                        state.subjects[index],
                                                      );
                                                },
                                                year: state.selectedYear,
                                                title: state.subjects[index],
                                              );
                                      },
                                    )
                                  : state is BankQuestion
                                  ? QuestionCard(questions: state.questions)
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
