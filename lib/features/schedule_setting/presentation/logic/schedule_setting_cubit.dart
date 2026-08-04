import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedul_config_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_publish_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_result_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_solve_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_solvetimefold_response.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/setting_per_semester_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/update_schedule_config_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/repository/schedule_setting_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // تأكد من مسار الكاش هيلبر لديك

part 'schedule_setting_state.dart';

class ScheduleSettingCubit extends Cubit<ScheduleSettingState> {
  final ScheduleSettingRepository repository;

  ScheduleSettingCubit({required this.repository})
    : super(ScheduleSettingInitial());

  // 1. إنشاء إعدادات الجدول
  Future<void> createConfig(Map<String, dynamic> configData) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final responseModel = await repository.createScheduleConfig(
        token,
        configData,
      );
      print(responseModel);
      if (responseModel.isSuccess == true) {
        emit(
          ScheduleSettingActionResult(
            responseModel.message ?? 'تم إنشاء إعدادات الجدولة بنجاح',
            data: responseModel.data,
          ),
        );
      } else {
        emit(
          ScheduleSettingError(
            responseModel.message ?? 'فشل في إنشاء إعدادات الجدولة',
          ),
        );
      }
    } catch (e) {
      emit(ScheduleSettingError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 2. تشغيل حل الجدولة (Solve)
  Future<void> solveSchedule(semesterId, academicYear) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final responseModel = await repository.solveSchedule(
        token,
        semesterId,
        academicYear,
      );
      print(responseModel);
      if (responseModel.isSuccess == true) {
        emit(ScheduleSolveLoaded(responseModel));
      } else {
        emit(
          ScheduleSettingError(
            responseModel.message ?? 'فشل في إنشاء إعدادات الجدولة',
          ),
        );
      }
    } catch (e) {
      emit(ScheduleSettingError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  //3.result
  Future<void> getScheduleResult(semesterId) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final responseModel = await repository.getScheduleResult(
        token,
        semesterId,
      );
      print(responseModel);
      if (responseModel.isSuccess == true) {
        emit(ScheduleResultLoaded(responseModel));
      } else {
        emit(
          ScheduleSettingError(
            responseModel.message ?? 'فشل في إنشاء إعدادات الجدولة',
          ),
        );
      }
    } catch (e) {
      emit(ScheduleSettingError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  //4.publish
  Future<void> getSchedulePublish(semesterId) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final responseModel = await repository.publishSchedule(token, semesterId);
      print(responseModel);
      if (responseModel.isSuccess == true) {
        emit(SchedulePublishLoaded(responseModel));
      } else {
        emit(
          ScheduleSettingError(
            responseModel.message ?? 'فشل في إنشاء إعدادات الجدولة',
          ),
        );
      }
    } catch (e) {
      emit(ScheduleSettingError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 5. جلب إعدادات فصل دراسي محدد

  Future<void> getSettingPerSemester(semesterId) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final responseModel = await repository.getSettingPerSemester(
        token,
        semesterId,
      );
      print(responseModel);
      if (responseModel.isSuccess == true) {
        emit(SettingPerSemesterLoaded(responseModel));
      } else {
        emit(
          ScheduleSettingError(
            responseModel.message ?? 'فشل في إنشاء إعدادات الجدولة',
          ),
        );
      }
    } catch (e) {
      emit(ScheduleSettingError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 6. حذف إعدادات الجدول

  Future<void> deleteScheduleConfig(String id) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final responseModel = await repository.deleteScheduleConfig(token, id);
      print(responseModel);
      if (responseModel.isSuccess == true) {
        emit(DeleteSuccess(responseModel.message ?? 'تم حذف الإعدادات بنجاح'));
      } else {
        emit(
          ScheduleSettingError(responseModel.message ?? 'فشل في حذف الإعدادات'),
        );
      }
    } catch (e) {
      emit(ScheduleSettingError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 7. تعديل إعدادات الجدول
  Future<void> updateScheduleConfig(
    String id,
    Map<String, dynamic> configData,
  ) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final responseModel = await repository.updateScheduleConfig(
        token,
        id,
        configData,
      );
      print(responseModel);
      if (responseModel.isSuccess == true) {
        emit(UpdateScheduleConfig(responseModel));
      } else {
        emit(
          ScheduleSettingError(
            responseModel.message ?? 'فشل في إنشاء إعدادات الجدولة',
          ),
        );
      }
    } catch (e) {
      emit(ScheduleSettingError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 8. توليد بيانات الجدولة (Generate Schedule Data)
  Future<void> generateScheduleData(String semesterId) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.generateScheduleData(token, semesterId);

      if (response.isSuccess == true) {
        // الخيار الأول: إرسال حالة Loaded بما أن الـ Repo يرجع ScheduleConfigModel
        emit(ScheduleConflictLoaded(response));

        // الخيار الثاني (بديل): إذا كنتِ تريدين إظهار رسالة نجاح فقط (Snackbar)
        // يمكنك استخدام حالة ActionResult
        // emit(ScheduleSettingActionResult(result.message ?? 'تم توليد البيانات بنجاح', data: result));
      } else {
        // إرسال حالة الخطأ إذا كان isSuccess = false
        emit(
          ScheduleSettingError(
            response.message ?? 'فشل في توليد بيانات الجدول',
          ),
        );
      }
    } catch (e) {
      // 4. التقاط أي أخطاء برمجية أو أخطاء اتصال
      emit(ScheduleSettingError('حدث خطأ: ${e.toString()}'));
    }
  }

  //9. حل التعارضات عبر Timefold Solver
  Future<void> solveTimefold(Map<String, dynamic> solverData) async {
    emit(ScheduleSettingLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.solveTimefold(token, solverData);

      // الخيار الأول: إرسال حالة Loaded بما أن الـ Repo يرجع ScheduleConfigModel
      emit(ScheduleSolvetimefoldLoaded(response));

      // الخيار الثاني (بديل): إذا كنتِ تريدين إظهار رسالة نجاح فقط (Snackbar)
      // يمكنك استخدام حالة ActionResult
      // emit(ScheduleSettingActionResult(result.message ?? 'تم توليد البيانات بنجاح', data: result));
    } catch (e) {
      // 4. التقاط أي أخطاء برمجية أو أخطاء اتصال
      emit(ScheduleSettingError('حدث خطأ: ${e.toString()}'));
    }
  }
}
