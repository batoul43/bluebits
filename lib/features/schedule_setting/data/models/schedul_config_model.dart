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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ScheduleConfigData {
  String? semesterId;
  String? academicYear;
  String? startDate;
  String? endDate;
  List<String>? excludedDates;
  List<int>? excludedDaysOfWeek;
  int? timeslotsPerDay;
  List<SubjectConfig>? subjectsConfig;
  String? createdBy;
  String? sId;
  String? createdAt;
  String? updatedAt;

  ScheduleConfigData({
    this.semesterId,
    this.academicYear,
    this.startDate,
    this.endDate,
    this.excludedDates,
    this.excludedDaysOfWeek,
    this.timeslotsPerDay,
    this.subjectsConfig,
    this.createdBy,
    this.sId,
    this.createdAt,
    this.updatedAt,
  });

  ScheduleConfigData.fromJson(Map<String, dynamic> json) {
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
      subjectsConfig = <SubjectConfig>[];
      json['subjectsConfig'].forEach((v) {
        subjectsConfig!.add(SubjectConfig.fromJson(v));
      });
    }
    createdBy = json['createdBy'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['semesterId'] = semesterId;
    data['academicYear'] = academicYear;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['excludedDates'] = excludedDates;
    data['excludedDaysOfWeek'] = excludedDaysOfWeek;
    data['timeslotsPerDay'] = timeslotsPerDay;
    if (subjectsConfig != null) {
      data['subjectsConfig'] = subjectsConfig!.map((v) => v.toJson()).toList();
    }
    data['createdBy'] = createdBy;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subjectId'] = subjectId;
    data['carriedStudentsCount'] = carriedStudentsCount;
    data['examDurationOverride'] = examDurationOverride;
    return data;
  }
}
