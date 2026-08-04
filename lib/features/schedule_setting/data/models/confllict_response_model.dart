class ConflictsResponseModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  List<ConflictItem>? conflicts;

  ConflictsResponseModel({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.conflicts,
  });

  ConflictsResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];

    if (json['conflicts'] != null) {
      conflicts = <ConflictItem>[];
      json['conflicts'].forEach((v) {
        conflicts!.add(ConflictItem.fromJson(v));
      });
    } else if (json['data'] != null) {
      conflicts = <ConflictItem>[];
      json['data'].forEach((v) {
        conflicts!.add(ConflictItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['statusCode'] = statusCode;
    if (conflicts != null) {
      data['conflicts'] = conflicts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// 4. الكلاس الموحد للتعارضات (يحل محل ExamConflict و ConflictItem القديم)
class ConflictItem {
  String? type; // HARD, MEDIUM, SOFT
  String? examA;
  String? examAName;
  String? examB;
  String? examBName;

  ConflictItem({
    this.type,
    this.examA,
    this.examAName,
    this.examB,
    this.examBName,
  });

  ConflictItem.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String?;
    examA = json['examA'] as String?;
    examAName = json['examAName'] as String?;
    examB = json['examB'] as String?;
    examBName = json['examBName'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['examA'] = examA;
    data['examAName'] = examAName;
    data['examB'] = examB;
    data['examBName'] = examBName;
    return data;
  }
}
