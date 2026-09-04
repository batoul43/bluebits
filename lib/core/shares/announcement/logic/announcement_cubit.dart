import 'package:bluebits_app/core/shares/announcement/data/models/annnouncement_models.dart';
import 'package:bluebits_app/core/shares/announcement/data/repository/announcement_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';

part 'announcement_state.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  // تم إضافة هذا السطر لحل الخطأ
  final AnnouncementRepository repository;

  AnnouncementCubit({required this.repository}) : super(AnnouncementInitial());

  // 1. جلب جميع الإعلانات
  Future<void> fetchAllAnnouncements() async {
    emit(AnnouncementLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final model = await repository.getAllAnnouncements(token);

      if (model.isSuccess == true) {
        emit(AnnouncementsLoaded(model.data ?? []));
      } else {
        emit(AnnouncementError(model.message));
      }
    } catch (e) {
      emit(AnnouncementError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 2. إنشاء إعلان جديد
  Future<void> createAnnouncement(
    String title,
    String content,
    String yearId,
  ) async {
    emit(AnnouncementLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final model = await repository.createAnnouncement(
        token,
        title,
        content,
        yearId,
      );

      if (model.isSuccess == true) {
        emit(AnnouncementActionSuccess(model.message));
        fetchAllAnnouncements(); // تحديث القائمة بعد الإضافة
      } else {
        emit(AnnouncementError(model.message));
      }
    } catch (e) {
      emit(AnnouncementError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 3. جلب إعلان محدد بواسطة الـ ID
  Future<void> fetchAnnouncementById(String announcementId) async {
    emit(AnnouncementLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final model = await repository.getAnnouncementById(token, announcementId);

      if (model.isSuccess == true) {
        emit(AnnouncementDetailLoaded(model.data));
      } else {
        emit(AnnouncementError(model.message));
      }
    } catch (e) {
      emit(AnnouncementError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 4. تعديل الإعلان
  Future<void> updateAnnouncement(
    String announcementId, {
    String? title,
    String? content,
    String? yearId,
  }) async {
    emit(AnnouncementLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';

      final model = await repository.updateAnnouncement(
        token,
        announcementId,
        title: title,
        content: content,
        yearId: yearId,
      );

      if (model.isSuccess == true) {
        emit(AnnouncementActionSuccess(model.message));
        fetchAllAnnouncements(); // تحديث القائمة بعد التعديل
      } else {
        emit(AnnouncementError(model.message));
      }
    } catch (e) {
      emit(AnnouncementError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 5. حذف الإعلان
  Future<void> deleteAnnouncement(String announcementId) async {
    emit(AnnouncementLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final model = await repository.deleteAnnouncement(token, announcementId);

      if (model.isSuccess == true) {
        emit(AnnouncementActionSuccess(model.message));
        fetchAllAnnouncements(); // تحديث القائمة بعد الحذف
      } else {
        emit(AnnouncementError(model.message));
      }
    } catch (e) {
      emit(AnnouncementError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }
}
