part of 'student_survey_cubit.dart';

abstract class StudentSurveyState {}

class StudentSurveyInitial extends StudentSurveyState {}

class StudentSurveyLoading extends StudentSurveyState {}

class StudentSurveysLoaded extends StudentSurveyState {
  final List<SurveyForm> surveys;
  StudentSurveysLoaded(this.surveys);
}

class StudentResponsesLoaded extends StudentSurveyState {
  final List<SurveyResponseModel> responses;
  StudentResponsesLoaded(this.responses);
}

class StudentSurveyDetailLoaded extends StudentSurveyState {
  final StudentSurveyModels surveyDetail;
  StudentSurveyDetailLoaded(this.surveyDetail);
}

class StudentSurveyStatsLoaded extends StudentSurveyState {
  final StudentSurveyModels statsModel;

  StudentSurveyStatsLoaded(this.statsModel);
}

class StudentSurveyActionSuccess extends StudentSurveyState {
  final String message;
  StudentSurveyActionSuccess(this.message);
}

class StudentSurveyError extends StudentSurveyState {
  final String message;
  StudentSurveyError(this.message);
}
