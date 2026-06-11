part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

// حالات جلب بيانات البروفايل
class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final Data data; // الآن نستخدم كلاس Data بدلاً من UserModel
  ProfileSuccess(this.data);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

// حالات تحديث البيانات النصية
class ProfileUpdateLoading extends ProfileState {}

class ProfileUpdateSuccess extends ProfileState {
  final Data updatedData; // نستخدم Data
  ProfileUpdateSuccess(this.updatedData);
}

class ProfileUpdateError extends ProfileState {
  final String message;
  ProfileUpdateError(this.message);
}

// حالات رفع الصورة
class ProfileImageUploadLoading extends ProfileState {}

class ProfileImageUploadSuccess extends ProfileState {
  final Data updatedData; // نستخدم Data
  ProfileImageUploadSuccess(this.updatedData);
}

class ProfileImageUploadError extends ProfileState {
  final String message;
  ProfileImageUploadError(this.message);
}

// حالات حذف الحساب
class ProfileDeleteLoading extends ProfileState {}

class ProfileDeleteSuccess extends ProfileState {}

class ProfileDeleteError extends ProfileState {
  final String message;
  ProfileDeleteError(this.message);
}
