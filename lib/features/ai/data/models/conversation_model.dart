class ConversationModel {
  final String id;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ConversationModel({
    required this.id,
    required this.title,
    this.createdAt,
    this.updatedAt,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
