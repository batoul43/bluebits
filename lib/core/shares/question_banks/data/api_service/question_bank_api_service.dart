import 'dart:convert';
import 'package:http/http.dart' as http;

class QuestionBankApiService {
  final String baseUrl =
      "https://bluebits24.onrender.com/api/v1.0.0/question-banks";

  Future<Map<String, dynamic>> bulkUploadQuestions({
    required String token,
    required String lectureId,
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bulk-upload'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'lectureId': lectureId, 'questions': questions}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء رفع الأسئلة: $e');
    }
  }

  Future<Map<String, dynamic>> uploadDocxBank({
    required String token,
    required String lectureId,
    required String filePath,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/upload-docx');
      final request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['lectureId'] = lectureId;
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء رفع ملف Word: $e');
    }
  }

  Future<Map<String, dynamic>> updateQuestion({
    required String token,
    required String questionId,
    String? questionText,
    String? explanation,
    List<Map<String, dynamic>>? options,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (questionText != null) body['questionText'] = questionText;
      if (explanation != null) body['explanation'] = explanation;
      if (options != null) body['options'] = options;

      final response = await http.patch(
        Uri.parse('$baseUrl/questions/$questionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء تعديل السؤال: $e');
    }
  }

  Future<Map<String, dynamic>> deleteQuestion({
    required String token,
    required String questionId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/questions/$questionId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء حذف السؤال: $e');
    }
  }

  Future<Map<String, dynamic>> publishQuestionBank({
    required String token,
    required String bankId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$bankId/publish'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء نشر البنك: $e');
    }
  }

  Future<Map<String, dynamic>> unpublishQuestionBank({
    required String token,
    required String bankId,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$bankId/unpublish'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء إلغاء نشر البنك: $e');
    }
  }

  Future<Map<String, dynamic>> getQuestionBankById({
    required String token,
    required String bankId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$bankId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب بيانات البنك: $e');
    }
  }

  Future<Map<String, dynamic>> getBanksSortedByYear({
    required String token,
    String? subjectId,
  }) async {
    try {
      final Uri uri = Uri.parse('$baseUrl/sorted-by-year').replace(
        queryParameters: subjectId != null ? {'subjectId': subjectId} : null,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب البنوك المرتبة: $e');
    }
  }

  Future<Map<String, dynamic>> getQuestionBankByLectureId({
    required String token,
    required String lectureId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lecture/$lectureId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب بنك المحاضرة: $e');
    }
  }

  Future<Map<String, dynamic>> getQuestionBanksByYearId({
    required String token,
    required String yearId,
  }) async {
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
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب بنوك السنة: $e');
    }
  }

  Future<Map<String, dynamic>> getQuestionBanksBySubjectId({
    required String token,
    required String subjectId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subject/$subjectId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب بنوك المادة: $e');
    }
  }

  // ==========================================
  // الـ APIs الجديدة المتعلقة بالنتائج والمحاولات
  // ==========================================

  /// جلب نتائج بنك أسئلة معين
  Future<Map<String, dynamic>> getQuestionBankResults({
    required String token,
    required String bankId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$bankId/results'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب النتائج: $e');
    }
  }

  /// إرسال الإجابات الخاصة ببنك الأسئلة لتصحيحها
  Future<Map<String, dynamic>> submitQuestionBankAnswers({
    required String token,
    required String bankId,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$bankId/submit'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'answers': answers}),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء إرسال الإجابات: $e');
    }
  }

  /// جلب المحاولات السابقة للمستخدم الحالي في بنك معين
  Future<Map<String, dynamic>> getMyAttempts({
    required String token,
    required String bankId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$bankId/my-attempts'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء جلب محاولاتك السابقة: $e');
    }
  }
}
