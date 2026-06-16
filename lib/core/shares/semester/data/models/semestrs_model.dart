class SemestrsModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  List<Data>? data;

  SemestrsModel({this.isSuccess, this.message, this.statusCode, this.data});

  // استبدلي جزء الـ fromJson داخل SemestrsModel بهذا الشكل:
  SemestrsModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];

    if (json['data'] != null) {
      data = <Data>[];
      // نفحص هل البيانات الراجعة قائمة أم عنصر واحد؟
      if (json['data'] is List) {
        json['data'].forEach((v) {
          data!.add(Data.fromJson(v));
        });
      } else if (json['data'] is Map) {
        // إذا كانت كائن واحد (مثل ما يرجع بعد التعديل أو الإضافة)
        data!.add(Data.fromJson(json['data']));
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
  String? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Data({this.id, this.name, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
