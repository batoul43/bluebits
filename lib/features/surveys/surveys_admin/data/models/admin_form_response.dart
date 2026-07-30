class AdminFormResponse {
  final bool? isSuccess;
  final String? message;
  final int? statusCode;
  final dynamic
  data; // يمكن أن يكون List<AdminFormModel> أو AdminFormModel أو FormResultsModel أو String

  AdminFormResponse({this.isSuccess, this.message, this.statusCode, this.data});

  factory AdminFormResponse.fromJson(Map<String, dynamic> json) {
    dynamic parsedData;

    if (json['data'] != null) {
      if (json['data'] is List) {
        // حالة جلب جميع الاستبيانات (List)
        parsedData = (json['data'] as List)
            .map((e) => AdminFormModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (json['data'] is Map<String, dynamic>) {
        final mapData = json['data'] as Map<String, dynamic>;

        // فحص احترافي قوي للتأكد من نوع البيانات القادمة من الـ API
        if (mapData.containsKey('responses') ||
            mapData.containsKey('totalResponses') ||
            mapData.containsKey('form')) {
          // حالة نتائج الاستبيان
          parsedData = FormResultsModel.fromJson(mapData);
        } else {
          // حالة إنشاء استبيان جديد أو كائن استبيان فردي
          parsedData = AdminFormModel.fromJson(mapData);
        }
      } else {
        // حالة نص أو قيمة بسيطة (مثل رسالة نجاح الحذف)
        parsedData = json['data'];
      }
    }

    return AdminFormResponse(
      isSuccess: json['isSuccess'],
      message: json['message'],
      statusCode: json['statusCode'],
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'statusCode': statusCode,
      'data': data,
    };
  }
}

// 1. مودل جديد خاص بنتيجة الاستبيان
class FormResultsModel {
  final AdminFormModel? form;
  final int? totalResponses;
  final List<dynamic>? responses; // يمكن تخصيصه لاحقاً بمودل إجابات تفصيلي

  FormResultsModel({this.form, this.totalResponses, this.responses});

  factory FormResultsModel.fromJson(Map<String, dynamic> json) {
    return FormResultsModel(
      form: json['form'] != null && json['form'] is Map<String, dynamic>
          ? AdminFormModel.fromJson(json['form'] as Map<String, dynamic>)
          : null,
      totalResponses: json['totalResponses'],
      responses: json['responses'] is List ? json['responses'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form': form?.toJson(),
      'totalResponses': totalResponses,
      'responses': responses,
    };
  }
}

// 2. مودل الاستبيان الرئيسي
class AdminFormModel {
  final String? semesterId;
  final String? semesterName;
  final String? yearId;
  final String? yearName;
  final String? academicYear;
  final String? status;
  final String? openedAt;
  final String? closedAt;
  final CreatedByModel? createdBy;
  final String? id;
  final String? createdAt;
  final String? updatedAt;

  AdminFormModel({
    this.semesterId,
    this.semesterName,
    this.yearId,
    this.yearName,
    this.academicYear,
    this.status,
    this.openedAt,
    this.closedAt,
    this.createdBy,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory AdminFormModel.fromJson(Map<String, dynamic> json) {
    String? extractedYearId;
    String? extractedYearName;
    if (json['yearId'] is Map) {
      extractedYearId = json['yearId']['_id']?.toString();
      extractedYearName = json['yearId']['name']?.toString();
    } else {
      extractedYearId = json['yearId']?.toString();
    }

    String? extractedSemesterId;
    String? extractedSemesterName;
    if (json['semesterId'] is Map) {
      extractedSemesterId = json['semesterId']['_id']?.toString();
      extractedSemesterName = json['semesterId']['name']?.toString();
    } else {
      extractedSemesterId = json['semesterId']?.toString();
    }

    return AdminFormModel(
      yearId: extractedYearId,
      yearName: extractedYearName,
      semesterId: extractedSemesterId,
      semesterName: extractedSemesterName,
      academicYear: json['academicYear']?.toString(),
      status: json['status']?.toString(),
      openedAt: json['openedAt']?.toString(),
      closedAt: json['closedAt']?.toString(),
      createdBy:
          json['createdBy'] != null && json['createdBy'] is Map<String, dynamic>
          ? CreatedByModel.fromJson(json['createdBy'] as Map<String, dynamic>)
          : null,
      id: json['_id']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'semesterId': semesterId,
      'semesterName': semesterName,
      'yearId': yearId,
      'yearName': yearName,
      'academicYear': academicYear,
      'status': status,
      'openedAt': openedAt,
      'closedAt': closedAt,
      'createdBy': createdBy?.toJson(),
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class CreatedByModel {
  final String? id;
  final String? name;
  final String? email;

  CreatedByModel({this.id, this.name, this.email});

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'email': email};
  }
}
