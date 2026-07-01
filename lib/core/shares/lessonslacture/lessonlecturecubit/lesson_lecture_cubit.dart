import 'dart:io';

import 'package:bluebits_app/core/shares/lessonslacture/data/models/lesson_lecture_models.dart';
import 'package:bluebits_app/core/shares/lessonslacture/data/repositry/lesson_lecture_repository.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
      print('-----------------------------------------------------');
      final lectureModel = await repository.uploadLecture(
        token,
        title,
        description,
        subjectId,
        type,
        isPublished,
        filePath,
      );
      print(lectureModel);

      if (lectureModel.isSuccess == true) {
        fetchAllLectures();
        emit(
          LessonLectureActionSuccess(
            lectureModel.message ?? 'تم رفع المحاضرة بنجاح',
          ),
        );
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

  // 8. تحميل المحاضرة إلى مساحة تخزين الجهاز (الجديدة)
  // ========================================================
  Future<void> downloadLectureToDevice(
    String lectureId,
    List<Data> currentLectures,
  ) async {
    emit(LessonLectureLoading());

    try {
      // 1. التعامل الذكي مع صلاحيات التخزين حسب إصدار Android
      bool hasPermission = await _requestStoragePermission();

      if (!hasPermission) {
        emit(LessonLectureError('يجب الموافقة على صلاحية التخزين لحفظ الملف'));
        emit(LessonLecturesLoaded(currentLectures));
        return;
      }

      final token = await CachHelper.getValue('Token') ?? '';

      // 2. الحصول على رابط التحميل
      final model = await repository.downloadLectureFile(token, lectureId);

      if (model.statusCode == 200 && model.downloadData != null) {
        final downloadUrl = model.downloadData!.downloadUrl!;
        final title = model.downloadData!.title ?? "lecture";
        final fileType = model.downloadData!.fileType ?? "application/pdf";
        final extension = fileType.contains('/')
            ? fileType.split('/').last
            : 'pdf';

        // 3. التحميل
        final response = await http.get(Uri.parse(downloadUrl));

        if (response.statusCode == 200) {
          // 4. الحصول على مسار التحميل المضمون
          Directory? downloadDirectory;
          if (Platform.isAndroid) {
            // مجلد التنزيلات العام في أندرويد
            downloadDirectory = Directory('/storage/emulated/0/Download');
            if (!await downloadDirectory.exists()) {
              // مسار بديل إذا لم يكن المجلد موجودًا
              downloadDirectory = await getExternalStorageDirectory();
            }
          } else if (Platform.isIOS) {
            // مسار المستندات في الايفون
            downloadDirectory = await getApplicationDocumentsDirectory();
          }

          if (downloadDirectory == null) {
            emit(LessonLectureError('لم يتم العثور على مسار لحفظ الملف'));
            emit(LessonLecturesLoaded(currentLectures));
            return;
          }

          // تنظيف الاسم من الرموز غير المسموحة في أسماء الملفات
          final safeFileName = title
              .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
              .trim();

          final filePath =
              '${downloadDirectory.path}/${safeFileName}_${DateTime.now().millisecondsSinceEpoch}.$extension';

          // 5. حفظ الملف
          final file = File(filePath);
          await file.writeAsBytes(response.bodyBytes);

          emit(
            LessonLectureActionSuccess('تم تحميل الملف بنجاح: $safeFileName'),
          );
          emit(LessonLecturesLoaded(currentLectures));
        } else {
          emit(
            LessonLectureError(
              'فشل تحميل الملف. الكود: ${response.statusCode}',
            ),
          );
          emit(LessonLecturesLoaded(currentLectures));
        }
      } else {
        emit(LessonLectureError(model.message ?? 'فشل الحصول على الرابط'));
        emit(LessonLecturesLoaded(currentLectures));
      }
    } catch (e) {
      emit(LessonLectureError('خطأ أثناء التنزيل: ${e.toString()}'));
      emit(LessonLecturesLoaded(currentLectures));
    }
  }

  // دالة مساعدة لطلب الصلاحيات بذكاء
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      // Android 13 وما فوق (API level 33+)
      if (androidInfo.version.sdkInt >= 33) {
        // في Android 13+ لا توجد صلاحية WRITE_EXTERNAL_STORAGE عامة
        // للملفات العادية (مثل PDF) لا نحتاج صلاحية للتحميل في مجلد Download!
        // ولكن للحيطة يمكن طلب الصلاحيات التالية إذا كنا نتعامل مع صور/فيديو
        // var photos = await Permission.photos.request();
        // return photos.isGranted;

        // ببساطة، نرجع true لأننا نملك صلاحية الكتابة في مسار التحميلات ضمناً
        return true;
      }
      // Android 10, 11, 12
      else if (androidInfo.version.sdkInt >= 29) {
        var status = await Permission.storage.request();
        if (status.isPermanentlyDenied) {
          await openAppSettings();
          return false;
        }
        // في Android 11+، قد نطلب Manage External Storage إذا لزم الأمر
        if (!status.isGranted) {
          var manageStatus = await Permission.manageExternalStorage.request();
          return manageStatus.isGranted;
        }
        return status.isGranted;
      }
      // Android 9 وما دون
      else {
        var status = await Permission.storage.request();
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      // iOS
      var status = await Permission.storage.request();
      return status.isGranted;
    }
    return false;
  }
}
