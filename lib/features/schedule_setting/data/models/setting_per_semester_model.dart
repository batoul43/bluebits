// دالة مساعدة لتحويل أي قيمة إلى نص بأمان ومنع انهيار التطبيق
String? _safeParseString(dynamic value) {
  if (value == null) return null;
  if (value is String) return value;
  if (value is Map) {
    // إذا قام الخادم بإرجاع كائن (Populated Object) بدلاً من نص، نحاول استخراج الـ ID
    if (value.containsKey('_id')) {
      return value['_id'].toString();
    }
    // في حال كان كائن رسالة خطأ أو تاريخ
    return value.toString();
  }
  return value.toString();
}

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
    // استخدام الدالة الآمنة لتجنب انهيار التطبيق إذا كانت الرسالة كائناً
    message = _safeParseString(json['message']);

    // تأمين تحويل الأرقام
    statusCode = json['statusCode'] != null
        ? int.tryParse(json['statusCode'].toString())
        : null;

    data = (json['data'] != null && json['data'] is Map<String, dynamic>)
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
    sId = _safeParseString(json['_id']);

    semesterId =
        (json['semesterId'] != null &&
            json['semesterId'] is Map<String, dynamic>)
        ? PopulatedSemester.fromJson(json['semesterId'])
        : null;

    academicYear = _safeParseString(json['academicYear']);
    startDate = _safeParseString(json['startDate']);
    endDate = _safeParseString(json['endDate']);

    // تأمين المصفوفات بدلاً من استخدام cast() التي قد تسبب أعطالاً
    excludedDates =
        json['excludedDates'] != null && json['excludedDates'] is List
        ? (json['excludedDates'] as List)
              .map((e) => _safeParseString(e) ?? '')
              .toList()
        : [];

    excludedDaysOfWeek =
        json['excludedDaysOfWeek'] != null && json['excludedDaysOfWeek'] is List
        ? (json['excludedDaysOfWeek'] as List)
              .map((e) => int.tryParse(e.toString()) ?? 0)
              .toList()
        : [];

    timeslotsPerDay = json['timeslotsPerDay'] != null
        ? int.tryParse(json['timeslotsPerDay'].toString())
        : null;

    if (json['subjectsConfig'] != null && json['subjectsConfig'] is List) {
      subjectsConfig = <PopulatedSubjectConfig>[];
      for (var v in (json['subjectsConfig'] as List)) {
        if (v is Map<String, dynamic>) {
          subjectsConfig!.add(PopulatedSubjectConfig.fromJson(v));
        }
      }
    }

    createdBy = _safeParseString(json['createdBy']);
    createdAt = _safeParseString(json['createdAt']);
    updatedAt = _safeParseString(json['updatedAt']);
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
    subjectId =
        (json['subjectId'] != null && json['subjectId'] is Map<String, dynamic>)
        ? PopulatedSubjectInfo.fromJson(json['subjectId'])
        : null;

    carriedStudentsCount = json['carriedStudentsCount'] != null
        ? int.tryParse(json['carriedStudentsCount'].toString())
        : null;

    examDurationOverride = json['examDurationOverride'] != null
        ? int.tryParse(json['examDurationOverride'].toString())
        : null;
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
    sId = _safeParseString(json['_id']);
    name = _safeParseString(json['name']);

    yearId = (json['yearId'] != null && json['yearId'] is Map<String, dynamic>)
        ? PopulatedYear.fromJson(json['yearId'])
        : null;

    semesterId =
        (json['semesterId'] != null &&
            json['semesterId'] is Map<String, dynamic>)
        ? PopulatedSemester.fromJson(json['semesterId'])
        : null;

    createdBy = _safeParseString(json['createdBy']);
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
    sId = _safeParseString(json['_id']);
    name = _safeParseString(json['name']);
    createdAt = _safeParseString(json['createdAt']);
    updatedAt = _safeParseString(json['updatedAt']);
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
    sId = _safeParseString(json['_id']);
    name = _safeParseString(json['name']);

    order = json['order'] != null
        ? int.tryParse(json['order'].toString())
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['order'] = order;
    return data;
  }
}
