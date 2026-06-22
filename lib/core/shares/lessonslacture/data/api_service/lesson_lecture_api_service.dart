import 'dart:convert';
import 'package:http/http.dart' as http;

class LessonLectureApiService {
  final String baseUrl = "https://bluebits24.onrender.com/api/v1.0.0/lectures";

  Future<Map<String, dynamic>> uploadLecture(
    String token,
    String title,
    String description,
    String subjectId,
    String type,
    bool isPublished,
    String filePath,
  ) async {
    try {
      final url = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', url);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['subjectId'] = subjectId;
      request.fields['type'] = type;
      request.fields['isPublished'] = isPublished.toString();

      request.files.add(await http.MultipartFile.fromPath('lecture', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء الرفع: $e');
    }
  }

  Future<Map<String, dynamic>> getAllLectures(String token) async {
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

  Future<Map<String, dynamic>> getLectureById(String lectureId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$lectureId'),
        headers: {'Accept': 'application/json'},
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم: $e');
    }
  }

  Future<Map<String, dynamic>> updateLecture(
    String token,
    String lectureId,
    String? title,
    String? description,
    String? filePath,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/$lectureId');
      final request = http.MultipartRequest('PATCH', url);

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      if (title != null) request.fields['title'] = title;
      if (description != null) request.fields['description'] = description;
      if (filePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('lecture', filePath),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('خطأ في الاتصال بالخادم أثناء التعديل: $e');
    }
  }

  Future<Map<String, dynamic>> deleteLecture(
    String token,
    String lectureId,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$lectureId'),
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

  Future<http.Response> downloadLectureFile(
    String token,
    String lectureId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$lectureId/download'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return response;
    } catch (e) {
      throw Exception('خطأ في التحميل: $e');
    }
  }

  Future<Map<String, dynamic>> getLecturesByType(
    String token,
    String subjectId,
    String type,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subject/$subjectId/type/$type'),
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

  Future<Map<String, dynamic>> getLecturesByYearSemesterSubjectType(
    String token,
    String yearId,
    String semesterId,
    String subjectId,
    String type,
  ) async {
    try {
      final url =
          '$baseUrl/year/$yearId/semester/$semesterId/subject/$subjectId/type/$type';
      final response = await http.get(
        Uri.parse(url),
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
