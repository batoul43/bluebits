part of 'admin_survey_cubit.dart';

abstract class AdminSurveyState {}

class AdminSurveyInitial extends AdminSurveyState {}

class AdminSurveyLoading extends AdminSurveyState {}

class AdminSurveysLoaded extends AdminSurveyState {
  final List<AdminFormModel> forms;
  AdminSurveysLoaded(this.forms);
}

class AdminSurveyResultsLoaded extends AdminSurveyState {
  // يمكنك لاحقاً إنشاء مودل خاص بالنتائج وتمريره هنا بدلاً من dynamic
  final dynamic results;
  AdminSurveyResultsLoaded(this.results);
}

class AdminSurveyActionSuccess extends AdminSurveyState {
  final String message;
  AdminSurveyActionSuccess(this.message);
}

class AdminSurveyError extends AdminSurveyState {
  final String message;
  AdminSurveyError(this.message);
}
