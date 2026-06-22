import 'package:bluebits_app/core/shares/lessonslacture/data/models/lesson_lecture_models.dart';
import 'package:bluebits_app/core/shares/lessonslacture/data/repositry/lesson_lecture_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';

part 'lesson_lecture_state.dart';

class LessonLectureCubit extends Cubit<LessonLectureState> {
  final LessonLectureRepository repository; // تم تصحيح الاسم هنا أيضاً

  LessonLectureCubit({required this.repository})
    : super(LessonLectureInitial());

  // 1. جلب كل المحاضرات
  Future<void> fetchAllLectures() async {
    emit(LessonLectureLoading());
    try {
      print('-----------------------------------');
      final token = await CachHelper.getValue('Token');
      final lectureModel = await repository.getAllLectures(token);
      print(lectureModel);
      print('-------------------------------------------');

      if (lectureModel.isSuccess == true) {
        // تم الإصلاح: يجب الوصول إلى قائمة lectures بداخل data
        emit(LessonLecturesLoaded(lectureModel.data?.lectures ?? []));
      } else {
        emit(
          LessonLectureError(lectureModel.message ?? 'فشل في جلب المحاضرات'),
        );
      }
    } catch (e) {
      emit(LessonLectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 2. رفع محاضرة
  Future<void> uploadLecture(
    String token,
    String title,
    String description,
    String subjectId,
    String type,
    bool isPublished,
    String filePath,
  ) async {
    emit(LessonLectureLoading());
    try {
      final lectureModel = await repository.uploadLecture(
        token,
        title,
        description,
        subjectId,
        type,
        isPublished,
        filePath,
      );

      if (lectureModel.isSuccess == true) {
        emit(
          LessonLectureActionSuccess(
            lectureModel.message ?? 'تم رفع المحاضرة بنجاح',
          ),
        );
        fetchAllLectures();
      } else {
        emit(LessonLectureError(lectureModel.message ?? 'فشل في رفع المحاضرة'));
      }
    } catch (e) {
      emit(LessonLectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 3. جلب محاضرة واحدة
  Future<void> fetchLectureById(String lectureId) async {
    emit(LessonLectureLoading());
    try {
      final lectureModel = await repository.getLectureById(lectureId);

      if (lectureModel.isSuccess == true) {
        // تم الإصلاح: التحقق من وجود القائمة داخل data
        if (lectureModel.data?.lectures != null &&
            lectureModel.data!.lectures!.isNotEmpty) {
          emit(LessonLectureDetailLoaded(lectureModel.data!.lectures!.first));
        } else {
          emit(LessonLectureError('بيانات المحاضرة غير صالحة'));
        }
      } else {
        emit(
          LessonLectureError(
            lectureModel.message ?? 'فشل في جلب تفاصيل المحاضرة',
          ),
        );
      }
    } catch (e) {
      emit(LessonLectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 4. تحديث محاضرة
  Future<void> updateLecture(
    String token,
    String lectureId,
    String? title,
    String? description,
    String? filePath,
  ) async {
    emit(LessonLectureLoading()); // تم الإصلاح
    try {
      final lectureModel = await repository.updateLecture(
        token,
        lectureId,
        title,
        description,
        filePath,
      );

      if (lectureModel.isSuccess == true) {
        emit(
          LessonLectureActionSuccess(
            lectureModel.message ?? 'تم تحديث المحاضرة بنجاح',
          ),
        ); // تم الإصلاح
        fetchAllLectures();
      } else {
        emit(
          LessonLectureError(lectureModel.message ?? 'فشل في تحديث المحاضرة'),
        ); // تم الإصلاح
      }
    } catch (e) {
      emit(
        LessonLectureError('حدث خطأ في الاتصال: ${e.toString()}'),
      ); // تم الإصلاح
    }
  }

  // 5. حذف محاضرة
  Future<void> deleteLecture(String token, String lectureId) async {
    emit(LessonLectureLoading()); // تم الإصلاح
    try {
      final lectureModel = await repository.deleteLecture(token, lectureId);

      if (lectureModel.isSuccess == true) {
        emit(
          LessonLectureActionSuccess(
            lectureModel.message ?? 'تم حذف المحاضرة بنجاح',
          ),
        ); // تم الإصلاح
        fetchAllLectures();
      } else {
        emit(
          LessonLectureError(lectureModel.message ?? 'فشل في حذف المحاضرة'),
        ); // تم الإصلاح
      }
    } catch (e) {
      emit(
        LessonLectureError('حدث خطأ في الاتصال: ${e.toString()}'),
      ); // تم الإصلاح
    }
  }

  // 6. الفلترة حسب النوع ومادة معينة
  Future<void> fetchLecturesByType(
    String token,
    String subjectId,
    String type,
  ) async {
    emit(LessonLectureLoading()); // تم الإصلاح
    try {
      final lectureModel = await repository.getLecturesByType(
        token,
        subjectId,
        type,
      );

      if (lectureModel.isSuccess == true) {
        // تم الإصلاح: الوصول إلى قائمة lectures
        emit(LessonLecturesLoaded(lectureModel.data?.lectures ?? []));
      } else {
        emit(
          LessonLectureError(lectureModel.message ?? 'فشل في فلترة المحاضرات'),
        ); // تم الإصلاح
      }
    } catch (e) {
      emit(
        LessonLectureError('حدث خطأ في الاتصال: ${e.toString()}'),
      ); // تم الإصلاح
    }
  }

  // 7. الفلترة المتقدمة
  Future<void> fetchLecturesByYearSemesterSubjectType(
    String token,
    String yearId,
    String semesterId,
    String subjectId,
    String type,
  ) async {
    emit(LessonLectureLoading()); // تم الإصلاح
    try {
      final lectureModel = await repository
          .getLecturesByYearSemesterSubjectType(
            token,
            yearId,
            semesterId,
            subjectId,
            type,
          );

      if (lectureModel.isSuccess == true) {
        // تم الإصلاح: الوصول إلى قائمة lectures
        emit(LessonLecturesLoaded(lectureModel.data?.lectures ?? []));
      } else {
        emit(
          LessonLectureError(lectureModel.message ?? 'فشل في الفلترة المتقدمة'),
        ); // تم الإصلاح
      }
    } catch (e) {
      emit(
        LessonLectureError('حدث خطأ في الاتصال: ${e.toString()}'),
      ); // تم الإصلاح
    }
  }
}
