class LessonLectureModels {
  bool? isSuccess;
  String? message;
  int? statusCode;

  // المتغير القديم للقوائم
  LectureResponseData? data;
  // المتغير الجديد المخصص لمعلومات التحميل فقط
  DownloadLectureData? downloadData;
  List<Data>? lectures;

  LessonLectureModels({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.data,
    this.downloadData,
    this.lectures,
  });

  LessonLectureModels.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];

    if (json['data'] != null) {
      // الفحص الذكي: إذا احتوى الـ JSON على رابط تحميل، نعينه للمتغير الجديد
      if (json['data'] is Map<String, dynamic> &&
          json['data'].containsKey('downloadUrl')) {
        downloadData = DownloadLectureData.fromJson(json['data']);
      } else if (json['data'] is List) {
        data = LectureResponseData(lectures: []);
        json['data'].forEach((v) {
          data!.lectures!.add(Data.fromJson(v));
        });
      }
      // غير ذلك، فهو الاستجابة الطبيعية التي تجلب قائمة المحاضرات
      else {
        data = LectureResponseData.fromJson(json['data']);
      }
    }
  }
}

// ----------------------------------------------------
// الكلاس الجديد (صغير جداً ولا يكرر الحقول الخارجية)
// ----------------------------------------------------
class DownloadLectureData {
  String? downloadUrl;
  String? title;
  String? fileType;
  int? fileSize;

  DownloadLectureData.fromJson(Map<String, dynamic> json) {
    downloadUrl = json['downloadUrl'];
    title = json['title'];
    fileType = json['fileType'];
    fileSize = json['fileSize'];
  }
}

class LectureResponseData {
  int? count;
  String? type;
  List<Data>? lectures;

  LectureResponseData({this.count, this.type, this.lectures});

  LectureResponseData.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    type = json['type'];
    if (json['lectures'] != null) {
      lectures = <Data>[];
      json['lectures'].forEach((v) {
        lectures!.add(Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? id;
  String? title;
  String? description;
  SubjectId? subjectId;
  String? type;
  UploadedBy? uploadedBy;
  bool? isPublished;
  String? fileUrl;
  String? publicId;
  int? fileSize;
  String? fileType;
  String? createdAt;
  String? updatedAt;

  Data({
    this.id,
    this.title,
    this.description,
    this.subjectId,
    this.type,
    this.uploadedBy,
    this.isPublished,
    this.fileUrl,
    this.publicId,
    this.fileSize,
    this.fileType,
    this.createdAt,
    this.updatedAt,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    subjectId = json['subjectId'] != null
        ? SubjectId.fromJson(json['subjectId'])
        : null;
    type = json['type'];
    uploadedBy = json['uploadedBy'] != null
        ? UploadedBy.fromJson(json['uploadedBy'])
        : null;
    isPublished = json['isPublished'];
    fileUrl = json['fileUrl'];
    publicId = json['publicId'];
    fileSize = json['fileSize'];
    fileType = json['fileType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }
}

class SubjectId {
  String? id;
  String? name;
  YearId? yearId;
  SemesterId? semesterId;
  dynamic createdBy;

  SubjectId({this.id, this.name, this.yearId, this.semesterId, this.createdBy});

  SubjectId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    yearId = json['yearId'] != null ? YearId.fromJson(json['yearId']) : null;
    semesterId = json['semesterId'] != null
        ? SemesterId.fromJson(json['semesterId'])
        : null;
    createdBy = json['createdBy'];
  }
}

class YearId {
  String? id;
  String? name;
  int? order;

  YearId({this.id, this.name, this.order});

  YearId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    order = json['order'];
  }
}

class SemesterId {
  String? id;
  String? name;

  SemesterId({this.id, this.name});

  SemesterId.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
  }
}

class UploadedBy {
  String? id;
  String? name;
  String? email;

  UploadedBy({this.id, this.name, this.email});

  UploadedBy.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
  }
}
