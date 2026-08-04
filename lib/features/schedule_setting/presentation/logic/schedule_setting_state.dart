part of 'schedule_setting_cubit.dart';

abstract class ScheduleSettingState {}

class ScheduleSettingInitial extends ScheduleSettingState {}

class ScheduleSettingLoading extends ScheduleSettingState {}

class ScheduleSettingLoaded extends ScheduleSettingState {
  // تم التعديل هنا ليتوافق مع المودل ScheduleConfigModel
  final ScheduleConfigModel scheduleConfig;

  ScheduleSettingLoaded(this.scheduleConfig);
}

class ScheduleConflictLoaded extends ScheduleSettingState {
  // تم التعديل هنا ليتوافق مع المودل ScheduleConfigModel
  final ScheduleConfigModel scheduleConflict;

  ScheduleConflictLoaded(this.scheduleConflict);
}

class ScheduleSolvetimefoldLoaded extends ScheduleSettingState {
  // تم التعديل هنا ليتوافق مع المودل ScheduleSolvetimefoldResponse
  final ScheduleSolvetimefoldResponse scheduleSolvetimefold;

  ScheduleSolvetimefoldLoaded(this.scheduleSolvetimefold);
}

class ScheduleSolveLoaded extends ScheduleSettingState {
  // تم التعديل هنا ليتوافق مع المودل ScheduleSolveModel
  final ScheduleSolveModel scheduleSolve;

  ScheduleSolveLoaded(this.scheduleSolve);
}

class ScheduleResultLoaded extends ScheduleSettingState {
  // تم التعديل هنا ليتوافق مع المودل ScheduleSolveModel
  final ScheduleResultModel scheduleResultModel;

  ScheduleResultLoaded(this.scheduleResultModel);
}

class SchedulePublishLoaded extends ScheduleSettingState {
  // تم التعديل هنا ليتوافق مع المودل ScheduleSolveModel
  final SchedulePublishModel schedulePublishModel;

  SchedulePublishLoaded(this.schedulePublishModel);
}

class SettingPerSemesterLoaded extends ScheduleSettingState {
  // تم التعديل هنا ليتوافق مع المودل SettingPerSemesterModel
  final SettingPerSemesterModel settingPerSemesterModel;

  SettingPerSemesterLoaded(this.settingPerSemesterModel);
}

class UpdateScheduleConfig extends ScheduleSettingState {
  final UpdateScheduleConfigModel updateScheduleConfig;

  UpdateScheduleConfig(this.updateScheduleConfig);
}

class DeleteSuccess extends ScheduleSettingState {
  final String message;
  DeleteSuccess(this.message);
}

class ScheduleSettingActionResult extends ScheduleSettingState {
  final String message;
  final dynamic data;

  ScheduleSettingActionResult(this.message, {this.data});
}

class ScheduleSettingError extends ScheduleSettingState {
  final String message;

  ScheduleSettingError(this.message);
}
