import 'package:bluebits_app/features/schedule_setting/data/models/schedule_solve_model.dart';

class ScheduleResultModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  ScheduleGeneratedData? data;

  ScheduleResultModel({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.data,
  });

  ScheduleResultModel.fromJson(Map<String, dynamic> json) {
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
