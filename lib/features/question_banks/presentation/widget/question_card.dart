import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/question_banks/data/models/question_model.dart';
import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final List<QuestionModel> questions;
  const QuestionCard({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // لكي يعمل بسلاسة داخل SingleChildScrollView الشاشة الأساسية
      itemCount: questions.length,
      itemBuilder: (context, Index) {
        final question = questions[Index];

        return Container(
          margin: EdgeInsets.only(bottom: screenWidth * 0.05),
          padding: EdgeInsets.all(screenWidth * 0.04),
          decoration: BoxDecoration(
            color: theme
                .scaffoldBackgroundColor, // تباين لوني ناعم داخل كرت الشاشة الأبيض
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- قسم رأس السؤال (رقم السؤال لون برتقالي + النص) ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${Index + 1}. ",
                    style: const TextStyle(
                      color: ColorsManager.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      question.questionText,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 15,
                        height: 1.4,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.04),

              // --- قسم الخيارات التفاعلية (Options List) ---
              ...List.generate(question.options.length, (optIndex) {
                final bool isSelected =
                    question.selectedOptionIndex == optIndex;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // إذا كان الخيار محدداً يأخذ خلفية شفافة من اللون الأساسي (الأزرق/السيان)
                    color: isSelected
                        ? theme.colorScheme.primary.withOpacity(0.08)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(0.1),
                      width: isSelected ? 1.8 : 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      // إرسال الأكشن للكيوبت لتحديث الإجابة وإعادة رسم الواجهة لحظياً
                      // context.read<QuestionBanksCubit>().selectOption(
                      //       questions,
                      //       qIndex,
                      //       optIndex,
                      //     );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical:
                            screenWidth *
                            0.035, // حشوة متناسقة تعطي مساحة ضغط مريحة
                      ),
                      child: Text(
                        question.options[optIndex],
                        textAlign: TextAlign
                            .center, // توسيط النصوص تماماً كما في التصميم الحقيقي
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
