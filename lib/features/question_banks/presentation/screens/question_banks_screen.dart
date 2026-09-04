import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/question_banks/data/models/quesion_banks_model.dart';
import 'package:bluebits_app/core/shares/question_banks/data/models/quiz_execution_models.dart';
import 'package:bluebits_app/core/shares/question_banks/logic/question_bank_cubit.dart';
import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/widget/subject_card.dart';
import 'package:bluebits_app/core/widget/year_card.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:bluebits_app/features/question_banks/presentation/logic/cubit/bank_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionBanksScreen extends StatelessWidget {
  const QuestionBanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final ThemeData theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: BlocBuilder<BankCubit, BankState>(
          builder: (context, bankRouterState) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
                vertical: screenSize.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(bankRouterState),
                  SizedBox(height: screenSize.height * 0.03),
                  _buildMainContainer(
                    context,
                    theme,
                    screenSize,
                    bankRouterState,
                  ),
                  SizedBox(height: screenSize.height * 0.05),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BankState state) {
    if (state is BankQuestion) return const SizedBox.shrink();
    return const PageHeader(
      title: "مستودع الأسئلة",
      subtitle: "اختر السنة والفصل والمادة لعرض الأسئلة المتاحة",
    );
  }

  Widget _buildMainContainer(
    BuildContext context,
    ThemeData theme,
    Size screenSize,
    BankState bankRouterState,
  ) {
    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.04),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: _buildDynamicContent(context, theme, screenSize, bankRouterState),
    );
  }

  Widget _buildDynamicContent(
    BuildContext context,
    ThemeData theme,
    Size screenSize,
    BankState bankRouterState,
  ) {
    if (bankRouterState is BankYear) {
      return _buildYearsSection(screenSize, theme);
    }

    if (bankRouterState is BankSubject) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(context, theme, "العودة للسنوات", () {
            context.read<BankCubit>().backTOYear();
          }),
          SizedBox(height: screenSize.height * 0.02),
          _buildSubjectsSection(
            bankRouterState.selectedYear,
            theme,
            screenSize,
          ),
        ],
      );
    }

    if (bankRouterState is BankQuestion) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBackButton(context, theme, "العودة للمواد", () {
            context.read<BankCubit>().displaySubjects(
              bankRouterState.selectedyear,
            );
          }),
          SizedBox(height: screenSize.height * 0.02),
          _buildQuestionBanksSection(theme, screenSize),
        ],
      );
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildBackButton(
    BuildContext context,
    ThemeData theme,
    String text,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearsSection(Size screenSize, ThemeData theme) {
    return BlocBuilder<YearCubit, YearState>(
      builder: (context, yearState) {
        if (yearState is YearLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (yearState is YearError) {
          return Center(
            child: Text(
              yearState.message,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        }
        if (yearState is YearLoaded) {
          final years = yearState.years;
          if (years.isEmpty) {
            return const Center(child: Text("لا توجد سنوات دراسية مضافة بعد"));
          }

          int crossAxisCount = screenSize.width > 800
              ? 4
              : (screenSize.width > 600 ? 3 : 2);

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85,
            ),
            itemCount: years.length,
            itemBuilder: (context, index) {
              final year = years[index];
              return YearCard(
                title: year.name ?? "بدون اسم",
                onTap: () {
                  final yearId = year.sId;
                  if (yearId != null && yearId.isNotEmpty) {
                    context.read<SubjectCubit>().getSubjectsByYear(yearId);
                    context.read<BankCubit>().displaySubjects(year.name ?? "");
                  }
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSubjectsSection(
    String selectedYear,
    ThemeData theme,
    Size screenSize,
  ) {
    return BlocBuilder<SubjectCubit, SubjectState>(
      builder: (context, subjectState) {
        if (subjectState is GetSubjectsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (subjectState is GetSubjectsFailure) {
          return Center(
            child: Text(
              subjectState.errorMessage,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        }
        if (subjectState is GetSubjectsByYearAnsSemester) {
          final subjects = subjectState.subjectsByYearSemester.data?.subjects;
          if (subjects == null || subjects.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("لا توجد مواد لهذه السنة حالياً"),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: screenSize.height * 0.015),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return SubjectCard(
                isbank: true,
                onTap: () async {
                  final token = await CachHelper.getValue('Token') ?? "";
                  if (!context.mounted) return;

                  if (subject.sId != null && subject.sId!.isNotEmpty) {
                    context
                        .read<QuestionBankCubit>()
                        .fetchQuestionBanksBySubjectId(
                          token: token,
                          subjectId: subject.sId!,
                        );
                  }

                  context.read<BankCubit>().displayQuestion(
                    selectedYear,
                    subject.name ?? "",
                  );
                },
                year: selectedYear,
                title: subject.name ?? "بدون اسم",
                icon: const Icon(Icons.question_answer),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildQuestionBanksSection(ThemeData theme, Size screenSize) {
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<QuestionBankCubit, QuestionBankState>(
      builder: (context, qbState) {
        if (qbState is QuestionBankInitial || qbState is QuestionBankLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (qbState is QuestionBankError) {
          return Center(
            child: Text(
              qbState.errorMessage,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        }

        if (qbState is QuestionBanksListLoaded) {
          final banks = qbState.banks;

          if (banks.isEmpty) {
            return Card(
              elevation: 0,
              color: isDark ? ColorsManager.deepNavy : ColorsManager.lightBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30.0,
                  horizontal: 20.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.assignment_late_outlined,
                        size: 48,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "لا يوجد بنوك أسئلة متوفرة لهذه المادة",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: banks.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: screenSize.height * 0.012),
            itemBuilder: (context, index) {
              final bank = banks[index];
              return Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                color: isDark ? ColorsManager.deepNavy : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isDark
                        ? ColorsManager.cyan.withOpacity(0.25)
                        : ColorsManager.blue.withOpacity(0.15),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.04,
                    vertical: screenSize.height * 0.01,
                  ),
                  title: Text(bank.title, style: theme.textTheme.titleMedium),
                  subtitle: Text(
                    "عدد الأسئلة: ${bank.questionCount}",
                    style: theme.textTheme.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.play_arrow_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  onTap: () async {
                    final token = await CachHelper.getValue('Token') ?? "";
                    if (!context.mounted) return;

                    context.read<QuestionBankCubit>().fetchQuestionBankById(
                      token: token,
                      bankId: bank.id,
                    );
                  },
                ),
              );
            },
          );
        }

        if (qbState is QuestionBankDetailLoaded) {
          return QuizExecutionWidget(bankDetails: qbState.bankDetails);
        }

        if (qbState is QuestionBankSubmissionSuccess) {
          return QuizResultView(result: qbState.result);
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class QuizExecutionWidget extends StatefulWidget {
  final BankWithQuestionsResponse bankDetails;

  const QuizExecutionWidget({super.key, required this.bankDetails});

  @override
  State<QuizExecutionWidget> createState() => _QuizExecutionWidgetState();
}

class _QuizExecutionWidgetState extends State<QuizExecutionWidget> {
  final Map<String, int> _selectedMcqAnswers = {};
  final Map<String, bool> _selectedBoolAnswers = {};

  final Set<String> _checkedQuestionIds = {};

  Future<void> _submitQuiz() async {
    final token = await CachHelper.getValue('Token') ?? "";
    if (!mounted) return;

    final List<UserAnswerRequest> answersRequests = [];

    for (var question in widget.bankDetails.questions) {
      if (question.id == null) continue;

      if (question.type == 'mcq' &&
          _selectedMcqAnswers.containsKey(question.id)) {
        answersRequests.add(
          UserAnswerRequest(
            questionId: question.id!,
            selectedOptionIndex: _selectedMcqAnswers[question.id],
          ),
        );
      } else if (question.type == 'true_false' &&
          _selectedBoolAnswers.containsKey(question.id)) {
        answersRequests.add(
          UserAnswerRequest(
            questionId: question.id!,
            booleanAnswer: _selectedBoolAnswers[question.id],
          ),
        );
      }
    }

    context.read<QuestionBankCubit>().submitAnswers(
      token: token,
      bankId: widget.bankDetails.bank.id,
      answers: answersRequests,
    );
  }

  Widget _buildMcqOption(
    String qId,
    int optIndex,
    OptionModel option,
    ThemeData theme,
    bool isDark,
  ) {
    final isSelected = _selectedMcqAnswers[qId] == optIndex;
    final isCorrect = option.isCorrect;
    final isQuestionChecked = _checkedQuestionIds.contains(qId);

    Color borderColor = isDark
        ? ColorsManager.cyan.withOpacity(0.2)
        : Colors.grey.shade300;
    Color bgColor = Colors.transparent;

    if (isQuestionChecked) {
      if (isCorrect) {
        borderColor = ColorsManager.green;
        bgColor = ColorsManager.green.withOpacity(0.12);
      } else if (isSelected && !isCorrect) {
        borderColor = ColorsManager.redaccent;
        bgColor = ColorsManager.redaccent.withOpacity(0.12);
      }
    } else if (isSelected) {
      borderColor = theme.colorScheme.primary;
      bgColor = theme.colorScheme.primary.withOpacity(0.08);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        color: bgColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor,
            width: isSelected || (isQuestionChecked && isCorrect) ? 2.0 : 1.2,
          ),
        ),
        child: RadioListTile<int>(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 2.0,
          ),
          title: Text(
            option.text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isQuestionChecked && isCorrect
                  ? ColorsManager.green
                  : (isQuestionChecked && isSelected && !isCorrect
                        ? ColorsManager.redaccent
                        : null),
              fontWeight: isSelected || (isQuestionChecked && isCorrect)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          value: optIndex,
          groupValue: _selectedMcqAnswers[qId],
          activeColor: isQuestionChecked
              ? (isCorrect ? ColorsManager.green : ColorsManager.redaccent)
              : theme.colorScheme.primary,
          onChanged: isQuestionChecked
              ? null
              : (value) {
                  setState(() {
                    _selectedMcqAnswers[qId] = value!;
                  });
                },
        ),
      ),
    );
  }

  Widget _buildTrueFalseOption(
    String qId,
    bool value,
    String label,
    bool? correctAnswer,
    ThemeData theme,
    bool isDark,
  ) {
    final isSelected = _selectedBoolAnswers[qId] == value;
    final isCorrect = correctAnswer == value;
    final isQuestionChecked = _checkedQuestionIds.contains(qId);

    Color borderColor = isDark
        ? ColorsManager.cyan.withOpacity(0.2)
        : Colors.grey.shade300;
    Color bgColor = Colors.transparent;

    if (isQuestionChecked) {
      if (isCorrect) {
        borderColor = ColorsManager.green;
        bgColor = ColorsManager.green.withOpacity(0.12);
      } else if (isSelected && !isCorrect) {
        borderColor = ColorsManager.redaccent;
        bgColor = ColorsManager.redaccent.withOpacity(0.12);
      }
    } else if (isSelected) {
      borderColor = theme.colorScheme.primary;
      bgColor = theme.colorScheme.primary.withOpacity(0.08);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Material(
        color: bgColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: borderColor,
            width: isSelected || (isQuestionChecked && isCorrect) ? 2.0 : 1.2,
          ),
        ),
        child: RadioListTile<bool>(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12.0,
            vertical: 2.0,
          ),
          title: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isQuestionChecked && isCorrect
                  ? ColorsManager.green
                  : (isQuestionChecked && isSelected && !isCorrect
                        ? ColorsManager.redaccent
                        : null),
              fontWeight: isSelected || (isQuestionChecked && isCorrect)
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          value: value,
          groupValue: _selectedBoolAnswers[qId],
          activeColor: isQuestionChecked
              ? (isCorrect ? ColorsManager.green : ColorsManager.redaccent)
              : theme.colorScheme.primary,
          onChanged: isQuestionChecked
              ? null
              : (val) {
                  setState(() {
                    _selectedBoolAnswers[qId] = val!;
                  });
                },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.bankDetails.questions;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Size screenSize = MediaQuery.of(context).size;

    if (questions.isEmpty) {
      return Card(
        elevation: 0,
        color: isDark ? ColorsManager.deepNavy : Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text("لا توجد أسئلة متوفرة في هذا البنك حالياً."),
          ),
        ),
      );
    }

    final totalAnswered =
        _selectedMcqAnswers.length + _selectedBoolAnswers.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.bankDetails.bank.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "عدد الأسئلة الإجمالي: ${questions.length}",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? ColorsManager.darkGreyText : ColorsManager.greyText,
          ),
        ),
        SizedBox(height: screenSize.height * 0.02),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: questions.length,
          separatorBuilder: (context, index) => const Divider(height: 35),
          itemBuilder: (context, index) {
            final question = questions[index];
            final qId = question.id ?? index.toString();
            final isQuestionChecked = _checkedQuestionIds.contains(qId);
            final hasAnswered =
                (question.type == 'mcq' &&
                    _selectedMcqAnswers.containsKey(qId)) ||
                (question.type == 'true_false' &&
                    _selectedBoolAnswers.containsKey(qId));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${index + 1}. ${question.questionText}",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                if (question.type == 'mcq' && question.options != null) ...[
                  ...List.generate(question.options!.length, (optIndex) {
                    final option = question.options![optIndex];
                    return _buildMcqOption(
                      qId,
                      optIndex,
                      option,
                      theme,
                      isDark,
                    );
                  }),
                ] else if (question.type == 'true_false') ...[
                  _buildTrueFalseOption(
                    qId,
                    true,
                    "صح",
                    question.correctAnswer,
                    theme,
                    isDark,
                  ),
                  _buildTrueFalseOption(
                    qId,
                    false,
                    "خطأ",
                    question.correctAnswer,
                    theme,
                    isDark,
                  ),
                ],
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: hasAnswered && !isQuestionChecked
                        ? () {
                            setState(() {
                              _checkedQuestionIds.add(qId);
                            });
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isQuestionChecked
                          ? ColorsManager.green
                          : theme.colorScheme.primary,
                      side: BorderSide(
                        color: isQuestionChecked
                            ? ColorsManager.green
                            : (hasAnswered
                                  ? theme.colorScheme.primary
                                  : Colors.grey.shade400),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(
                      isQuestionChecked
                          ? Icons.check_circle
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    label: Text(
                      isQuestionChecked ? "تم التحقق" : "تحقق من الإجابة",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: screenSize.height * 0.04),
        // ElevatedButton(
        //   onPressed: totalAnswered == questions.length ? _submitQuiz : null,
        //   style: ElevatedButton.styleFrom(
        //     padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
        //   ),
        //   child: Text(
        //     totalAnswered == questions.length
        //         ? "إرسال وتأكيد النتيجة النهائية"
        //         : "أجب عن جميع الأسئلة للإرسال ($totalAnswered/${questions.length})",
        //   ),
        // ),
      ],
    );
  }
}

class QuizResultView extends StatelessWidget {
  final SubmissionResultModel result;

  const QuizResultView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPassed = result.percentage >= 50;
    final Color mainColor = isPassed
        ? ColorsManager.green
        : ColorsManager.redaccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: mainColor),
          ),
          child: Column(
            children: [
              Icon(
                isPassed ? Icons.check_circle_outline : Icons.highlight_off,
                size: 60,
                color: mainColor,
              ),
              const SizedBox(height: 10),
              Text(
                isPassed
                    ? "أحسنت! لقد اجتزت الاختبار"
                    : "لم تجتز الاختبار، حاول مجدداً",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "النتيجة: ${result.score} / ${result.totalQuestions} (${result.percentage.toStringAsFixed(1)}%)",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Text(
          "مراجعة التقييم والإجابات:",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: result.feedback.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final fb = result.feedback[index];
            final Color feedbackColor = fb.isCorrect
                ? ColorsManager.green
                : ColorsManager.redaccent;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                fb.isCorrect ? Icons.check : Icons.close,
                color: feedbackColor,
              ),
              title: Text("سؤال ${index + 1}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("إجابتك: ${fb.userAnswer ?? 'بدون إجابة'}"),
                  if (!fb.isCorrect)
                    Text("الإجابة الصحيحة: ${fb.correctAnswer}"),
                  if (fb.explanation != null && fb.explanation!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        "التوضيح: ${fb.explanation}",
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
