import 'package:bluebits_app/core/shares/years/models/year_model.dart';

import '../api_service/year_api_service.dart';

class YearRepository {
  final YearApiService apiService;

  YearRepository(this.apiService);

  // ==========================================
  // 1. جلب كل السنوات
  // ==========================================
  Future<YearModel> getAllYears(String token) async {
    final response = await apiService.getAllYears(token);
    print('-------------------------------------------');
    print('repoyear: ${response}');
    print('-------------------------------------------');
    return YearModel.fromJson(response); // التحويل فقط
  }

  // ==========================================
  // 2. إنشاء سنة جديدة
  // ==========================================
  Future<YearModel> createYear(String token, String name, int order) async {
    final response = await apiService.createYear(token, name, order);
    return YearModel.fromJson(response); // التحويل فقط
  }

  // ==========================================
  // 3. جلب سنة محددة بالـ ID
  // ==========================================
  Future<YearModel> getYearById(String token, String yearId) async {
    final response = await apiService.getYearById(token, yearId);
    return YearModel.fromJson(response); // التحويل فقط
  }

  // ==========================================
  // 4. تحديث سنة
  // ==========================================
  Future<YearModel> updateYear(
    String token,
    String yearId,
    String newName,
  ) async {
    final response = await apiService.updateYear(token, yearId, newName);
    return YearModel.fromJson(response); // التحويل فقط
  }

  // ==========================================
  // 5. حذف سنة
  // ==========================================
  Future<YearModel> deleteYear(String token, String yearId) async {
    final response = await apiService.deleteYear(token, yearId);
    return YearModel.fromJson(response); // التحويل فقط
  }
}
