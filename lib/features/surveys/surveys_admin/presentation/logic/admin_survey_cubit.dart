import 'package:bluebits_app/features/surveys/surveys_admin/data/models/admin_form_response.dart';
import 'package:bluebits_app/features/surveys/surveys_admin/data/repository/admin_survey_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';

part 'admin_survey_state.dart';

class AdminSurveyCubit extends Cubit<AdminSurveyState> {
  final AdminSurveyRepository repository;

  AdminSurveyCubit({required this.repository}) : super(AdminSurveyInitial());

  // 1. جلب كل الاستبيانات (تم التحديث للتوافق مع المودل الجديد)
  Future<void> fetchAllForms() async {
    emit(AdminSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.getAllForms(token);

      if (response.isSuccess == true) {
        List<AdminFormModel> formsList = [];

        // التعامل مع البيانات سواء كانت القادمة مصفوفة أو كائن فردي
        if (response.data != null) {
          if (response.data is List<AdminFormModel>) {
            formsList = response.data as List<AdminFormModel>;
          } else if (response.data is AdminFormModel) {
            formsList = [response.data as AdminFormModel];
          }
        }

        emit(AdminSurveysLoaded(formsList));
      } else {
        emit(AdminSurveyError(response.message ?? 'فشل في جلب الاستبيانات'));
      }
    } catch (e) {
      emit(AdminSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 2. إنشاء استبيان جديد
  Future<void> createForm(
    String semesterId,
    String yearId,
    String academicYear,
  ) async {
    emit(AdminSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.createForm(
        token,
        semesterId,
        yearId,
        academicYear,
      );

      if (response.isSuccess == true) {
        emit(
          AdminSurveyActionSuccess(
            response.message ?? 'تم إنشاء الاستبيان بنجاح',
          ),
        );
        fetchAllForms();
      } else {
        emit(AdminSurveyError(response.message ?? 'فشل في إنشاء الاستبيان'));
      }
    } catch (e) {
      emit(AdminSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 3. فتح / تفعيل الاستبيان
  Future<void> openForm(String formId) async {
    emit(AdminSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.openForm(token, formId);

      if (response.isSuccess == true) {
        emit(
          AdminSurveyActionSuccess(
            response.message ?? 'تم تفعيل الاستبيان بنجاح',
          ),
        );
        fetchAllForms();
      } else {
        emit(AdminSurveyError(response.message ?? 'فشل في تفعيل الاستبيان'));
      }
    } catch (e) {
      emit(AdminSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 4. إغلاق الاستبيان
  Future<void> closeForm(String formId) async {
    emit(AdminSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.closeForm(token, formId);

      if (response.isSuccess == true) {
        emit(
          AdminSurveyActionSuccess(
            response.message ?? 'تم إغلاق الاستبيان بنجاح',
          ),
        );
        fetchAllForms();
      } else {
        emit(AdminSurveyError(response.message ?? 'فشل في إغلاق الاستبيان'));
      }
    } catch (e) {
      emit(AdminSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 5. جلب نتائج الاستبيان
  Future<void> fetchFormResults(String formId) async {
    emit(AdminSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.getFormResults(token, formId);

      if (response.isSuccess == true) {
        emit(AdminSurveyResultsLoaded(response.data));
      } else {
        emit(
          AdminSurveyError(response.message ?? 'فشل في جلب نتائج الاستبيان'),
        );
      }
    } catch (e) {
      emit(AdminSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 6. حذف الاستبيان
  Future<void> deleteForm(String formId) async {
    emit(AdminSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.deleteForm(token, formId);

      if (response.isSuccess == true) {
        emit(
          AdminSurveyActionSuccess(
            response.message ?? 'تم حذف الاستبيان بنجاح',
          ),
        );
        fetchAllForms();
      } else {
        emit(AdminSurveyError(response.message ?? 'فشل في حذف الاستبيان'));
      }
    } catch (e) {
      emit(AdminSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }
}
