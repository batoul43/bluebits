import 'dart:io';
import 'package:bluebits_app/features/profile/data/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/features/profile/data/repository/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo repo;

  ProfileCubit({required this.repo}) : super(ProfileInitial());

  /// 1. جلب بيانات البروفايل
  Future<void> loadProfile(String token) async {
    emit(ProfileLoading());

    final response = await repo.getProfile(token);

    if (response != null &&
        response.isSuccess == true &&
        response.data != null) {
      emit(ProfileSuccess(response.data!));
    } else {
      emit(ProfileError(response?.message ?? "فشل جلب البيانات"));
    }
  }

  /// 2. تحديث البيانات النصية
  Future<void> updateProfile(Map<String, dynamic> data, String token) async {
    emit(ProfileUpdateLoading());
    final response = await repo.updateProfile(data, token);

    if (response != null &&
        response.isSuccess == true &&
        response.data != null) {
      // 1. إصدار حالة نجاح التحديث لكي يلتقطها الـ Listener ويظهر الـ SnackBar
      emit(ProfileUpdateSuccess(response.data!));

      // 2. إصدار حالة النجاح العامة فوراً لتحديث الواجهة بالبيانات الجديدة محلياً
      // بدون الحاجة لاستدعاء _refreshData() من الواجهة
      emit(ProfileSuccess(response.data!));
    } else {
      emit(ProfileUpdateError(response?.message ?? "فشل تحديث البيانات"));

      // اختياري: إذا فشل التحديث وأردت عدم إخفاء الشاشة，
      // يمكنك استدعاء دالة جلب البيانات السابقة هنا لكي تعود الواجهة كما كانت
      loadProfile(token);
    }
  }

  /// 3. تحديث ورفع الصورة
  Future<void> uploadImage(File imageFile, String token) async {
    emit(ProfileImageUploadLoading());
    final response = await repo.uploadProfileImage(imageFile, token);

    if (response != null &&
        response.isSuccess == true &&
        response.data != null) {
      emit(ProfileImageUploadSuccess(response.data!));
      // تحديث الشاشة فوراً بعد رفع الصورة
      emit(ProfileSuccess(response.data!));
    } else {
      emit(ProfileImageUploadError(response?.message ?? "فشل رفع الصورة"));
    }
  }

  Future<void> uploadProfileImage(File imageFile, String token) async {
    // 1. إصدار حالة التحميل
    emit(ProfileImageUploadLoading());

    // 2. استدعاء الـ Repo
    final response = await repo.uploadProfileImage(imageFile, token);

    // 3. فحص النتيجة
    if (response != null &&
        response.isSuccess == true &&
        response.data != null) {
      // نجاح: تحديث الحالة
      emit(ProfileImageUploadSuccess(response.data!));
      // تحديث الشاشة بالبيانات الجديدة (الصورة الجديدة)
      emit(ProfileSuccess(response.data!));
    } else {
      // فشل: إظهار رسالة الخطأ القادمة من السيرفر أو رسالة افتراضية
      emit(
        ProfileImageUploadError(
          response?.message ?? "حدث خطأ أثناء رفع الصورة",
        ),
      );
    }
  }

  /// 4. حذف الحساب
  Future<void> deleteAccount(String token) async {
    emit(ProfileDeleteLoading());
    final response = await repo.deleteAccount(token);

    if (response != null && response.isSuccess == true) {
      emit(ProfileDeleteSuccess());
    } else {
      emit(ProfileDeleteError(response?.message ?? "فشل حذف الحساب"));
    }
  }
}
