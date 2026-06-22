import 'package:bluebits_app/core/shares/lessonslacture/data/api_service/lesson_lecture_api_service.dart';
import 'package:bluebits_app/core/shares/lessonslacture/data/models/lesson_lecture_models.dart';
import 'package:http/http.dart' as http;

class LessonLectureRepositry {
  final LessonLectureApiService apiService;

  LessonLectureRepositry(this.apiService);

  Future<LessonLectureModels> getAllLectures(String token) async {
    final response = await apiService.getAllLectures(token);
    print('-------------------------------------------');
    print('repoLecture - GetAll: $response');
    print('-------------------------------------------');
    return LessonLectureModels.fromJson(response);
  }

  Future<LessonLectureModels> uploadLecture(
    String token,
    String title,
    String description,
    String subjectId,
    String type,
    bool isPublished,
    String filePath,
  ) async {
    final response = await apiService.uploadLecture(
      token,
      title,
      description,
      subjectId,
      type,
      isPublished,
      filePath,
    );
    return LessonLectureModels.fromJson(response);
  }

  Future<LessonLectureModels> getLectureById(String lectureId) async {
    final response = await apiService.getLectureById(lectureId);
    return LessonLectureModels.fromJson(response);
  }

  Future<LessonLectureModels> updateLecture(
    String token,
    String lectureId,
    String? title,
    String? description,
    String? filePath,
  ) async {
    final response = await apiService.updateLecture(
      token,
      lectureId,
      title,
      description,
      filePath,
    );
    return LessonLectureModels.fromJson(response);
  }

  Future<LessonLectureModels> deleteLecture(
    String token,
    String lectureId,
  ) async {
    final response = await apiService.deleteLecture(token, lectureId);
    return LessonLectureModels.fromJson(response);
  }

  Future<http.Response> downloadLectureFile(
    String token,
    String lectureId,
  ) async {
    return await apiService.downloadLectureFile(token, lectureId);
  }

  Future<LessonLectureModels> getLecturesByType(
    String token,
    String subjectId,
    String type,
  ) async {
    final response = await apiService.getLecturesByType(token, subjectId, type);
    return LessonLectureModels.fromJson(response);
  }

  Future<LessonLectureModels> getLecturesByYearSemesterSubjectType(
    String token,
    String yearId,
    String semesterId,
    String subjectId,
    String type,
  ) async {
    final response = await apiService.getLecturesByYearSemesterSubjectType(
      token,
      yearId,
      semesterId,
      subjectId,
      type,
    );
    return LessonLectureModels.fromJson(response);
  }
}
