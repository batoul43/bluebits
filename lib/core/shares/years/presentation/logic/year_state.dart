part of 'year_cubit.dart';

abstract class YearState {}

// الحالة الأولية عند تشغيل التطبيق
class YearInitial extends YearState {}

// حالة التحميل (تظهر مؤشر الانتظار في الـ UI)
class YearLoading extends YearState {}

// حالة نجاح جلب كل السنوات (تمرر قائمة من كائنات Data للـ UI)
class YearLoaded extends YearState {
  final List<Data> years;
  YearLoaded(this.years);
}

// حالة نجاح جلب سنة واحدة بالتحديد
class YearDetailLoaded extends YearState {
  final Data year;
  YearDetailLoaded(this.year);
}

// حالة نجاح عمليات الإدخال والتعديل والحذف (تمرر رسالة السيرفر للـ UI)
class YearActionSuccess extends YearState {
  final String message;
  YearActionSuccess(this.message);
}

// حالة الفشل (سواء فشل من السيرفر أو خطأ اتصال بالإنترنت)
class YearError extends YearState {
  final String message;
  YearError(this.message);
}
