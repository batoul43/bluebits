class SubjectsByYearSemester {
  bool? isSuccess;
  String? message;
  int? statusCode;
  Data? data;

  SubjectsByYearSemester({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.data,
  });

  SubjectsByYearSemester.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  int? count;
  List<Subjects>? subjects;

  Data({this.count, this.subjects});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['subjects'] != null) {
      subjects = <Subjects>[];
      json['subjects'].forEach((v) {
        subjects!.add(Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (subjects != null) {
      data['subjects'] = subjects!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  String? sId;
  String? name;
  YearId? yearId;
  SemesterId? semesterId;
  String? description;
  CreatedBy? createdBy;
  String? createdAt;
  String? updatedAt;

  Subjects({
    this.sId,
    this.name,
    this.yearId,
    this.semesterId,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  Subjects.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    yearId = json['yearId'] != null
        ? new YearId.fromJson(json['yearId'])
        : null;
    semesterId = json['semesterId'] != null
        ? SemesterId.fromJson(json['semesterId'])
        : null;
    description = json['description'];
    createdBy = json['createdBy'] != null
        ? CreatedBy.fromJson(json['createdBy'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['description'] = description;
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class YearId {
  String? sId;
  String? name;
  int? order;

  YearId({this.sId, this.name, this.order});

  YearId.fromJson(Map<String, dynamic> json) {
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

class SemesterId {
  String? sId;
  String? name;

  SemesterId({this.sId, this.name});

  SemesterId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    return data;
  }
}

class CreatedBy {
  String? sId;
  String? name;
  String? email;

  CreatedBy({this.sId, this.name, this.email});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
