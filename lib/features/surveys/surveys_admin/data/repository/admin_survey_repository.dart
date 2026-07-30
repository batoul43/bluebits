import 'package:bluebits_app/features/surveys/surveys_admin/data/api_service/admin_api_service.dart';
import 'package:bluebits_app/features/surveys/surveys_admin/data/models/admin_form_response.dart';

class AdminSurveyRepository {
  final AdminSurveyApiService apiService;

  AdminSurveyRepository(this.apiService);

  Future<AdminFormResponse> createForm(
    String token,
    String semesterId,
    String yearId,
    String academicYear,
  ) async {
    final response = await apiService.createForm(
      token,
      semesterId,
      yearId,
      academicYear,
    );
    print('-------------------------------------------');
    print('repoAdminSurvey - CreateForm: $response');
    print('-------------------------------------------');
    return AdminFormResponse.fromJson(response);
  }

  Future<AdminFormResponse> openForm(String token, String formId) async {
    final response = await apiService.openForm(token, formId);
    print('-------------------------------------------');
    print('repoAdminSurvey - OpenForm: $response');
    print('-------------------------------------------');
    return AdminFormResponse.fromJson(response);
  }

  Future<AdminFormResponse> closeForm(String token, String formId) async {
    final response = await apiService.closeForm(token, formId);
    print('-------------------------------------------');
    print('repoAdminSurvey - CloseForm: $response');
    print('-------------------------------------------');
    return AdminFormResponse.fromJson(response);
  }

  Future<AdminFormResponse> getFormResults(String token, String formId) async {
    final response = await apiService.getFormResults(token, formId);
    print('-------------------------------------------');
    print('repoAdminSurvey - GetResults: $response');
    print('-------------------------------------------');
    return AdminFormResponse.fromJson(response);
  }

  Future<AdminFormResponse> deleteForm(String token, String formId) async {
    // بنفس أسلوب الملف المرفق، بعض العمليات مثل الحذف لا تحتوي على print
    final response = await apiService.deleteForm(token, formId);
    return AdminFormResponse.fromJson(response);
  }

  Future<AdminFormResponse> getAllForms(String token) async {
    final response = await apiService.getAllForms(token);
    print('-------------------------------------------');
    print('repoAdminSurvey - GetAllForms: $response');
    print('-------------------------------------------');
    return AdminFormResponse.fromJson(response);
  }
}
