class UserModel {
  final String id;
  final String name;
  final String email;
  final String? role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      if (role != null) 'role': role,
    };
  }
}

class YearModel {
  final String id;
  final String name;
  final int order;

  YearModel({required this.id, required this.name, required this.order});

  factory YearModel.fromJson(Map<String, dynamic> json) {
    return YearModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'order': order};
  }
}

class SemesterModel {
  final String id;
  final String name;

  SemesterModel({required this.id, required this.name});

  factory SemesterModel.fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name};
  }
}

class SubjectModel {
  final String id;
  final String name;
  final YearModel? year;
  final SemesterModel? semester;
  final List<UserModel> lecturers;

  SubjectModel({
    required this.id,
    required this.name,
    this.year,
    this.semester,
    required this.lecturers,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      year: json['yearId'] is Map<String, dynamic>
          ? YearModel.fromJson(json['yearId'])
          : null,
      semester: json['semesterId'] is Map<String, dynamic>
          ? SemesterModel.fromJson(json['semesterId'])
          : null,
      lecturers: json['lecturerIds'] is List
          ? (json['lecturerIds'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => UserModel.fromJson(e))
                .toList()
          : [],
    );
  }
}

class LectureModel {
  final String id;
  final String title;
  final SubjectModel? subject;
  final UserModel? uploadedBy;

  LectureModel({
    required this.id,
    required this.title,
    this.subject,
    this.uploadedBy,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      subject: json['subjectId'] is Map<String, dynamic>
          ? SubjectModel.fromJson(json['subjectId'])
          : null,
      uploadedBy: json['uploadedBy'] is Map<String, dynamic>
          ? UserModel.fromJson(json['uploadedBy'])
          : null,
    );
  }
}
