class ScheduleConfigModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  ScheduleConfigData? data;

  ScheduleConfigModel({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.data,
  });

  ScheduleConfigModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null
        ? ScheduleConfigData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'statusCode': statusCode,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class ScheduleConfigData {
  String? sId;
  String? semesterId;
  String? academicYear;
  String? startDate;
  String? endDate;
  List<String>? excludedDates;
  List<int>? excludedDaysOfWeek;
  int? timeslotsPerDay;
  List<SubjectConfig>? subjectsConfig;
  List<dynamic>? fixedSubjects;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  ScheduleConfigData({
    this.sId,
    this.semesterId,
    this.academicYear,
    this.startDate,
    this.endDate,
    this.excludedDates,
    this.excludedDaysOfWeek,
    this.timeslotsPerDay,
    this.subjectsConfig,
    this.fixedSubjects,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  ScheduleConfigData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    semesterId = json['semesterId'];
    academicYear = json['academicYear'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    excludedDates = json['excludedDates'] != null
        ? List<String>.from(json['excludedDates'])
        : [];
    excludedDaysOfWeek = json['excludedDaysOfWeek'] != null
        ? List<int>.from(json['excludedDaysOfWeek'])
        : [];
    timeslotsPerDay = json['timeslotsPerDay'];
    if (json['subjectsConfig'] != null) {
      subjectsConfig = (json['subjectsConfig'] as List)
          .map((v) => SubjectConfig.fromJson(v))
          .toList();
    }
    fixedSubjects = json['fixedSubjects'] != null
        ? List<dynamic>.from(json['fixedSubjects'])
        : [];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'semesterId': semesterId,
      'academicYear': academicYear,
      'startDate': startDate,
      'endDate': endDate,
      'excludedDates': excludedDates,
      'excludedDaysOfWeek': excludedDaysOfWeek,
      'timeslotsPerDay': timeslotsPerDay,
      if (subjectsConfig != null)
        'subjectsConfig': subjectsConfig!.map((v) => v.toJson()).toList(),
      'fixedSubjects': fixedSubjects,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SubjectConfig {
  String? subjectId;
  int? carriedStudentsCount;
  int? examDurationOverride;

  SubjectConfig({
    this.subjectId,
    this.carriedStudentsCount,
    this.examDurationOverride,
  });

  SubjectConfig.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'];
    carriedStudentsCount = json['carriedStudentsCount'];
    examDurationOverride = json['examDurationOverride'];
  }

  Map<String, dynamic> toJson() {
    return {
      'subjectId': subjectId,
      'carriedStudentsCount': carriedStudentsCount,
      'examDurationOverride': examDurationOverride,
    };
  }
}
