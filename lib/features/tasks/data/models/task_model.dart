class TaskModel {
  final String id;
  final String title;
  final String description;
  final String time;
  bool isCompleted;
  final bool isAcademic;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.isCompleted = false,
    this.isAcademic = false, // لتحديد أنها مهمة شخصية/محلية
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'isCompleted': isCompleted,
      'isAcademic': isAcademic,
    };
  }

  factory TaskModel.fromjson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      isAcademic: json['isAcademic'] ?? false,
    );
  }
}
