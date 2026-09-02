class MessageModel {
  final String role; // "user" or "model"
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageModel({
    required this.role,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      role: json['role'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

class ConversationDetailsModel {
  final String id;
  final String userId;
  final String title;
  final List<MessageModel> messages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ConversationDetailsModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.messages,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationDetailsModel.fromJson(Map<String, dynamic> json) {
    return ConversationDetailsModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
