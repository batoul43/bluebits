import 'dart:convert';
import 'package:http/http.dart' as http;

class AnnouncementApiService {
  final String baseUrl =
      "https://bluebits24.onrender.com/api/v1.0.0/announcements";

  // 1. إنشاء إعلان جديد
  Future<Map<String, dynamic>> createAnnouncement(
    String token,
    String title,
    String content,
    String yearId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'title': title,
          'content': content,
          'yearId': yearId,
        }),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء الإضافة: $e');
    }
  }

  // 2. جلب جميع الإعلانات
  Future<Map<String, dynamic>> getAllAnnouncements(String token) async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
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

  // 3. جلب الإعلانات الخاصة بي (My Announcements)
  Future<Map<String, dynamic>> getMyAnnouncements(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/my'),
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

  // 4. جلب إعلان محدد بواسطة الـ ID
  Future<Map<String, dynamic>> getAnnouncementById(
    String token,
    String announcementId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$announcementId'),
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

  // 5. تعديل الإعلان (استخدام PATCH وتمرير الحقول المطلوبة فقط)
  Future<Map<String, dynamic>> updateAnnouncement(
    String token,
    String announcementId, {
    String? title,
    String? content,
    String? yearId,
  }) async {
    try {
      // تجهيز البيانات التي سيتم تعديلها فقط
      final Map<String, dynamic> body = {};
      if (title != null) body['title'] = title;
      if (content != null) body['content'] = content;
      if (yearId != null) body['yearId'] = yearId;

      final response = await http.patch(
        Uri.parse('$baseUrl/$announcementId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء التعديل: $e');
    }
  }

  // 6. حذف الإعلان
  Future<Map<String, dynamic>> deleteAnnouncement(
    String token,
    String announcementId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$announcementId'),
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
}
