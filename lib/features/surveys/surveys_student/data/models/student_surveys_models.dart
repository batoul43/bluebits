class StudentSurveyModels {
  final bool? isSuccess;
  final String? status;
  final String? message;
  final int? statusCode;
  final SurveyData? data;

  StudentSurveyModels({
    this.isSuccess,
    this.status,
    this.message,
    this.statusCode,
    this.data,
  });

  factory StudentSurveyModels.fromJson(Map<String, dynamic> json) {
    bool success =
        json['isSuccess'] == true ||
        json['status'] == 'success' ||
        json['statusCode'] == 200 ||
        json['statusCode'] == '200';

    int? parsedStatusCode;
    if (json['statusCode'] != null) {
      parsedStatusCode = json['statusCode'] is int
          ? json['statusCode']
          : int.tryParse(json['statusCode'].toString());
    }

    SurveyData? parsedData;
    if (json['data'] != null) {
      if (json['data'] is List) {
        List dataList = json['data'] as List;
        if (dataList.isNotEmpty &&
            (dataList.first.containsKey('subjectResponses') ||
                dataList.first.containsKey('formId'))) {
          parsedData = SurveyData(
            responses: dataList
                .map(
                  (e) =>
                      SurveyResponseModel.fromJson(e as Map<String, dynamic>),
                )
                .toList(),
          );
        } else {
          parsedData = SurveyData(
            forms: dataList
                .map((e) => SurveyForm.fromJson(e as Map<String, dynamic>))
                .toList(),
          );
        }
      } else if (json['data'] is Map) {
        parsedData = SurveyData.fromJson(json['data'] as Map<String, dynamic>);
      }
    }

    return StudentSurveyModels(
      isSuccess: success,
      status: json['status']?.toString(),
      message: json['message']?.toString(),
      statusCode: parsedStatusCode,
      data: parsedData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'status': status,
      'message': message,
      'statusCode': statusCode,
      'data': data?.toJson(),
    };
  }
}

class SurveyData {
  final SurveyForm? form;
  final bool? alreadySubmitted;
  final List<SurveyForm>? forms;
  final List<SurveyResponseModel>? responses;
  final SurveyResponseModel? response;
  final List<dynamic>? stats;
  final List<dynamic>? subjectResponses;
  final List<dynamic>?
  subjects; // تم إضافة هذا المفتاح ليتوافق مع رد الـ API الجديد

  SurveyData({
    this.form,
    this.alreadySubmitted,
    this.forms,
    this.responses,
    this.response,
    this.stats,
    this.subjectResponses,
    this.subjects,
  });

  factory SurveyData.fromJson(Map<String, dynamic> json) {
    List<SurveyForm>? extractedForms;
    var rawForms = json['forms'] ?? json['activeForms'];
    if (rawForms is List) {
      extractedForms = rawForms
          .map((i) => SurveyForm.fromJson(i is Map<String, dynamic> ? i : {}))
          .toList();
    }

    SurveyForm? singleForm = json['form'] != null && json['form'] is Map
        ? SurveyForm.fromJson(json['form'])
        : null;

    if ((extractedForms == null || extractedForms.isEmpty) &&
        singleForm != null) {
      extractedForms = [singleForm];
    }

    bool? parsedAlreadySubmitted;
    if (json['alreadySubmitted'] != null) {
      if (json['alreadySubmitted'] is bool) {
        parsedAlreadySubmitted = json['alreadySubmitted'];
      } else {
        parsedAlreadySubmitted =
            json['alreadySubmitted'].toString().toLowerCase() == 'true';
      }
    }

    List<SurveyResponseModel>? extractedResponses;
    if (json['responses'] != null && json['responses'] is List) {
      extractedResponses = (json['responses'] as List)
          .map(
            (i) => SurveyResponseModel.fromJson(
              i is Map<String, dynamic> ? i : {},
            ),
          )
          .toList();
    } else if (json.containsKey('subjectResponses') ||
        json.containsKey('formId')) {
      extractedResponses = [SurveyResponseModel.fromJson(json)];
    }

    return SurveyData(
      form: singleForm,
      alreadySubmitted: parsedAlreadySubmitted,
      forms: extractedForms,
      responses: extractedResponses,
      stats: json['stats'] as List<dynamic>?,
      subjectResponses: json['subjectResponses'] as List<dynamic>?,
      subjects: json['subjects'] as List<dynamic>?, // قراءة المفتاح من الـ JSON
      response: (json['response'] != null && json['response'] is Map)
          ? SurveyResponseModel.fromJson(json['response'])
          : (json['subjectResponses'] != null
                ? SurveyResponseModel.fromJson(json)
                : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'form': form?.toJson(),
      'alreadySubmitted': alreadySubmitted,
      'forms': forms?.map((e) => e.toJson()).toList(),
      'responses': responses?.map((e) => e.toJson()).toList(),
      'response': response?.toJson(),
      'stats': stats,
      'subjectResponses': subjectResponses,
      'subjects': subjects,
    };
  }
}

class SurveyResponseModel {
  final String? id;
  final String? formId;
  final String? formName;
  final List<dynamic>? subjectResponses;
  final String? createdAt;

  SurveyResponseModel({
    this.id,
    this.formId,
    this.formName,
    this.subjectResponses,
    this.createdAt,
  });

  factory SurveyResponseModel.fromJson(Map<String, dynamic> json) {
    String? parsedFormId;
    String? parsedFormName;

    if (json['formId'] != null) {
      if (json['formId'] is Map) {
        parsedFormId = (json['formId']['_id'] ?? json['formId']['id'])
            ?.toString();
        parsedFormName = json['formId']['academicYear']?.toString();
      } else {
        parsedFormId = json['formId'].toString();
      }
    }

    return SurveyResponseModel(
      id: (json['_id'] ?? json['id'])?.toString(),
      formId: parsedFormId,
      formName: parsedFormName,
      subjectResponses: json['subjectResponses'] as List<dynamic>?,
      createdAt: json['createdAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'formId': formId,
    'subjectResponses': subjectResponses,
    'createdAt': createdAt,
  };
}

class SurveyForm {
  final String? id;
  final SemesterId? semesterId;
  final YearId? yearId;
  final String? academicYear;
  final String? status;
  final String? openedAt;
  final String? closedAt;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  SurveyForm({
    this.id,
    this.semesterId,
    this.yearId,
    this.academicYear,
    this.status,
    this.openedAt,
    this.closedAt,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory SurveyForm.fromJson(Map<String, dynamic> json) {
    String? parsedCreatedBy;
    if (json['createdBy'] != null) {
      if (json['createdBy'] is Map) {
        parsedCreatedBy = (json['createdBy']['_id'] ?? json['createdBy']['id'])
            ?.toString();
      } else {
        parsedCreatedBy = json['createdBy'].toString();
      }
    }

    return SurveyForm(
      id: (json['_id'] ?? json['id'])?.toString(),
      semesterId: json['semesterId'] != null
          ? (json['semesterId'] is Map
                ? SemesterId.fromJson(json['semesterId'])
                : SemesterId(
                    id: json['semesterId'].toString(),
                    name: json['semesterId'].toString(),
                  ))
          : null,
      yearId: json['yearId'] != null
          ? (json['yearId'] is Map
                ? YearId.fromJson(json['yearId'])
                : YearId(
                    id: json['yearId'].toString(),
                    name: json['yearId'].toString(),
                  ))
          : null,
      academicYear: json['academicYear']?.toString(),
      status: json['status']?.toString(),
      openedAt: json['openedAt']?.toString(),
      closedAt: json['closedAt']?.toString(),
      createdBy: parsedCreatedBy,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'semesterId': semesterId?.toJson(),
      'yearId': yearId?.toJson(),
      'academicYear': academicYear,
      'status': status,
      'openedAt': openedAt,
      'closedAt': closedAt,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class SemesterId {
  final String? id;
  final String? name;
  SemesterId({this.id, this.name});
  factory SemesterId.fromJson(Map<String, dynamic> json) {
    return SemesterId(
      id: (json['_id'] ?? json['id'])?.toString(),
      name: json['name']?.toString(),
    );
  }
  Map<String, dynamic> toJson() => {'_id': id, 'name': name};
}

class YearId {
  final String? id;
  final String? name;
  final int? order;
  YearId({this.id, this.name, this.order});
  factory YearId.fromJson(Map<String, dynamic> json) {
    int? parsedOrder;
    if (json['order'] != null) {
      parsedOrder = json['order'] is int
          ? json['order']
          : int.tryParse(json['order'].toString());
    }
    return YearId(
      id: (json['_id'] ?? json['id'])?.toString(),
      name: json['name']?.toString(),
      order: parsedOrder,
    );
  }
  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'order': order};
}
