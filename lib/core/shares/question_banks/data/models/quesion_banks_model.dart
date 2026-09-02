import 'base_models.dart';

class OptionModel {
  final String? id;
  final String text;
  final bool isCorrect;

  OptionModel({this.id, required this.text, required this.isCorrect});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['_id'] ?? json['id'],
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'text': text, 'isCorrect': isCorrect};
    if (id != null) data['_id'] = id;
    return data;
  }
}

class QuestionModel {
  final String? id;
  final String type; // 'mcq' or 'true_false'
  final String questionText;
  final List<OptionModel>? options;
  final bool? correctAnswer;
  final String? explanation;

  QuestionModel({
    this.id,
    required this.type,
    required this.questionText,
    this.options,
    this.correctAnswer,
    this.explanation,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'] ?? json['id'],
      type: json['type'] ?? 'mcq',
      questionText: json['questionText'] ?? '',
      options: json['options'] != null && json['options'] is List
          ? (json['options'] as List)
                .map((e) => OptionModel.fromJson(e))
                .toList()
          : null,
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'type': type,
      'questionText': questionText,
    };
    if (id != null) data['_id'] = id;
    if (explanation != null) data['explanation'] = explanation;

    if (type == 'mcq' && options != null) {
      data['options'] = options!.map((e) => e.toJson()).toList();
    } else if (type == 'true_false' && correctAnswer != null) {
      data['correctAnswer'] = correctAnswer;
    }
    return data;
  }
}

class QuestionBankModel {
  final String id;
  final String title;
  final String status; // 'draft' or 'published'
  final int questionCount;
  final LectureModel? lecture;
  final SubjectModel? subject;
  final YearModel? year;

  QuestionBankModel({
    required this.id,
    required this.title,
    required this.status,
    required this.questionCount,
    this.lecture,
    this.subject,
    this.year,
  });

  factory QuestionBankModel.fromJson(Map<String, dynamic> json) {
    return QuestionBankModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      status: json['status'] ?? 'draft',
      questionCount: json['questionCount'] ?? 0,
      lecture: json['lectureId'] is Map<String, dynamic>
          ? LectureModel.fromJson(json['lectureId'])
          : null,
      subject: json['subjectId'] is Map<String, dynamic>
          ? SubjectModel.fromJson(json['subjectId'])
          : null,
      year: json['yearId'] is Map<String, dynamic>
          ? YearModel.fromJson(json['yearId'])
          : null,
    );
  }
}

class BankWithQuestionsResponse {
  final QuestionBankModel bank;
  final List<QuestionModel> questions;

  BankWithQuestionsResponse({required this.bank, required this.questions});

  factory BankWithQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return BankWithQuestionsResponse(
      bank: QuestionBankModel.fromJson(
        json['bank'] is Map<String, dynamic> ? json['bank'] : json,
      ),
      questions: json['questions'] != null && json['questions'] is List
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

class YearBanksGroupModel {
  final YearModel year;
  final List<QuestionBankModel> banks;

  YearBanksGroupModel({required this.year, required this.banks});

  factory YearBanksGroupModel.fromJson(Map<String, dynamic> json) {
    return YearBanksGroupModel(
      year: YearModel.fromJson(json['year'] ?? {}),
      banks: json['banks'] != null && json['banks'] is List
          ? (json['banks'] as List)
                .map((e) => QuestionBankModel.fromJson(e))
                .toList()
          : [],
    );
  }
}
