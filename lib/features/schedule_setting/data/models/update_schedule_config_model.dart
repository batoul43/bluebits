import 'package:bluebits_app/features/schedule_setting/data/models/schedul_config_model.dart';

class UpdateScheduleConfigModel {
  bool? isSuccess;
  String? message;
  int? statusCode;
  ScheduleConfigData? data;

  UpdateScheduleConfigModel({
    this.isSuccess,
    this.message,
    this.statusCode,
    this.data,
  });

  UpdateScheduleConfigModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null
        ? ScheduleConfigData.fromJson(json['data'])
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
