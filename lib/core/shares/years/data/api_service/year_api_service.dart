import 'dart:convert';
import 'package:http/http.dart' as http;

class YearApiService {
  final String baseUrl = "https://bluebits24.onrender.com/api/v1.0.0/years";

  // ==========================================
  // 1. إنشاء سنة جديدة (Create)
  // ==========================================
  Future<Map<String, dynamic>> createYear(
    String token,
    String name,
    int order,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": name,
          "order": order, // مررناه كـ int بناءً على المودل الخاص بكِ
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  // ==========================================
  // 2. جلب جميع السنوات (Get All)
  // ==========================================
  Future<Map<String, dynamic>> getAllYears(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print('-----------------------------------');
      print('yearapi: ${response.statusCode}');
      print('-----------------------------------');
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  // ==========================================
  // 3. جلب سنة محددة (Get One)
  // ==========================================
  Future<Map<String, dynamic>> getYearById(String token, String yearId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$yearId'),
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

  // ==========================================
  // 4. تحديث سنة (Update)
  // ==========================================
  Future<Map<String, dynamic>> updateYear(
    String token,
    String yearId,
    String newName,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$yearId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"name": newName}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  // ==========================================
  // 5. حذف سنة (Delete)
  // ==========================================
  Future<Map<String, dynamic>> deleteYear(String token, String yearId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$yearId'),
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
