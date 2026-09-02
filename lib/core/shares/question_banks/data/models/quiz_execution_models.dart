import 'base_models.dart';

/// كائن الإجابة الفردية عند الإرسال
class UserAnswerRequest {
  final String questionId;
  final int? selectedOptionIndex;
  final bool? booleanAnswer;

  UserAnswerRequest({
    required this.questionId,
    this.selectedOptionIndex,
    this.booleanAnswer,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'questionId': questionId};
    if (selectedOptionIndex != null) {
      data['selectedOptionIndex'] = selectedOptionIndex;
    }
    if (booleanAnswer != null) {
      data['booleanAnswer'] = booleanAnswer;
    }
    return data;
  }
}

/// طلب تقديم الإجابات كاملة
class SubmitAnswersRequest {
  final List<UserAnswerRequest> answers;

  SubmitAnswersRequest({required this.answers});

  Map<String, dynamic> toJson() {
    return {'answers': answers.map((e) => e.toJson()).toList()};
  }
}

/// نتيجة سؤال فردي بعد التصحيح
class QuestionFeedbackModel {
  final String questionId;
  final bool isCorrect;
  final dynamic userAnswer;
  final dynamic correctAnswer;
  final String? explanation;

  QuestionFeedbackModel({
    required this.questionId,
    required this.isCorrect,
    this.userAnswer,
    this.correctAnswer,
    this.explanation,
  });

  factory QuestionFeedbackModel.fromJson(Map<String, dynamic> json) {
    return QuestionFeedbackModel(
      questionId: json['questionId'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      userAnswer: json['userAnswer'],
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
    );
  }
}

/// نتيجة التقديم لـ submitQuestionBankAnswers
class SubmissionResultModel {
  final String? attemptId;
  final int score;
  final int totalQuestions;
  final double percentage;
  final List<QuestionFeedbackModel> feedback;

  SubmissionResultModel({
    this.attemptId,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.feedback,
  });

  factory SubmissionResultModel.fromJson(Map<String, dynamic> json) {
    return SubmissionResultModel(
      attemptId: json['attemptId'] ?? json['_id'],
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      feedback: json['feedback'] != null && json['feedback'] is List
          ? (json['feedback'] as List)
                .map((e) => QuestionFeedbackModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

/// مودل المحاولة الواحدة لـ getMyAttempts
class AttemptModel {
  final String id;
  final String bankId;
  final int score;
  final int totalQuestions;
  final double percentage;
  final DateTime? createdAt;

  AttemptModel({
    required this.id,
    required this.bankId,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    this.createdAt,
  });

  factory AttemptModel.fromJson(Map<String, dynamic> json) {
    return AttemptModel(
      id: json['_id'] ?? json['id'] ?? '',
      bankId: json['bankId'] is Map
          ? json['bankId']['_id'] ?? ''
          : json['bankId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}

/// مودل نتيجة الطالب لـ getQuestionBankResults
class QuestionBankResultModel {
  final String id;
  final UserModel? student;
  final int score;
  final int totalQuestions;
  final double percentage;
  final DateTime? submittedAt;

  QuestionBankResultModel({
    required this.id,
    this.student,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    this.submittedAt,
  });

  factory QuestionBankResultModel.fromJson(Map<String, dynamic> json) {
    return QuestionBankResultModel(
      id: json['_id'] ?? json['id'] ?? '',
      student: json['userId'] is Map<String, dynamic>
          ? UserModel.fromJson(json['userId'])
          : (json['student'] is Map<String, dynamic>
                ? UserModel.fromJson(json['student'])
                : null),
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      percentage: (json['percentage'] ?? 0.0).toDouble(),
      submittedAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
