import 'package:flutter/foundation.dart';
import 'package:bluebits_app/features/surveys/surveys_student/data/models/student_surveys_models.dart';
import 'package:bluebits_app/features/surveys/surveys_student/data/surveys_api_service/student_surveys_api_service.dart';

class StudentSurveyRepository {
  final StudentSurveyApiService apiService;

  StudentSurveyRepository(this.apiService);

  Future<StudentSurveyModels> getActiveForms(String token) async {
    final response = await apiService.getActiveForms(token);
    debugPrint('repoSurvey - GetActiveForms: $response');
    return StudentSurveyModels.fromJson(response);
  }

  Future<StudentSurveyModels> submitFormResponse(
    String token,
    Map<String, dynamic> responseData,
  ) async {
    final response = await apiService.submitFormResponse(token, responseData);
    debugPrint('repoSurvey - SubmitFormResponse: $response');
    return StudentSurveyModels.fromJson(response);
  }

  Future<StudentSurveyModels> getMyResponseForForm(
    String token,
    String formId,
  ) async {
    final response = await apiService.getMyResponseForForm(token, formId);
    debugPrint('repoSurvey - GetMyResponseForForm: $response');
    return StudentSurveyModels.fromJson(response);
  }

  Future<StudentSurveyModels> getMyResponses(String token) async {
    final response = await apiService.getMyResponses(token);
    debugPrint('repoSurvey - GetMyResponses: $response');
    return StudentSurveyModels.fromJson(response);
  }

  Future<StudentSurveyModels> getSubjectsStatsByYearAndForm(
    String token,
    String yearId,
    String formId,
  ) async {
    final response = await apiService.getSubjectsStatsByYearAndForm(
      token,
      yearId,
      formId,
    );
    debugPrint('repoSurvey - GetSubjectsStatsByYearAndForm: $response');
    return StudentSurveyModels.fromJson(response);
  }
}
