import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentSurveyApiService {
  final String baseUrl = "https://bluebits24.onrender.com/api/v1.0.0/surveys";

  // دالة مساعدة لمعالجة الردود وتجنب تكرار الكود والأخطاء
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 429) {
      throw Exception(
        'لقد تجاوزت الحد المسموح من الطلبات. يرجى المحاولة لاحقاً.',
      );
    } else {
      try {
        final errorBody = jsonDecode(response.body);
        throw Exception(
          errorBody['message'] ?? 'حدث خطأ في الخادم: ${response.statusCode}',
        );
      } catch (_) {
        final errorBody = jsonDecode(response.body);
        throw Exception(
          errorBody['message'] ?? 'حدث خطأ في الخادم: ${response.statusCode}',
        );
      }
    }
  }

  Future<Map<String, dynamic>> getActiveForms(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forms/active'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, dynamic>> submitFormResponse(
    String token,
    Map<String, dynamic> responseData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/responses'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(responseData),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء إرسال التقييم: $e');
    }
  }

  Future<Map<String, dynamic>> getMyResponseForForm(
    String token,
    String formId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/responses/my/$formId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception(
        'خطأ في الاتصال بالخادم أثناء جلب تفاصيل ردك على الاستبيان: $e',
      );
    }
  }

  Future<Map<String, dynamic>> getMyResponses(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/responses/my'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب ردودك السابقة: $e');
    }
  }

  Future<Map<String, dynamic>> getSubjectsStatsByYearAndForm(
    String token,
    String yearId,
    String formId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/stats/year/$yearId/?formId=$formId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception(
        'خطأ في الاتصال بالخادم أثناء جلب الإحصائيات: ${e.toString().replaceAll('Exception: ', '')}',
      );
    }
  }
}
