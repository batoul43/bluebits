import 'package:bluebits_app/core/shares/question_banks/data/models/quesion_banks_model.dart';

class BankWithQuestionsResponse {
  final QuestionBankModel bank;
  final List<QuestionModel> questions;

  BankWithQuestionsResponse({required this.bank, required this.questions});

  factory BankWithQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return BankWithQuestionsResponse(
      bank: QuestionBankModel.fromJson(json['bank']),
      questions: json['questions'] != null
          ? (json['questions'] as List)
                .map((e) => QuestionModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class BulkUploadRequest {
  final String lectureId;
  final List<QuestionModel> questions;

  BulkUploadRequest({required this.lectureId, required this.questions});

  Map<String, dynamic> toJson() {
    return {
      'lectureId': lectureId,
      'questions': questions.map((e) => e.toJson()).toList(),
    };
  }
}
