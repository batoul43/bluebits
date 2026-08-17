import 'dart:convert';
import 'package:http/http.dart' as http;

class ScheduleSettingApiService {
  final String baseUrl = "https://bluebits24.onrender.com/api/v1.0.0/schedule";

  /// 1. إنشاء إعدادات جدول جديد (Create Schedule Config)
  Future<Map<String, dynamic>> createScheduleConfig(
    String token,
    Map<String, dynamic> configData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/config'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(configData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء إنشاء إعدادات الجدول: $e');
    }
  }

  /// 2. حل الجدول الزمني (Solve Schedule)
  Future<Map<String, dynamic>> solveSchedule(
    String token,
    String semesterId,
    String academicYear,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/solve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'semesterId': semesterId,
          'academicYear': academicYear,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء معالجة حل الجدول: $e');
    }
  }

  /// 3. جلب إعدادات الجدول حسب الفصل الدراسي (Get Setting Per Semester)
  Future<Map<String, dynamic>> getSettingPerSemester(
    String token,
    String semesterId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/config/$semesterId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب إعدادات الفصل: $e');
    }
  }

  /// 4. تحديث إعدادات الجدول (Update Schedule Config)
  Future<Map<String, dynamic>> updateScheduleConfig(
    String token,
    String id,
    Map<String, dynamic> configData,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/config/manage/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(configData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء تعديل إعدادات الجدول: $e');
    }
  }

  /// 5. حذف إعدادات الجدول (Delete Schedule Config)
  Future<Map<String, dynamic>> deleteScheduleConfig(
    String token,
    String id,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/config/manage/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء حذف الإعدادات: $e');
    }
  }

  /// 6. توليد بيانات الجدول (Generate Schedule Data)
  Future<Map<String, dynamic>> generateScheduleData(
    String token,
    String semesterId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/generate-data/$semesterId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء توليد بيانات الجدول: $e');
    }
  }

  /// 7. حل الجدول بواسطة Timefold (Solver Timefold)
  Future<Map<String, dynamic>> solveTimefold(
    String token,
    Map<String, dynamic> timefoldData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://exam-solver24.onrender.com/api/solve'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(timefoldData),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء التشغيل عبر Timefold: $e');
    }
  }

  /// 8. جلب نتيجة الجدول (Get Schedule Result)
  Future<Map<String, dynamic>> getScheduleResult(
    String token,
    String semesterId,
  ) async {
    try {
      final response = await http.get(
        // يرجى التأكد من مطابقة هذا الرابط مع مسار الباك إند الفعلي
        Uri.parse('$baseUrl/result/$semesterId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب نتيجة الجدول: $e');
    }
  }

  /// 9. نشر الجدول (Publish Schedule)
  Future<Map<String, dynamic>> publishSchedule(
    String token,
    String semesterId,
  ) async {
    try {
      final response = await http.patch(
        // يرجى التأكد من مطابقة هذا الرابط مع مسار الباك إند الفعلي
        Uri.parse('$baseUrl/result/$semesterId/publish'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء نشر الجدول: $e');
    }
  }
}
