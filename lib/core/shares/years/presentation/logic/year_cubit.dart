import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/years/models/year_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bluebits_app/core/shares/years/data/repositry/year_repositry.dart';

part 'year_state.dart';

class YearCubit extends Cubit<YearState> {
  final YearRepository repository;

  YearCubit({required this.repository}) : super(YearInitial());

  // ==========================================
  // 1. جلب كل السنوات
  // ==========================================
  Future<void> fetchAllYears() async {
    emit(YearLoading());
    try {
      print('-----------------------------------');
      final token = await CachHelper.getValue('Token');
      final yearModel = await repository.getAllYears(token);
      print(yearModel);
      print('-------------------------------------------');
      if (yearModel.isSuccess == true) {
        List<Data> sortedYears = List.from(yearModel.data!);
        sortedYears.sort((a, b) => (b.order ?? 0).compareTo(a.order ?? 0));
        // ensure the data list has the correct type expected by YearLoaded
        print(
          "السنوات المرتبة هي: ${sortedYears.map((e) => e.order).toList()}",
        );
        emit(YearLoaded(sortedYears));
      } else {
        emit(YearError(yearModel.message ?? 'فشل في جلب قائمة السنوات'));
      }
    } catch (e) {
      emit(YearError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // ==========================================
  // 2. جلب سنة محددة بالـ ID
  // ==========================================
  Future<void> getYearById(String token, String yearId) async {
    emit(YearLoading());
    try {
      final yearModel = await repository.getYearById(token, yearId);

      if (yearModel.isSuccess == true &&
          yearModel.data != null &&
          yearModel.data!.isNotEmpty) {
        emit(YearDetailLoaded(yearModel.data!.first));
      } else {
        emit(YearError(yearModel.message ?? 'فشل في جلب بيانات السنة'));
      }
    } catch (e) {
      emit(YearError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // ==========================================
  // 3. إنشاء سنة جديدة
  // ==========================================
  Future<void> addYear(String token, String name, int order) async {
    emit(YearLoading());
    try {
      final yearModel = await repository.createYear(token, name, order);

      if (yearModel.isSuccess == true) {
        emit(YearActionSuccess(yearModel.message ?? 'تمت إضافة السنة بنجاح'));
        // إعادة جلب القائمة لتحديث شاشات العرض تلقائياً
        fetchAllYears();
      } else {
        emit(YearError(yearModel.message ?? 'فشل في إنشاء السنة'));
      }
    } catch (e) {
      emit(YearError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // ==========================================
  // 4. تحديث سنة
  // ==========================================
  Future<void> updateYear(String token, String yearId, String newName) async {
    emit(YearLoading());
    try {
      final yearModel = await repository.updateYear(token, yearId, newName);

      if (yearModel.isSuccess == true) {
        emit(YearActionSuccess(yearModel.message ?? 'تم تحديث السنة بنجاح'));
        fetchAllYears();
      } else {
        emit(YearError(yearModel.message ?? 'فشل في تحديث السنة'));
      }
    } catch (e) {
      emit(YearError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // ==========================================
  // 5. حذف سنة
  // ==========================================
  Future<void> deleteYear(String token, String yearId) async {
    emit(YearLoading());
    try {
      final yearModel = await repository.deleteYear(token, yearId);

      if (yearModel.isSuccess == true) {
        emit(YearActionSuccess(yearModel.message ?? 'تم حذف السنة بنجاح'));
        fetchAllYears();
      } else {
        emit(YearError(yearModel.message ?? 'فشل في حذف السنة'));
      }
    } catch (e) {
      emit(YearError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }
}
