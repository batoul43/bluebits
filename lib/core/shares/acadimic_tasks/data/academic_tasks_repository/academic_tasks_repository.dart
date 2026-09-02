import 'package:bluebits_app/core/shares/acadimic_tasks/data/api_service/acaddemic_tasks_api_service.dart';
import 'package:bluebits_app/core/shares/acadimic_tasks/data/models/academic_model.dart';

class AcademicTaskRepository {
  final AcademicTaskApiService apiService;

  AcademicTaskRepository(this.apiService);

  /// إنشاء مهمة أكاديمية جديدة
  Future<Map<String, dynamic>> createTask(
    String token,
    CreateAcademicTaskRequest request,
  ) async {
    final response = await apiService.createTask(token, request.toJson());
    print('-------------------------------------------');
    print('repoAcademicTask - Create: $response');
    print('-------------------------------------------');
    return response;
  }

  /// جلب كافة المهام الأكاديمية
  Future<Map<String, dynamic>> getAllAcademicTasks(String token) async {
    final response = await apiService.getAllAcademicTasks(token);
    print('-------------------------------------------');
    print('repoAcademicTask - GetAll: $response');
    print('-------------------------------------------');
    return response;
  }

  /// جلب مهمة واحدة عبر الـ ID
  Future<Map<String, dynamic>> getAcademicTaskById(
    String token,
    String taskId,
  ) async {
    final response = await apiService.getAcademicTaskById(token, taskId);
    print('-------------------------------------------');
    print('repoAcademicTask - GetById: $response');
    print('-------------------------------------------');
    return response;
  }

  /// تعديل مهمة أكاديمية
  Future<Map<String, dynamic>> updateTask(
    String token,
    String taskId,
    UpdateAcademicTaskRequest request,
  ) async {
    final response = await apiService.updateTask(
      token,
      taskId,
      request.toJson(),
    );
    print('-------------------------------------------');
    print('repoAcademicTask - Update: $response');
    print('-------------------------------------------');
    return response;
  }

  /// حذف مهمة أكاديمية
  Future<Map<String, dynamic>> deleteTask(String token, String taskId) async {
    final response = await apiService.deleteTask(token, taskId);
    print('-------------------------------------------');
    print('repoAcademicTask - Delete: $response');
    print('-------------------------------------------');
    return response;
  }

  /// إغلاق مهمة أكاديمية يدوياً
  Future<Map<String, dynamic>> closeTask(String token, String taskId) async {
    final response = await apiService.closeTask(token, taskId);
    print('-------------------------------------------');
    print('repoAcademicTask - Close: $response');
    print('-------------------------------------------');
    return response;
  }

  /// فلترة المهام حسب السنة أو المادة
  Future<Map<String, dynamic>> getTasksByFilter({
    required String token,
    String? yearId,
    String? subjectId,
  }) async {
    final response = await apiService.getTasksByFilter(
      token: token,
      yearId: yearId,
      subjectId: subjectId,
    );
    print('-------------------------------------------');
    print('repoAcademicTask - GetByFilter: $response');
    print('-------------------------------------------');
    return response;
  }
}
