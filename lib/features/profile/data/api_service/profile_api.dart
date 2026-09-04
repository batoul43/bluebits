import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

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
      if (!await imageFile.exists()) {
        return {'isSuccess': false, 'message': 'ملف الصورة غير موجود'};
      }

      final fileLength = await imageFile.length();
      if (fileLength == 0) {
        return {'isSuccess': false, 'message': 'ملف الصورة فارغ'};
      }

      final extension = imageFile.path.split('.').last.toLowerCase();
      final mimeType = switch (extension) {
        'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
        'png' => MediaType('image', 'png'),
        'webp' => MediaType('image', 'webp'),
        'gif' => MediaType('image', 'gif'),
        _ => null,
      };

      if (mimeType == null) {
        return {
          'isSuccess': false,
          'message': 'صيغة الصورة غير مدعومة. استخدم JPG أو PNG أو WEBP',
        };
      }

      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('${baseUrl}updateMeAndUpload'),
      );

      request.headers.addAll({'Authorization': 'Bearer $token'});

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          imageFile.path,
          contentType: mimeType,
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('ProfileApi.updateMeAndUpload: ${response.statusCode}');
      print('ProfileApi.updateMeAndUpload body: ${response.body}');

      if (response.body.trim().isEmpty) {
        return {
          'isSuccess': response.statusCode >= 200 && response.statusCode < 300,
          'statusCode': response.statusCode,
          'message': response.statusCode >= 200 && response.statusCode < 300
              ? 'تم رفع الصورة'
              : 'فشل رفع الصورة (${response.statusCode})',
        };
      }

      try {
        return jsonDecode(response.body);
      } on FormatException {
        return {
          'isSuccess': false,
          'statusCode': response.statusCode,
          'message': 'رد غير مفهوم من الخادم (${response.statusCode})',
        };
      }
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
