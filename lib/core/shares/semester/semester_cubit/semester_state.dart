part of 'semester_cubit.dart';

abstract class SemesterState {}

// 1. الحالة الأولية عند تشغيل التطبيق أو فتح الصفحة
class SemesterInitial extends SemesterState {}

// 2. حالة التحميل (تظهر مؤشر الانتظار CircularProgressIndicator في الـ UI)
class SemesterLoading extends SemesterState {}

// 3. حالة نجاح جلب كل الفصول (تمرر قائمة من كائنات Data الخاصة بالفصول إلى الـ UI)
class SemesterLoaded extends SemesterState {
  final List<Data> semesters;
  SemesterLoaded(this.semesters);
}

// 4. حالة نجاح جلب فصل واحد بالتحديد عبر الـ ID
class SemesterDetailLoaded extends SemesterState {
  final Data semester;
  SemesterDetailLoaded(this.semester);
}

// 5. حالة نجاح عمليات الإدخال، التعديل، والحذف (تمرر رسالة النجاح القادمة من السيرفر لعرضها في SnackBar)
class SemesterActionSuccess extends SemesterState {
  final String message;
  SemesterActionSuccess(this.message);
}

// 6. حالة الفشل (سواء بسبب خطأ من السيرفر أو انقطاع الاتصال بالإنترنت)
class SemesterError extends SemesterState {
  final String message;
  SemesterError(this.message);
}
