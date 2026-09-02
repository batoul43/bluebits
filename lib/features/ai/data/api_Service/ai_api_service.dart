import 'dart:convert';
import 'package:http/http.dart' as http;

class AiApiService {
  // تم توحيد الرابط الأساسي بناءً على الروابط المرفقة
  final String baseUrl = "https://bluebits24.onrender.com/api/v1.0.0/ai";

  /// إرسال سؤال جديد أو إكمال محادثة سابقة (في حال تمرير conversationId)
  Future<Map<String, dynamic>> askQuestion(
    String token,
    String question, {
    String? conversationId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/ask');

      // تجهيز جسم الطلب
      final Map<String, dynamic> body = {"question": question};

      // إضافة معرف المحادثة إذا كان الطلب استكمالاً لمحادثة سابقة
      if (conversationId != null) {
        body["conversationId"] = conversationId;
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء إرسال السؤال: $e');
    }
  }

  /// جلب جميع المحادثات
  Future<Map<String, dynamic>> getAllConversations(String token) async {
    try {
      final url = Uri.parse('$baseUrl/conversations');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب المحادثات: $e');
    }
  }

  /// جلب تفاصيل محادثة محددة عبر الـ ID
  Future<Map<String, dynamic>> getConversationById(
    String token,
    String conversationId,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/conversations/$conversationId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب تفاصيل المحادثة: $e');
    }
  }

  /// حذف محادثة محددة
  Future<Map<String, dynamic>> deleteConversation(
    String token,
    String conversationId,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/conversations/$conversationId');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء حذف المحادثة: $e');
    }
  }
}
