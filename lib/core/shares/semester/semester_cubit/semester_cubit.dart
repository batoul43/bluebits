import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/semester/data/models/semestrs_model.dart';
import 'package:bluebits_app/core/shares/semester/data/repositry/semester_repositry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'semester_state.dart';

class SemesterCubit extends Cubit<SemesterState> {
  final SemesterRepository repository;

  SemesterCubit({required this.repository}) : super(SemesterInitial());

  // ==========================================
  // 1. جلب كل الفصول
  // ==========================================
  Future<void> fetchAllSemesters() async {
    emit(SemesterLoading());
    try {
      print('-----------------------------------');
      print('SemesterCubit: Fetching all semesters...');
      final token = await CachHelper.getValue('Token');
      print(token);
      final semesterModel = await repository.getAllSemesters(
        token?.trim() ?? '',
      );

      if (semesterModel.isSuccess == true) {
        // تمرير قائمة الفصول بنجاح إلى الواجهة
        final semesters = List<Data>.from(semesterModel.data ?? []);
        emit(SemesterLoaded(semesters));
      } else {
        emit(SemesterError(semesterModel.message ?? 'فشل في جلب قائمة الفصول'));
      }
      print('-------------------------------------------');
    } catch (e) {
      emit(SemesterError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // ==========================================
  // 2. إنشاء فصل جديد
  // ==========================================
  Future<void> createSemester(String name) async {
    emit(SemesterLoading());
    try {
      final token = await CachHelper.getValue('Token');
      final semesterModel = await repository.createSemester(
        token?.trim() ?? '',
        name,
      );

      if (semesterModel.isSuccess == true) {
        emit(
          SemesterActionSuccess(
            semesterModel.message ?? 'تم إنشاء الفصل بنجاح',
          ),
        );
        // تحديث القائمة تلقائياً في الخلفية لتعرض الفصل الجديد فوراً
        fetchAllSemesters();
      } else {
        emit(SemesterError(semesterModel.message ?? 'فشل في إنشاء الفصل'));
      }
    } catch (e) {
      emit(SemesterError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // ==========================================
  // 3. تحديث فصل
  // ==========================================
  Future<void> updateSemester(String semesterId, String newName) async {
    emit(SemesterLoading());
    try {
      final token = await CachHelper.getValue('Token');
      final semesterModel = await repository.updateSemester(
        token?.trim() ?? '',
        semesterId,
        newName,
      );

      if (semesterModel.isSuccess == true) {
        emit(
          SemesterActionSuccess(
            semesterModel.message ?? 'تم تحديث الفصل بنجاح',
          ),
        );
        // تحديث القائمة تلقائياً ليعكس الاسم الجديد في الواجهة
        fetchAllSemesters();
      } else {
        emit(SemesterError(semesterModel.message ?? 'فشل في تحديث الفصل'));
      }
    } catch (e) {
      emit(SemesterError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // ==========================================
  // 4. حذف فصل
  // ==========================================
  Future<void> deleteSemester(String semesterId) async {
    emit(SemesterLoading());
    try {
      final token = await CachHelper.getValue('Token');
      final semesterModel = await repository.deleteSemester(
        token?.trim() ?? '',
        semesterId,
      );

      if (semesterModel.isSuccess == true) {
        emit(
          SemesterActionSuccess(semesterModel.message ?? 'تم حذف الفصل بنجاح'),
        );
        // تحديث القائمة تلقائياً لإخفاء الفصل المحذوف
        fetchAllSemesters();
      } else {
        emit(SemesterError(semesterModel.message ?? 'فشل في حذف الفصل'));
      }
    } catch (e) {
      emit(SemesterError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }
}
