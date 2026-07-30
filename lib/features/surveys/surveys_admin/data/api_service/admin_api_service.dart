import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminSurveyApiService {
  final String baseUrl = "https://bluebits24.onrender.com/api/v1.0.0/surveys";

  /// 1. إنشاء نموذج استبيان جديد
  Future<Map<String, dynamic>> createForm(
    String token,
    String semesterId,
    String yearId,
    String academicYear,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forms'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'semesterId': semesterId,
          'yearId': yearId,
          'academicYear': academicYear,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء إنشاء الاستبيان: $e');
    }
  }

  /// 2. تفعيل / فتح الاستبيان
  Future<Map<String, dynamic>> openForm(String token, String formId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/forms/$formId/open'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء فتح الاستبيان: $e');
    }
  }

  /// 3. إغلاق الاستبيان
  Future<Map<String, dynamic>> closeForm(String token, String formId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/forms/$formId/close'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء إغلاق الاستبيان: $e');
    }
  }

  /// 4. جلب نتائج وإحصائيات الاستبيان
  Future<Map<String, dynamic>> getFormResults(
    String token,
    String formId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forms/$formId/responses'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب النتائج: $e');
    }
  }

  /// 5. حذف الاستبيان
  Future<Map<String, dynamic>> deleteForm(String token, String formId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/forms/$formId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء الحذف: $e');
    }
  }

  /// 6. جلب جميع الاستبيانات (لإدارتها)
  Future<Map<String, dynamic>> getAllForms(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forms'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }
}
