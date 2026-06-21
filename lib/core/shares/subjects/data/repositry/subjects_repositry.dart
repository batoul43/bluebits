import 'package:bluebits_app/core/shares/subjects/data/api_Service/subject_api_service.dart';
import 'package:bluebits_app/core/shares/subjects/data/models/subjects_by_year_semester.dart';
import 'package:bluebits_app/core/shares/subjects/data/models/subjects_models.dart';

class SubjectRepository {
  final SubjectApiService apiService;

  SubjectRepository(this.apiService);

  // ==========================================
  // 1. إنشاء مادة جديدة (Create)
  // ==========================================
  Future<SubjectModel> createSubject({
    required String token,
    required String name,
    required String description,
    required String createdBy,
    required String yearId,
    required String semesterId,
  }) async {
    final response = await apiService.createSubject(
      token,
      name,
      description,
      createdBy,
      yearId,
      semesterId,
    );
    print('-------------------------------------------');
    print('repo createSubject: $response');
    print('-------------------------------------------');
    return SubjectModel.fromJson(response);
  }

  // ==========================================
  // 2. جلب جميع المواد (Get All)
  // ==========================================
  Future<SubjectModel> getAllSubjects(String token) async {
    final response = await apiService.getAllSubjects(token);
    print('-------------------------------------------');
    print('repo getAllSubjects: $response');
    print('-------------------------------------------');
    return SubjectModel.fromJson(response);
  }

  // ==========================================
  // 3. جلب مادة محددة (Get One)
  // ==========================================
  Future<SubjectModel> getSubjectById(String token, String subjectId) async {
    final response = await apiService.getSubjectById(token, subjectId);
    print('-------------------------------------------');
    print('repo getSubjectById: $response');
    print('-------------------------------------------');
    return SubjectModel.fromJson(response);
  }

  // ==========================================
  // 4. تحديث مادة (Update)
  // ==========================================
  Future<SubjectModel> updateSubject({
    required String token,
    required String subjectId,
    String? name,
    String? description,
  }) async {
    final response = await apiService.updateSubject(
      token,
      subjectId,
      name: name,
      description: description,
    );
    print('-------------------------------------------');
    print('repo updateSubject: $response');
    print('-------------------------------------------');
    return SubjectModel.fromJson(response);
  }

  // ==========================================
  // 5. حذف مادة (Delete)
  // ==========================================
  Future<SubjectModel> deleteSubject(String token, String subjectId) async {
    final response = await apiService.deleteSubject(token, subjectId);
    print('-------------------------------------------');
    print('repo deleteSubject: $response');
    print('-------------------------------------------');
    return SubjectModel.fromJson(response);
  }

  // ==========================================
  // 6. جلب المواد حسب السنة (Get By Year)
  // ==========================================
  Future<SubjectModel> getSubjectsByYear(String token, String yearId) async {
    final response = await apiService.getSubjectsByYear(token, yearId);
    print('-------------------------------------------');
    print('repo getSubjectsByYear: $response');
    print('-------------------------------------------');
    return SubjectModel.fromJson(response);
  }

  // ==========================================
  // 7. جلب المواد حسب الفصل (Get By Semester)
  // ==========================================
  Future<SubjectModel> getSubjectsBySemester(
    String token,
    String semesterId,
  ) async {
    final response = await apiService.getSubjectsBySemester(token, semesterId);
    print('-------------------------------------------');
    print('repo getSubjectsBySemester: $response');
    print('-------------------------------------------');
    return SubjectModel.fromJson(response);
  }

  // ==========================================
  // 8. جلب المواد حسب السنة والفصل (Get By Year And Semester)
  // ==========================================
  Future<SubjectsByYearSemester> getSubjectsByYearAndSemester({
    required String token,
    required String yearId,
    required String semesterId,
  }) async {
    final response = await apiService.getSubjectsByYearAndSemester(
      token,
      yearId,
      semesterId,
    );
    print('-------------------------------------------');
    print('repo getSubjectsByYearAndSemester: $response');
    print('-------------------------------------------');
    return SubjectsByYearSemester.fromJson(response);
  }
}
