class AskResponseModel {
  final String conversationId;
  final String title;
  final String question;
  final String answer;

  AskResponseModel({
    required this.conversationId,
    required this.title,
    required this.question,
    required this.answer,
  });

  factory AskResponseModel.fromJson(Map<String, dynamic> json) {
    return AskResponseModel(
      conversationId: json['conversationId'] ?? '',
      title: json['title'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}
