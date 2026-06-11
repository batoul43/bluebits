import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProfileApi {
  final String baseUrl = 'https://bluebits24.onrender.com/api/v1.0.0/users/';

  // 1. إحضار بيانات حسابي
  Future<dynamic> getProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}me'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('ProfileApi.getProfile: ${response.statusCode}');

      // نُرجع الرد مفكوك التشفير دائماً لأن الباك-إند يرسل رسالة الخطأ داخل الـ JSON
      return jsonDecode(response.body);
    } catch (e) {
      print('ProfileApi.getProfile error: $e');
      // في حال انقطاع الإنترنت أو انهيار التطبيق
      return {'isSuccess': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }

  // 2. إحضار بيانات مستخدم محدد
  Future<dynamic> getUser(String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$id'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('ProfileApi.getUser: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('ProfileApi.getUser error: $e');
      return {'isSuccess': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }

  // 3. تحديث بياناتي
  Future<dynamic> updateMe(Map<String, dynamic> data, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('${baseUrl}updateMe'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      print('ProfileApi.updateMe: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('ProfileApi.updateMe error: $e');
      return {'isSuccess': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }

  // 4. تحديث بياناتي مع رفع صورة
  Future<dynamic> updateMeAndUpload(File imageFile, String token) async {
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${baseUrl}updateMeAndUpload'),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        await http.MultipartFile.fromPath('profile_image', imageFile.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('ProfileApi.updateMeAndUpload: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('ProfileApi.updateMeAndUpload error: $e');
      return {'isSuccess': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }

  // 5. تفعيل / إلغاء تفعيل حسابي
  Future<dynamic> activeMe(bool isActive, String token) async {
    try {
      final response = await http.patch(
        Uri.parse('${baseUrl}activeMe'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'active': isActive.toString()}),
      );
      print('ProfileApi.activeMe: ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('ProfileApi.activeMe error: $e');
      return {'isSuccess': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }

  // 6. حذف حسابي نهائياً
  Future<dynamic> deleteMe(String token) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}deleteMe'),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('ProfileApi.deleteMe: ${response.statusCode}');
      print(response.body);
      // طلبات الحذف أحياناً تعود برمز 204 (بدون محتوى)، لذا يجب التأكد من أن الرد غير فارغ
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      } else {
        bool success = response.statusCode >= 200 && response.statusCode < 300;
        return {
          'isSuccess': success,
          'message': success ? 'تم الحذف بنجاح' : 'حدث خطأ أثناء الحذف',
        };
      }
    } catch (e) {
      print('ProfileApi.deleteMe error: $e');
      return {'isSuccess': false, 'message': 'حدث خطأ في الاتصال: $e'};
    }
  }
}
