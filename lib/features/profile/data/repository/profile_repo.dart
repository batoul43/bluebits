import 'dart:io';
import 'package:bluebits_app/features/profile/data/api_service/profile_api.dart';

import 'package:bluebits_app/features/profile/data/models/profile_model.dart';

class ProfileRepo {
  final ProfileApi profileApi;

  ProfileRepo({required this.profileApi});

  /// 1. جلب بيانات البروفايل
  Future<ProfileModel?> getProfile(String token) async {
    try {
      final res = await profileApi.getProfile(token);
      return ProfileModel.fromJson(res);
    } catch (e) {
      print('ProfileRepo.getProfile Error: $e');
      return null;
    }
  }

  /// 2. تحديث بيانات البروفايل
  Future<ProfileModel?> updateProfile(
    Map<String, dynamic> data,
    String token,
  ) async {
    try {
      final res = await profileApi.updateMe(data, token);
      return ProfileModel.fromJson(res);
    } catch (e) {
      print('ProfileRepo.updateProfile Error: $e');
      return null;
    }
  }

  /// 3. تحديث ورفع الصورة الشخصية
  Future<ProfileModel?> uploadProfileImage(File imageFile, String token) async {
    try {
      final res = await profileApi.updateMeAndUpload(imageFile, token);
      return ProfileModel.fromJson(res);
    } catch (e) {
      print('ProfileRepo.uploadProfileImage Error: $e');
      return null;
    }
  }

  Future<ProfileModel?> updateMeAndUpload(File imageFile, String token) async {
    try {
      // استدعاء الدالة من الـ API
      final res = await profileApi.updateMeAndUpload(imageFile, token);

      // تحويل النتيجة إلى المودل
      return ProfileModel.fromJson(res);
    } catch (e) {
      // في حال حدوث أي خطأ، سنطبع الخطأ ونعيد null
      print('ProfileRepo.updateMeAndUpload Error: $e');
      return null;
    }
  }

  /// 4. حذف الحساب
  Future<ProfileModel?> deleteAccount(String token) async {
    try {
      final res = await profileApi.deleteMe(token);
      return ProfileModel.fromJson(res);
    } catch (e) {
      print('ProfileRepo.deleteAccount Error: $e');
      return null;
    }
  }
}
