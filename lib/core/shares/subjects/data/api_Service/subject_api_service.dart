import 'dart:convert';
import 'package:http/http.dart' as http;

class SubjectApiService {
  final String baseUrl = "http://bluebits24.onrender.com/api/v1.0.0/subjects";

  // ==========================================
  // 1. إنشاء مادة جديدة (Create)
  // ==========================================
  Future<Map<String, dynamic>> createSubject(
    String token,
    String name,
    String description,
    String createdBy,
    String yearId,
    String semesterId,
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
          "description": description,
          "createdBy": createdBy,
          "yearId": yearId,
          "semesterId": semesterId,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  // ==========================================
  // 2. جلب جميع المواد (Get All)
  // ==========================================
  Future<Map<String, dynamic>> getAllSubjects(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print('-----------------------------------');
      print('subjectApi: ${response.statusCode}');
      print('-----------------------------------');
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  // ==========================================
  // 3. جلب مادة محددة (Get One)
  // ==========================================
  Future<Map<String, dynamic>> getSubjectById(
    String token,
    String subjectId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$subjectId'),
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
  // 4. تحديث مادة (Update)
  // ==========================================
  Future<Map<String, dynamic>> updateSubject(
    String token,
    String subjectId, {
    String? name,
    String? description,
  }) async {
    try {
      // بناء جسم الطلب بناءً على القيم الممررة فقط لتجنب حذف البيانات الأخرى
      final Map<String, dynamic> bodyData = {};
      if (name != null) bodyData['name'] = name;
      if (description != null) bodyData['description'] = description;

      final response = await http.patch(
        Uri.parse('$baseUrl/$subjectId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(bodyData),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  // ==========================================
  // 5. حذف مادة (Delete)
  // ==========================================
  Future<Map<String, dynamic>> deleteSubject(
    String token,
    String subjectId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$subjectId'),
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
  // 6. جلب المواد حسب السنة (Get By Year)
  // ==========================================
  Future<Map<String, dynamic>> getSubjectsByYear(
    String token,
    String yearId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/year/$yearId'),
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
  // 7. جلب المواد حسب الفصل (Get By Semester)
  // ==========================================
  Future<Map<String, dynamic>> getSubjectsBySemester(
    String token,
    String semesterId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/semester/$semesterId'),
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
  // 8. جلب المواد حسب السنة والفصل (Get By Year And Semester)
  // ==========================================
  Future<Map<String, dynamic>> getSubjectsByYearAndSemester(
    String token,
    String yearId,
    String semesterId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/year/$yearId/semester/$semesterId'),
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
