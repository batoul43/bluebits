import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/subjects/data/models/subjects_by_year_semester.dart';
import 'package:bluebits_app/core/shares/subjects/data/models/subjects_models.dart';
import 'package:bluebits_app/core/shares/subjects/data/repositry/subjects_repositry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'subject_state.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final SubjectRepository repository;

  SubjectCubit(this.repository) : super(SubjectInitial());

  // ==========================================
  // 1. إنشاء مادة جديدة (Create)
  // ==========================================
  Future<void> createSubject({
    required String name,
    required String description,
    required String createdBy,
    required String yearId,
    required String semesterId,
  }) async {
    emit(SubjectActionLoading());
    try {
      final String token = await CachHelper.getValue('Token') ?? "";
      print('=== DEBUG: Token being sent to Server is: "$token" ===');
      final response = await repository.createSubject(
        token: token,
        name: name,
        description: description,
        createdBy: createdBy,
        yearId: yearId,
        semesterId: semesterId,
      );
      // getAllSubjects();
      if (response.isSuccess == true) {
        emit(SubjectActionSuccess(response, 'تم إنشاء المادة بنجاح'));
      } else {
        emit(SubjectActionFailure(response.message ?? 'فشل في إنشاء المادة'));
      }
    } catch (e) {
      emit(SubjectActionFailure(e.toString()));
    }
  }

  // ==========================================
  // 2. جلب جميع المواد (Get All)
  // ==========================================
  Future<void> getAllSubjects() async {
    emit(GetSubjectsLoading());
    try {
      final String token = await CachHelper.getValue('Token') ?? "";
      print('=== DEBUG: Token being sent to Server is: "$token" ===');
      final response = await repository.getAllSubjects(token);

      if (response.isSuccess == true) {
        emit(GetSubjectsSuccess(response));
      } else {
        emit(GetSubjectsFailure(response.message ?? 'فشل في جلب المواد'));
      }
    } catch (e) {
      emit(GetSubjectsFailure(e.toString()));
    }
  }

  // ==========================================
  // 3. جلب مادة محددة (Get One)
  // ==========================================
  Future<void> getSubjectById(String subjectId) async {
    emit(GetSubjectsLoading());
    try {
      final String token = await CachHelper.getValue('Token') ?? "";
      print('=== DEBUG: Token being sent to Server is: "$token" ===');
      final response = await repository.getSubjectById(token, subjectId);

      if (response.isSuccess == true) {
        emit(GetSubjectsSuccess(response));
      } else {
        emit(
          GetSubjectsFailure(response.message ?? 'فشل في جلب المادة المحددة'),
        );
      }
    } catch (e) {
      emit(GetSubjectsFailure(e.toString()));
    }
  }

  // ==========================================
  // 4. تحديث مادة (Update)
  // ==========================================
  Future<void> updateSubject({
    required String subjectId,
    String? name,
    String? description,
  }) async {
    emit(SubjectActionLoading());
    try {
      final String token = await CachHelper.getValue('Token') ?? "";
      print('=== DEBUG: Token being sent to Server is: "$token" ===');
      final response = await repository.updateSubject(
        token: token,
        subjectId: subjectId,
        name: name,
        description: description,
      );

      if (response.isSuccess == true) {
        emit(SubjectActionSuccess(response, 'تم تحديث بيانات المادة بنجاح'));
      } else {
        emit(SubjectActionFailure(response.message ?? 'فشل في تحديث المادة'));
      }
    } catch (e) {
      emit(SubjectActionFailure(e.toString()));
    }
  }

  // ==========================================
  // 5. حذف مادة (Delete)
  // ==========================================
  Future<void> deleteSubject(String subjectId) async {
    emit(SubjectActionLoading());
    try {
      final String token = await CachHelper.getValue('Token') ?? "";
      print('=== DEBUG: Token being sent to Server is: "$token" ===');
      final response = await repository.deleteSubject(token, subjectId);

      if (response.isSuccess == true) {
        emit(SubjectActionSuccess(response, 'تم حذف المادة بنجاح'));
      } else {
        emit(SubjectActionFailure(response.message ?? 'فشل في حذف المادة'));
      }
    } catch (e) {
      emit(SubjectActionFailure(e.toString()));
    }
  }

  // ==========================================
  // 6. جلب المواد حسب السنة (Get By Year)
  // ==========================================
  Future<void> getSubjectsByYear(String yearId) async {
    emit(GetSubjectsLoading());
    try {
      final String token = await CachHelper.getValue('Token') ?? "";
      print('=== DEBUG: Token being sent to Server is: "$token" ===');
      final response = await repository.getSubjectsByYear(token, yearId);

      if (response.isSuccess == true) {
        emit(GetSubjectsByYearAnsSemester(response));
      } else {
        emit(GetSubjectsFailure(response.message ?? 'فشل في جلب مواد السنة'));
      }
    } catch (e) {
      emit(GetSubjectsFailure(e.toString()));
    }
  }

  // ==========================================
  // 7. جلب المواد حسب الفصل (Get By Semester)
  // ==========================================
  Future<void> getSubjectsBySemester(String semesterId) async {
    emit(GetSubjectsLoading());
    try {
      final String token = await CachHelper.getValue('Token') ?? "";
      print('=== DEBUG: Token being sent to Server is: "$token" ===');
      final response = await repository.getSubjectsBySemester(
        token,
        semesterId,
      );

      if (response.isSuccess == true) {
        emit(GetSubjectsSuccess(response));
      } else {
        emit(GetSubjectsFailure(response.message ?? 'فشل في جلب مواد الفصل'));
      }
    } catch (e) {
      emit(GetSubjectsFailure(e.toString()));
    }
  }

  // ==========================================
  // 8. جلب المواد حسب السنة والفصل معاً
  // ==========================================
  Future<void> getSubjectsByYearAndSemester({
    required String yearId,
    required String semesterId,
  }) async {
    emit(GetSubjectsLoading());
    try {
      final String token = await CachHelper.getValue('Token') ?? "";
      print('=== DEBUG: Token being sent to Server is: "$token" ===');
      final response = await repository.getSubjectsByYearAndSemester(
        token: token,
        yearId: yearId,
        semesterId: semesterId,
      );

      if (response.isSuccess == true) {
        emit(GetSubjectsByYearAnsSemester(response));
      } else {
        emit(
          GetSubjectsFailure(response.message ?? 'فشل في جلب المواد المطلوبة'),
        );
      }
    } catch (e) {
      emit(GetSubjectsFailure(e.toString()));
    }
  }
}
