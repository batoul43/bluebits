import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/features/surveys/surveys_student/data/models/student_surveys_models.dart';
import 'package:bluebits_app/features/surveys/surveys_student/data/surveys_repository/student_surveys_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'student_survey_state.dart';

class StudentSurveyCubit extends Cubit<StudentSurveyState> {
  final StudentSurveyRepository repository;

  StudentSurveyCubit({required this.repository})
    : super(StudentSurveyInitial());

  // 1. جلب الاستبيانات الفعالة
  Future<void> fetchActiveForms() async {
    emit(StudentSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final surveyModel = await repository.getActiveForms(token);

      if (surveyModel.isSuccess == true) {
        emit(StudentSurveysLoaded(surveyModel.data?.forms ?? []));
      } else {
        emit(
          StudentSurveyError(
            surveyModel.message ?? 'فشل في جلب الاستبيانات الفعالة',
          ),
        );
      }
    } catch (e) {
      emit(StudentSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 3. إرسال إجابات الاستبيان
  Future<void> submitSurveyResponse(Map<String, dynamic> responseData) async {
    emit(StudentSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final surveyModel = await repository.submitFormResponse(
        token,
        responseData,
      );

      if (surveyModel.isSuccess == true) {
        emit(
          StudentSurveyActionSuccess(
            surveyModel.message ?? 'تم إرسال التقييم بنجاح',
          ),
        );
        fetchActiveForms(); // تحديث القائمة بعد الإرسال
      } else {
        emit(StudentSurveyError(surveyModel.message ?? 'فشل في إرسال التقييم'));
      }
    } catch (e) {
      emit(StudentSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 4. جلب جميع ردود المستخدم السابقة
  Future<void> fetchMyResponses() async {
    emit(StudentSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final surveyModel = await repository.getMyResponses(token);

      if (surveyModel.isSuccess == true) {
        emit(StudentResponsesLoaded(surveyModel.data?.responses ?? []));
      } else {
        emit(
          StudentSurveyError(surveyModel.message ?? 'فشل في جلب ردودك السابقة'),
        );
      }
    } catch (e) {
      emit(StudentSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 5. جلب رد المستخدم على استبيان محدد
  Future<void> fetchMyResponseForForm(String formId) async {
    emit(StudentSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final surveyModel = await repository.getMyResponseForForm(token, formId);

      if (surveyModel.isSuccess == true) {
        emit(StudentSurveyDetailLoaded(surveyModel));
      } else {
        emit(
          StudentSurveyError(surveyModel.message ?? 'فشل في جلب تفاصيل الرد'),
        );
      }
    } catch (e) {
      emit(StudentSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 6. جلب إحصائيات المواد حسب السنة ونموذج التقييم
  Future<void> fetchSubjectsStatsByYearAndForm({
    required String yearId,
    required String formId,
  }) async {
    emit(StudentSurveyLoading());
    try {
      final token = await CachHelper.getValue('Token') ?? '';
      final surveyModel = await repository.getSubjectsStatsByYearAndForm(
        token,
        yearId,
        formId,
      );

      if (surveyModel.isSuccess == true) {
        emit(StudentSurveyStatsLoaded(surveyModel));
      } else {
        emit(
          StudentSurveyError(
            surveyModel.message ?? 'فشل في جلب الإحصائيات من الخادم',
          ),
        );
      }
    } catch (e) {
      emit(StudentSurveyError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }
}
