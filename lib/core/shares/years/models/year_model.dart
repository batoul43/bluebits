class YearModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  List<Data>? data;

  YearModel({this.isSuccess, this.message, this.statusCode, this.data});

  YearModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'] == true;
    message = json['message']?.toString();
    statusCode = json['statusCode'] is int
        ? json['statusCode'] as int
        : int.tryParse(json['statusCode']?.toString() ?? '');
    if (json['data'] != null && json['data'] is List) {
      data = <Data>[];
      for (final item in json['data']) {
        if (item is Map<String, dynamic>) {
          data!.add(Data.fromJson(item));
        }
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
  int? order;
  String? createdAt;
  String? updatedAt;

  Data({this.sId, this.name, this.order, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id']?.toString();
    name = json['name']?.toString();
    order = json['order'] is int
        ? json['order'] as int
        : int.tryParse(json['order']?.toString() ?? '');
    createdAt = json['createdAt']?.toString();
    updatedAt = json['updatedAt']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['order'] = order;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
