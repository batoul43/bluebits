class ConflictsResponseModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  ConflictsData? data;

  ConflictsResponseModel({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.data,
  });

  ConflictsResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? ConflictsData.fromJson(json['data']) : null;
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

class ConflictsData {
  String? sId;
  String? semesterId;
  List<ConflictItem>? conflicts;

  ConflictsData({this.sId, this.semesterId, this.conflicts});

  ConflictsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    semesterId = json['semesterId'];
    if (json['conflicts'] != null) {
      conflicts = (json['conflicts'] as List)
          .map((x) => ConflictItem.fromJson(x))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'semesterId': semesterId,
      if (conflicts != null)
        'conflicts': conflicts!.map((v) => v.toJson()).toList(),
    };
  }
}

class ConflictItem {
  String? type;
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
    type = json['type'];
    examA = json['examA'];
    examAName = json['examAName'];
    examB = json['examB'];
    examBName = json['examBName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'examA': examA,
      'examAName': examAName,
      'examB': examB,
      'examBName': examBName,
    };
  }
}
