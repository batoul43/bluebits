// ==========================================
// 1. طلب إنشاء مهمة أكاديمية (Create Request)
// ==========================================
class CreateAcademicTaskRequest {
  final String title;
  final String description;
  final String yearId;
  final String subjectId;
  final String lectureId;
  final int durationDays;
  final int durationHours;
  final int durationMinutes;

  CreateAcademicTaskRequest({
    required this.title,
    required this.description,
    required this.yearId,
    required this.subjectId,
    required this.lectureId,
    required this.durationDays,
    required this.durationHours,
    required this.durationMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "yearId": yearId,
      "subjectId": subjectId,
      "lectureId": lectureId,
      "durationDays": durationDays,
      "durationHours": durationHours,
      "durationMinutes": durationMinutes,
    };
  }
}

// ==========================================
// 2. طلب تعديل مهمة أكاديمية (Update Request)
// ==========================================
class UpdateAcademicTaskRequest {
  final String? title;
  final String? description;
  final int? durationDays;
  final int? durationHours;
  final int? durationMinutes;

  UpdateAcademicTaskRequest({
    this.title,
    this.description,
    this.durationDays,
    this.durationHours,
    this.durationMinutes,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) data["title"] = title;
    if (description != null) data["description"] = description;
    if (durationDays != null) data["durationDays"] = durationDays;
    if (durationHours != null) data["durationHours"] = durationHours;
    if (durationMinutes != null) data["durationMinutes"] = durationMinutes;
    return data;
  }
}

// ==========================================
// 3. النماذج الفرعية (Sub-Models)
// ==========================================

class TaskYear {
  final String id;
  final String? name;
  final int? order;

  TaskYear({required this.id, this.name, this.order});

  factory TaskYear.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return TaskYear(
        id: json['_id'] ?? '',
        name: json['name'],
        order: json['order'],
      );
    }
    return TaskYear(id: json.toString());
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'order': order};
}

class TaskSemester {
  final String id;
  final String? name;

  TaskSemester({required this.id, this.name});

  factory TaskSemester.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return TaskSemester(id: json['_id'] ?? '', name: json['name']);
    }
    return TaskSemester(id: json.toString());
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class TaskSubject {
  final String id;
  final String? name;
  final TaskYear? year;
  final TaskSemester? semester;

  TaskSubject({required this.id, this.name, this.year, this.semester});

  factory TaskSubject.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return TaskSubject(
        id: json['_id'] ?? '',
        name: json['name'],
        year: json['yearId'] != null ? TaskYear.fromJson(json['yearId']) : null,
        semester: json['semesterId'] != null
            ? TaskSemester.fromJson(json['semesterId'])
            : null,
      );
    }
    return TaskSubject(id: json.toString());
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'yearId': year?.toJson(),
    'semesterId': semester?.toJson(),
  };
}

class TaskUser {
  final String id;
  final String? name;
  final String? email;

  TaskUser({required this.id, this.name, this.email});

  factory TaskUser.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return TaskUser(
        id: json['_id'] ?? '',
        name: json['name'],
        email: json['email'],
      );
    }
    return TaskUser(id: json.toString());
  }

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'email': email};
}

class TaskLecture {
  final String id;
  final String? title;
  final TaskSubject? subject;
  final TaskUser? uploadedBy;

  TaskLecture({required this.id, this.title, this.subject, this.uploadedBy});

  factory TaskLecture.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return TaskLecture(
        id: json['_id'] ?? '',
        title: json['title'],
        subject: json['subjectId'] != null
            ? TaskSubject.fromJson(json['subjectId'])
            : null,
        uploadedBy: json['uploadedBy'] != null
            ? TaskUser.fromJson(json['uploadedBy'])
            : null,
      );
    }
    return TaskLecture(id: json.toString());
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'subjectId': subject?.toJson(),
    'uploadedBy': uploadedBy?.toJson(),
  };
}

// ==========================================
// 4. النموذج الرئيسي للمهمة (AcademicTaskModel)
// ==========================================

class AcademicTaskModel {
  final String id;
  final String title;
  final String description;
  final TaskYear? year;
  final TaskSubject? subject;
  final TaskLecture? lecture;
  final TaskUser? createdBy;
  final int durationDays;
  final int durationHours;
  final int durationMinutes;
  final String status; // open or closed
  final DateTime? opensAt;
  final DateTime? closesAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AcademicTaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.year,
    this.subject,
    this.lecture,
    this.createdBy,
    required this.durationDays,
    required this.durationHours,
    required this.durationMinutes,
    required this.status,
    this.opensAt,
    this.closesAt,
    this.createdAt,
    this.updatedAt,
  });

  factory AcademicTaskModel.fromJson(Map<String, dynamic> json) {
    return AcademicTaskModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      year: json['yearId'] != null ? TaskYear.fromJson(json['yearId']) : null,
      subject: json['subjectId'] != null
          ? TaskSubject.fromJson(json['subjectId'])
          : null,
      lecture: json['lectureId'] != null
          ? TaskLecture.fromJson(json['lectureId'])
          : null,
      createdBy: json['createdBy'] != null
          ? TaskUser.fromJson(json['createdBy'])
          : null,
      durationDays: json['durationDays'] ?? 0,
      durationHours: json['durationHours'] ?? 0,
      durationMinutes: json['durationMinutes'] ?? 0,
      status: json['status'] ?? 'open',
      opensAt: json['opensAt'] != null ? DateTime.parse(json['opensAt']) : null,
      closesAt: json['closesAt'] != null
          ? DateTime.parse(json['closesAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'yearId': year?.toJson(),
      'subjectId': subject?.toJson(),
      'lectureId': lecture?.toJson(),
      'createdBy': createdBy?.toJson(),
      'durationDays': durationDays,
      'durationHours': durationHours,
      'durationMinutes': durationMinutes,
      'status': status,
      'opensAt': opensAt?.toIso8601String(),
      'closesAt': closesAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
