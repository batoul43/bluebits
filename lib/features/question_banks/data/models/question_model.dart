class QuestionModel {
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  int? selectedOptionIndex;

  QuestionModel({
    this.selectedOptionIndex,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });
}
