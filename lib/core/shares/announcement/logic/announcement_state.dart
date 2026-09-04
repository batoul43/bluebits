part of 'announcement_cubit.dart';

abstract class AnnouncementState {}

class AnnouncementInitial extends AnnouncementState {}

class AnnouncementLoading extends AnnouncementState {}

// حالة جلب قائمة الإعلانات
class AnnouncementsLoaded extends AnnouncementState {
  final List<AnnouncementModel> announcements;
  AnnouncementsLoaded(this.announcements);
}

// حالة جلب تفاصيل إعلان واحد
class AnnouncementDetailLoaded extends AnnouncementState {
  final AnnouncementModel announcement;
  AnnouncementDetailLoaded(this.announcement);
}

// حالة نجاح عملية (إنشاء، تعديل، حذف)
class AnnouncementActionSuccess extends AnnouncementState {
  final String message;
  AnnouncementActionSuccess(this.message);
}

// حالة حدوث خطأ
class AnnouncementError extends AnnouncementState {
  final String message;
  AnnouncementError(this.message);
}
