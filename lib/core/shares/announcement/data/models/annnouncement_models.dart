class AnnouncementResponse {
  final bool isSuccess;
  final String message;
  final int statusCode;
  final dynamic data;

  AnnouncementResponse({
    required this.isSuccess,
    required this.message,
    required this.statusCode,
    this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    var rawData = json['data'];
    dynamic parsedData;

    // Dynamically parse the data based on whether it is a List or a single Object
    if (rawData != null) {
      if (rawData is List) {
        parsedData = rawData
            .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (rawData is Map<String, dynamic>) {
        parsedData = AnnouncementModel.fromJson(rawData);
      } else {
        parsedData = rawData;
      }
    }

    return AnnouncementResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      data: parsedData,
    );
  }
}

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  // استخدام الكلاسات المساعدة
  final AnnouncementYear? yearId;
  final AnnouncementCreator? createdBy;
  final String createdAt;
  final String updatedAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.yearId,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      // التعامل الذكي مع حقل yearId (قد يكون String أو Object)
      yearId: json['yearId'] != null
          ? (json['yearId'] is String
                ? AnnouncementYear(id: json['yearId'], name: '', order: 0)
                : AnnouncementYear.fromJson(json['yearId']))
          : null,
      // التعامل الذكي مع حقل createdBy (قد يكون String أو Object)
      createdBy: json['createdBy'] != null
          ? (json['createdBy'] is String
                ? AnnouncementCreator(
                    id: json['createdBy'],
                    name: '',
                    email: '',
                  )
                : AnnouncementCreator.fromJson(json['createdBy']))
          : null,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}

// كلاس مساعد لمعلومات السنة
class AnnouncementYear {
  final String id;
  final String name;
  final int order;

  AnnouncementYear({required this.id, required this.name, required this.order});

  factory AnnouncementYear.fromJson(Map<String, dynamic> json) {
    return AnnouncementYear(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}

// كلاس مساعد لمعلومات منشئ الإعلان
class AnnouncementCreator {
  final String id;
  final String name;
  final String email;

  AnnouncementCreator({
    required this.id,
    required this.name,
    required this.email,
  });

  factory AnnouncementCreator.fromJson(Map<String, dynamic> json) {
    return AnnouncementCreator(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
