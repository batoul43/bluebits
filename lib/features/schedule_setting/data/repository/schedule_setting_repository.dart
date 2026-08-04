import 'package:bluebits_app/features/schedule_setting/data/api_Service/schedule_setting_api_service.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedul_config_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_publish_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_result_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_solve_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_solvetimefold_response.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/setting_per_semester_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/update_schedule_config_model.dart';

class ScheduleSettingRepository {
  final ScheduleSettingApiService apiService;

  ScheduleSettingRepository(this.apiService);

  /// 1. إنشاء إعدادات جدول جديد
  Future<ScheduleConfigModel> createScheduleConfig(
    String token,
    Map<String, dynamic> configData,
  ) async {
    final response = await apiService.createScheduleConfig(token, configData);
    print('-------------------------------------------');
    print('repoScheduleConfig - Create: $response');
    print('-------------------------------------------');
    return ScheduleConfigModel.fromJson(response);
  }

  /// 2. توليد بيانات الجدول بناءً على semesterId
  Future<ScheduleConfigModel> generateScheduleData(
    String token,
    String semesterId,
  ) async {
    // استدعاء الدالة من طبقة الـ apiService وتمرير التوكن ومعرف الفصل
    final response = await apiService.generateScheduleData(token, semesterId);

    print('-------------------------------------------');
    print('repoScheduleConfig - Generate Data: $response');
    print('-------------------------------------------');

    // تحويل الاستجابة إلى نموذج التعارضات
    return ScheduleConfigModel.fromJson(response);
  }

  // 3. timefold
  Future<ScheduleSolvetimefoldResponse> solveTimefold(
    String token,
    Map<String, dynamic> timefoldData,
  ) async {
    // استدعاء الدالة من طبقة الـ apiService وتمرير التوكن ومعرف الفصل
    final response = await apiService.solveTimefold(token, timefoldData);

    print('-------------------------------------------');
    print('repoScheduleConfig - Generate Data: $response');
    print('-------------------------------------------');

    // تحويل الاستجابة إلى نموذج التعارضات
    return ScheduleSolvetimefoldResponse.fromJson(response);
  }

  //4.solve
  Future<ScheduleSolveModel> solveSchedule(
    String token,
    String semesterId,
    String academicYear,
  ) async {
    // استدعاء الدالة من طبقة الـ apiService وتمرير التوكن ومعرف الفصل
    final response = await apiService.solveSchedule(
      token,
      semesterId,
      academicYear,
    );

    print('-------------------------------------------');
    print('repoScheduleConfig - Generate Data: $response');
    print('-------------------------------------------');

    // تحويل الاستجابة إلى نموذج التعارضات
    return ScheduleSolveModel.fromJson(response);
  }

  //5.result
  Future<ScheduleResultModel> getScheduleResult(
    String token,
    String semesterId,
  ) async {
    // استدعاء الدالة من طبقة الـ apiService وتمرير التوكن ومعرف الفصل
    final response = await apiService.getScheduleResult(token, semesterId);

    print('-------------------------------------------');
    print('repoScheduleresult - Generate Data: $response');
    print('-------------------------------------------');

    // تحويل الاستجابة إلى نموذج التعارضات
    return ScheduleResultModel.fromJson(response);
  }

  //6.publish
  Future<SchedulePublishModel> publishSchedule(
    String token,
    String semesterId,
  ) async {
    // استدعاء الدالة من طبقة الـ apiService وتمرير التوكن ومعرف الفصل
    final response = await apiService.publishSchedule(token, semesterId);

    print('-------------------------------------------');
    print('repoSchedulePublish - Generate Data: $response');
    print('-------------------------------------------');

    // تحويل الاستجابة إلى نموذج التعارضات
    return SchedulePublishModel.fromJson(response);
  }

  //7.setting per semester
  Future<SettingPerSemesterModel> getSettingPerSemester(
    String token,
    String semesterId,
  ) async {
    // استدعاء الدالة من طبقة الـ apiService وتمرير التوكن ومعرف الفصل
    final response = await apiService.getSettingPerSemester(token, semesterId);

    print('-------------------------------------------');
    print('repoSettingPerSemester - Generate Data: $response');
    print('-------------------------------------------');

    // تحويل الاستجابة إلى نموذج التعارضات
    return SettingPerSemesterModel.fromJson(response);
  }

  ///  8. مثال لدالة تحديث إعدادات الجدول

  Future<UpdateScheduleConfigModel> updateScheduleConfig(
    String token,
    String id,
    Map<String, dynamic> configData,
  ) async {
    final response = await apiService.updateScheduleConfig(
      token,
      id,
      configData,
    );

    print('-------------------------------------------');
    print('repo:update - Generate Data: $response');
    print('-------------------------------------------');

    return UpdateScheduleConfigModel.fromJson(response);
  }

  /// 9.  لدالة حذف إعدادات الجدول
  Future<UpdateScheduleConfigModel> deleteScheduleConfig(
    String token,
    String id,
  ) async {
    final response = await apiService.deleteScheduleConfig(token, id);

    print('-------------------------------------------');
    print('repo:update - Generate Data: $response');
    print('-------------------------------------------');

    return UpdateScheduleConfigModel.fromJson(response);
  }
}
