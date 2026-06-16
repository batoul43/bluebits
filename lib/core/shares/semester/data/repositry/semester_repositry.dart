// يرجى تعديل المسارات (Imports) بناءً على ترتيب المجلدات الفعلي في مشروعكِ
import 'package:bluebits_app/core/shares/semester/data/models/semestrs_model.dart';

import '../api_service/semester_api_service.dart';

class SemesterRepository {
  final SemesterApiService apiService;

  SemesterRepository(this.apiService);

  // ==========================================
  // 1. جلب كل الفصول
  // ==========================================
  Future<SemestrsModel> getAllSemesters(String token) async {
    final response = await apiService.getAllSemesters(token);
    print('-------------------------------------------');
    print('repoSemester Get All: $response');
    print('-------------------------------------------');
    return SemestrsModel.fromJson(response); // التحويل من JSON إلى Object
  }

  // ==========================================
  // 2. إنشاء فصل جديد
  // ==========================================
  Future<SemestrsModel> createSemester(String token, String name) async {
    final response = await apiService.createSemester(token, name);
    print('-------------------------------------------');
    print('repoSemester Create: $response');
    print('-------------------------------------------');
    return SemestrsModel.fromJson(response);
  }

  // ==========================================
  // 3. جلب فصل محدد بالـ ID
  // ==========================================
  Future<SemestrsModel> getSemesterById(String token, String semesterId) async {
    final response = await apiService.getSemesterById(token, semesterId);
    return SemestrsModel.fromJson(response);
  }

  // ==========================================
  // 4. تحديث فصل
  // ==========================================
  Future<SemestrsModel> updateSemester(
    String token,
    String semesterId,
    String newName,
  ) async {
    final response = await apiService.updateSemester(
      token,
      semesterId,
      newName,
    );
    return SemestrsModel.fromJson(response);
  }

  // ==========================================
  // 5. حذف فصل
  // ==========================================
  Future<SemestrsModel> deleteSemester(String token, String semesterId) async {
    final response = await apiService.deleteSemester(token, semesterId);
    return SemestrsModel.fromJson(response);
  }
}
