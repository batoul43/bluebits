import 'package:bluebits_app/core/shares/lessonslacture/data/models/lesson_lecture_models.dart';
import 'package:bluebits_app/core/shares/lessonslacture/data/repositry/lesson_lecture_repositry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart'; // مسار الـ CacheHelper الخاص بكِ

part 'lesson_lecture_state.dart';

class LessonLectureCubit extends Cubit<LessonLectureState> {
  final LessonLectureRepositry repository;

  LessonLectureCubit({required this.repository})
    : super(LessonLectureInitial());

  // 1. جلب كل المحاضرات (يجلب التوكن داخلياً من الـ Cache)
  Future<void> fetchAllLectures() async {
    emit(LessonLectureLoading());
    try {
      print('-----------------------------------');
      final token = await CachHelper.getValue('Token');
      final lectureModel = await repository.getAllLectures(token);
      print(lectureModel);
      print('-------------------------------------------');

      if (lectureModel.isSuccess == true) {
        emit(LessonLecturesLoaded(lectureModel.data ?? []));
      } else {
        emit(
          LessonLectureError(lectureModel.message ?? 'فشل في جلب المحاضرات'),
        );
      }
    } catch (e) {
      emit(LessonLectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 2. رفع محاضرة (يستقبل الـ token كمعامل ترتيب مثل createYear)
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
        fetchAllLectures(); // تحديث تلقائي للقائمة
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
        if (lectureModel.data != null &&
            lectureModel.data is List &&
            (lectureModel.data as List).isNotEmpty) {
          emit(LectureDetailLoaded((lectureModel.data as List).first));
        } else if (lectureModel.data is Data) {
          emit(LectureDetailLoaded(lectureModel.data as Data));
        } else {
          emit(LectureError('بيانات المحاضرة غير صالحة'));
        }
      } else {
        emit(
          LectureError(lectureModel.message ?? 'فشل في جلب تفاصيل المحاضرة'),
        );
      }
    } catch (e) {
      emit(LectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 4. تحديث محاضرة (يستقبل الـ token كمعامل ترتيب مثل updateYear)
  Future<void> updateLecture(
    String token,
    String lectureId,
    String? title,
    String? description,
    String? filePath,
  ) async {
    emit(LectureLoading());
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
          LectureActionSuccess(
            lectureModel.message ?? 'تم تحديث المحاضرة بنجاح',
          ),
        );
        fetchAllLectures();
      } else {
        emit(LectureError(lectureModel.message ?? 'فشل في تحديث المحاضرة'));
      }
    } catch (e) {
      emit(LectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 5. حذف محاضرة (يستقبل الـ token كمعامل ترتيب مثل deleteYear)
  Future<void> deleteLecture(String token, String lectureId) async {
    emit(LectureLoading());
    try {
      final lectureModel = await repository.deleteLecture(token, lectureId);

      if (lectureModel.isSuccess == true) {
        emit(
          LectureActionSuccess(lectureModel.message ?? 'تم حذف المحاضرة بنجاح'),
        );
        fetchAllLectures();
      } else {
        emit(LectureError(lectureModel.message ?? 'فشل في حذف المحاضرة'));
      }
    } catch (e) {
      emit(LectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 6. الفلترة حسب النوع ومادة معينة
  Future<void> fetchLecturesByType(
    String token,
    String subjectId,
    String type,
  ) async {
    emit(LectureLoading());
    try {
      final lectureModel = await repository.getLecturesByType(
        token,
        subjectId,
        type,
      );

      if (lectureModel.isSuccess == true) {
        emit(LecturesLoaded(lectureModel.data ?? []));
      } else {
        emit(LectureError(lectureModel.message ?? 'فشل في فلترة المحاضرات'));
      }
    } catch (e) {
      emit(LectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 7. الفلترة المتقدمة
  Future<void> fetchLecturesAdvancedFilter(
    String token,
    String yearId,
    String semesterId,
    String subjectId,
    String type,
  ) async {
    emit(LectureLoading());
    try {
      final lectureModel = await repository.getLecturesAdvancedFilter(
        token,
        yearId,
        semesterId,
        subjectId,
        type,
      );

      if (lectureModel.isSuccess == true) {
        emit(LecturesLoaded(lectureModel.data ?? []));
      } else {
        emit(LectureError(lectureModel.message ?? 'فشل في الفلترة المتقدمة'));
      }
    } catch (e) {
      emit(LectureError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }
}
