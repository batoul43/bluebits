import 'dart:convert';
import 'package:http/http.dart' as http;

class SemesterApiService {
  // ملاحظة: افترضت أن الرابط مشابه لرابط السنوات، يرجى التأكد من مطابقته للرابط الفعلي في الباك-إند
  final String baseUrl = "https://bluebits24.onrender.com/api/v1.0.0/semesters";

  // ==========================================
  // 1. إنشاء فصل جديد (Create)
  // ==========================================
  Future<Map<String, dynamic>> createSemester(String token, String name) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },

        body: jsonEncode({"name": name}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  // ==========================================
  // 2. جلب جميع الفصول (Get All)
  // ==========================================
  Future<Map<String, dynamic>> getAllSemesters(String token) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };

      // اطبع الهيدرز هنا لترى هل التوكن يرسل بشكل صحيح؟
      print("Sending Headers: $headers");
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print('-----------------------------------');
      print('Semester API Get All: ${response.statusCode}');
      print('-----------------------------------');
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  // ==========================================
  // 3. جلب فصل محدد (Get One)
  // ==========================================
  Future<Map<String, dynamic>> getSemesterById(
    String token,
    String semesterId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$semesterId'),
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
  // 4. تحديث فصل (Update)
  // ==========================================
  Future<Map<String, dynamic>> updateSemester(
    String token,
    String semesterId,
    String newName,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$semesterId'),
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
  // 5. حذف فصل (Delete)
  // ==========================================
  Future<Map<String, dynamic>> deleteSemester(
    String token,
    String semesterId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$semesterId'),
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
