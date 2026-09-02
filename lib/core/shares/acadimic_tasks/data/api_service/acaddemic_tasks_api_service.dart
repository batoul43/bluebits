import 'dart:convert';
import 'package:http/http.dart' as http;

class AcademicTaskApiService {
  // استخدام الرابط الأساسي الخاص بالخادم
  final String baseUrl =
      "https://bluebits24.onrender.com/api/v1.0.0/academic-tasks";

  // ==========================================
  // قسم المهام الأكاديمية (Academic Tasks)
  // ==========================================

  /// إنشاء مهمة أكاديمية جديدة
  Future<Map<String, dynamic>> createTask(
    String token,
    Map<String, dynamic> taskData,
  ) async {
    try {
      print('🔵 [API Request] POST $baseUrl');
      print('🔵 [API Body] $taskData');

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(taskData),
      );

      print('🟢 [API Response] Status: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('🔴 [API Error] createTask: $e');
      throw Exception('خطأ في الاتصال بالخادم أثناء إنشاء المهمة: $e');
    }
  }

  /// جلب جميع المهام
  Future<Map<String, dynamic>> getAllAcademicTasks(String token) async {
    try {
      print('🔵 [API Request] GET $baseUrl');
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('🟢 [API Response] Status: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('🔴 [API Error] getAllAcademicTasks: $e');
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب المهام: $e');
    }
  }

  /// جلب مهمة محددة عبر الـ ID
  Future<Map<String, dynamic>> getAcademicTaskById(
    String token,
    String taskId,
  ) async {
    try {
      final url = '$baseUrl/$taskId';
      print('🔵 [API Request] GET $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('🟢 [API Response] Status: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('🔴 [API Error] getAcademicTaskById: $e');
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب المهمة: $e');
    }
  }

  /// تعديل مهمة أكاديمية
  Future<Map<String, dynamic>> updateTask(
    String token,
    String taskId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final url = '$baseUrl/$taskId';
      print('🔵 [API Request] PATCH $url');
      print('🔵 [API Body] $updateData');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updateData),
      );

      print('🟢 [API Response] Status: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('🔴 [API Error] updateTask: $e');
      throw Exception('خطأ في الاتصال بالخادم أثناء تعديل المهمة: $e');
    }
  }

  /// حذف مهمة أكاديمية
  Future<Map<String, dynamic>> deleteTask(String token, String taskId) async {
    try {
      final url = '$baseUrl/$taskId';
      print('🔵 [API Request] DELETE $url');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('🟢 [API Response] Status: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('🔴 [API Error] deleteTask: $e');
      throw Exception('خطأ في الاتصال بالخادم أثناء حذف المهمة: $e');
    }
  }

  /// إغلاق مهمة أكاديمية
  Future<Map<String, dynamic>> closeTask(String token, String taskId) async {
    try {
      final url = '$baseUrl/$taskId/close';
      print('🔵 [API Request] PATCH $url');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('🟢 [API Response] Status: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('🔴 [API Error] closeTask: $e');
      throw Exception('خطأ في الاتصال بالخادم أثناء إغلاق المهمة: $e');
    }
  }

  /// فلترة المهام حسب السنة أو المادة (أو كلاهما معاً)
  Future<Map<String, dynamic>> getTasksByFilter({
    required String token,
    String? yearId,
    String? subjectId,
  }) async {
    try {
      String url = baseUrl;
      if (subjectId != null) {
        url += '/subject/$subjectId';
        if (yearId != null) url += '?yearId=$yearId';
      } else if (yearId != null) {
        url += '/year/$yearId';
      }

      print('🔵 [API Request] GET $url');
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('🟢 [API Response] Status: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('🔴 [API Error] getTasksByFilter: $e');
      throw Exception('خطأ في الاتصال بالخادم أثناء فلترة المهام: $e');
    }
  }
}
