class ScheduleSolveModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  ScheduleGeneratedData? data;

  ScheduleSolveModel({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.data,
  });

  ScheduleSolveModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null
        ? ScheduleGeneratedData.fromJson(json['data'])
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

class ScheduleGeneratedData {
  String? semesterId;
  String? academicYear;
  String? status;
  List<TimetableItem>? timetable;
  ScheduleScore? score;
  String? sId;
  String? createdAt;
  String? updatedAt;

  ScheduleGeneratedData({
    this.semesterId,
    this.academicYear,
    this.status,
    this.timetable,
    this.score,
    this.sId,
    this.createdAt,
    this.updatedAt,
  });

  ScheduleGeneratedData.fromJson(Map<String, dynamic> json) {
    semesterId = json['semesterId'];
    academicYear = json['academicYear'];
    status = json['status'];
    if (json['timetable'] != null) {
      timetable = <TimetableItem>[];
      json['timetable'].forEach((v) {
        timetable!.add(TimetableItem.fromJson(v));
      });
    }
    score = json['score'] != null
        ? ScheduleScore.fromJson(json['score'])
        : null;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['semesterId'] = semesterId;
    data['academicYear'] = academicYear;
    data['status'] = status;
    if (timetable != null) {
      data['timetable'] = timetable!.map((v) => v.toJson()).toList();
    }
    if (score != null) {
      data['score'] = score!.toJson();
    }
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class TimetableItem {
  String? subjectId;
  String? subjectName;
  String? examDate;
  int? timeslot;
  String? sId;

  TimetableItem({
    this.subjectId,
    this.subjectName,
    this.examDate,
    this.timeslot,
    this.sId,
  });

  TimetableItem.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'];
    subjectName = json['subjectName'];
    examDate = json['examDate'];
    timeslot = json['timeslot'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subjectId'] = subjectId;
    data['subjectName'] = subjectName;
    data['examDate'] = examDate;
    data['timeslot'] = timeslot;
    data['_id'] = sId;
    return data;
  }
}

class ScheduleScore {
  int? hardScore;
  int? softScore;
  String? raw;

  ScheduleScore({this.hardScore, this.softScore, this.raw});

  ScheduleScore.fromJson(Map<String, dynamic> json) {
    hardScore = json['hardScore'];
    softScore = json['softScore'];
    raw = json['raw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hardScore'] = hardScore;
    data['softScore'] = softScore;
    data['raw'] = raw;
    return data;
  }
}
