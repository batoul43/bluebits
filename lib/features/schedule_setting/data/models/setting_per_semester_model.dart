class SettingPerSemesterModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  PopulatedScheduleConfigData? data;

  SettingPerSemesterModel({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.data,
  });

  SettingPerSemesterModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null
        ? PopulatedScheduleConfigData.fromJson(json['data'])
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

class PopulatedScheduleConfigData {
  String? sId;
  PopulatedSemester? semesterId;
  String? academicYear;
  String? startDate;
  String? endDate;
  List<String>? excludedDates;
  List<int>? excludedDaysOfWeek;
  int? timeslotsPerDay;
  List<PopulatedSubjectConfig>? subjectsConfig;
  String? createdBy;
  String? createdAt;
  String? updatedAt;

  PopulatedScheduleConfigData({
    this.sId,
    this.semesterId,
    this.academicYear,
    this.startDate,
    this.endDate,
    this.excludedDates,
    this.excludedDaysOfWeek,
    this.timeslotsPerDay,
    this.subjectsConfig,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  PopulatedScheduleConfigData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    semesterId = json['semesterId'] != null
        ? PopulatedSemester.fromJson(json['semesterId'])
        : null;
    academicYear = json['academicYear'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    excludedDates = json['excludedDates'] != null
        ? json['excludedDates'].cast<String>()
        : [];
    excludedDaysOfWeek = json['excludedDaysOfWeek'] != null
        ? json['excludedDaysOfWeek'].cast<int>()
        : [];
    timeslotsPerDay = json['timeslotsPerDay'];
    if (json['subjectsConfig'] != null) {
      subjectsConfig = <PopulatedSubjectConfig>[];
      json['subjectsConfig'].forEach((v) {
        subjectsConfig!.add(PopulatedSubjectConfig.fromJson(v));
      });
    }
    createdBy = json['createdBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (semesterId != null) {
      data['semesterId'] = semesterId!.toJson();
    }
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
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PopulatedSubjectConfig {
  PopulatedSubjectInfo? subjectId;
  int? carriedStudentsCount;
  int? examDurationOverride;

  PopulatedSubjectConfig({
    this.subjectId,
    this.carriedStudentsCount,
    this.examDurationOverride,
  });

  PopulatedSubjectConfig.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'] != null
        ? PopulatedSubjectInfo.fromJson(json['subjectId'])
        : null;
    carriedStudentsCount = json['carriedStudentsCount'];
    examDurationOverride = json['examDurationOverride'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subjectId != null) {
      data['subjectId'] = subjectId!.toJson();
    }
    data['carriedStudentsCount'] = carriedStudentsCount;
    data['examDurationOverride'] = examDurationOverride;
    return data;
  }
}

class PopulatedSubjectInfo {
  String? sId;
  String? name;
  PopulatedYear? yearId;
  PopulatedSemester? semesterId;
  String? createdBy;

  PopulatedSubjectInfo({
    this.sId,
    this.name,
    this.yearId,
    this.semesterId,
    this.createdBy,
  });

  PopulatedSubjectInfo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    yearId = json['yearId'] != null
        ? PopulatedYear.fromJson(json['yearId'])
        : null;
    semesterId = json['semesterId'] != null
        ? PopulatedSemester.fromJson(json['semesterId'])
        : null;
    createdBy = json['createdBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    if (yearId != null) {
      data['yearId'] = yearId!.toJson();
    }
    if (semesterId != null) {
      data['semesterId'] = semesterId!.toJson();
    }
    data['createdBy'] = createdBy;
    return data;
  }
}

class PopulatedSemester {
  String? sId;
  String? name;
  String? createdAt;
  String? updatedAt;

  PopulatedSemester({this.sId, this.name, this.createdAt, this.updatedAt});

  PopulatedSemester.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PopulatedYear {
  String? sId;
  String? name;
  int? order;

  PopulatedYear({this.sId, this.name, this.order});

  PopulatedYear.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['order'] = order;
    return data;
  }
}
