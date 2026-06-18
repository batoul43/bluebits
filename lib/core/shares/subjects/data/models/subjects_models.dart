class SubjectModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  List<Data>? data;

  SubjectModel({this.isSuccess, this.message, this.statusCode, this.data});

  SubjectModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'] == true;
    message = json['message']?.toString();
    statusCode = json['statusCode'] is int
        ? json['statusCode'] as int
        : int.tryParse(json['statusCode']?.toString() ?? '');

    if (json['data'] != null) {
      if (json['data'] is List) {
        data = <Data>[];
        for (final item in json['data']) {
          if (item is Map<String, dynamic>) {
            data!.add(Data.fromJson(item));
          }
        }
      } else if (json['data'] is Map<String, dynamic>) {
        // للتعامل المرن في حال إرجاع كائن مادة واحدة عند الإنشاء أو التعديل أو جلب مادة بالـ ID
        data = <Data>[Data.fromJson(json['data'])];
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSuccess'] = isSuccess;
    data['message'] = message;
    data['statusCode'] = statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  YearId? yearId;
  SemesterId? semesterId;
  String? description;
  CreatedBy? createdBy;
  String? createdAt;
  String? updatedAt;

  Data({
    this.sId,
    this.name,
    this.yearId,
    this.semesterId,
    this.description,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    name = json['name']?.toString();

    yearId = json['yearId'] != null && json['yearId'] is Map<String, dynamic>
        ? YearId.fromJson(json['yearId'])
        : null;

    semesterId =
        json['semesterId'] != null && json['semesterId'] is Map<String, dynamic>
        ? SemesterId.fromJson(json['semesterId'])
        : null;

    description = json['description']?.toString();

    createdBy =
        json['createdBy'] != null && json['createdBy'] is Map<String, dynamic>
        ? CreatedBy.fromJson(json['createdBy'])
        : null;

    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
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
    sId = json['_id']?.toString();
    name = json['name']?.toString();
    order = json['order'] is int
        ? json['order'] as int
        : int.tryParse(json['order']?.toString() ?? '');
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
    sId = json['_id']?.toString();
    name = json['name']?.toString();
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
    sId = json['_id']?.toString();
    name = json['name']?.toString();
    email = json['email']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    return data;
  }
}
