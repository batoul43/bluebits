import 'package:bluebits_app/core/shares/question_banks/data/models/general_question_bank.dart';
import 'package:bluebits_app/core/shares/question_banks/data/repository/question_banks_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/core/shares/question_banks/data/models/quesion_banks_model.dart';
import 'package:bluebits_app/core/shares/question_banks/data/models/quiz_execution_models.dart';

part 'question_bank_state.dart';

class QuestionBankCubit extends Cubit<QuestionBankState> {
  final QuestionBankRepository repository;

  QuestionBankCubit({required this.repository}) : super(QuestionBankInitial());

  // دالة مساعدة للتعامل مع الـ ApiResponse وتقليل التكرار
  void _handleApiResponse<T>(
    ApiResponse<T> response,
    void Function(T? data) onSuccess,
  ) {
    if (response.isSuccess) {
      onSuccess(response.data);
    } else {
      emit(QuestionBankError(response.message));
    }
  }

  // ==========================================
  // دوال جلب البيانات (Queries)
  // ==========================================

  /// 1. جلب بنوك الأسئلة مصنفة حسب السنة[cite: 57]
  Future<void> fetchBanksSortedByYear({
    required String token,
    String? subjectId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.getBanksSortedByYear(
        token: token,
        subjectId: subjectId,
      );
      _handleApiResponse(response, (data) {
        emit(QuestionBanksGroupedByYearLoaded(data ?? []));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 2. جلب تفاصيل البنك والأسئلة التابعة له[cite: 57]
  Future<void> fetchQuestionBankById({
    required String token,
    required String bankId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.getQuestionBankById(
        token: token,
        bankId: bankId,
      );
      _handleApiResponse(response, (data) {
        if (data != null) {
          emit(QuestionBankDetailLoaded(data));
        } else {
          emit(QuestionBankError('لم يتم العثور على بيانات البنك'));
        }
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 3. جلب بنك الأسئلة الخاص بمحاضرة محددة[cite: 57]
  Future<void> fetchQuestionBankByLectureId({
    required String token,
    required String lectureId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.getQuestionBankByLectureId(
        token: token,
        lectureId: lectureId,
      );
      _handleApiResponse(response, (data) {
        if (data != null) {
          emit(QuestionBankSingleLoaded(data));
        } else {
          emit(QuestionBankError('لم يتم العثور على البنك الخاص بالمحاضرة'));
        }
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 4. جلب قائمة البنوك لمادة معينة[cite: 57]
  Future<void> fetchQuestionBanksBySubjectId({
    required String token,
    required String subjectId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.getQuestionBanksBySubjectId(
        token: token,
        subjectId: subjectId,
      );
      _handleApiResponse(response, (data) {
        emit(QuestionBanksListLoaded(data ?? []));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 5. جلب قائمة البنوك لسنة دراسية معينة[cite: 57]
  Future<void> fetchQuestionBanksByYearId({
    required String token,
    required String yearId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.getQuestionBanksByYearId(
        token: token,
        yearId: yearId,
      );
      _handleApiResponse(response, (data) {
        emit(QuestionBanksListLoaded(data ?? []));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  // ==========================================
  // دوال العمليات والتعديل (Mutations)
  // ==========================================

  /// 6. رفع مجموعة أسئلة دفعة واحدة[cite: 57]
  Future<void> bulkUploadQuestions({
    required String token,
    required String lectureId,
    required List<QuestionModel> questions,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.bulkUploadQuestions(
        token: token,
        lectureId: lectureId,
        questions: questions,
      );
      _handleApiResponse(response, (_) {
        emit(QuestionBankOperationSuccess('تم رفع الأسئلة بنجاح'));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 7. رفع ملف وورد (.docx) لإنشاء الأسئلة[cite: 57]
  Future<void> uploadDocxBank({
    required String token,
    required String lectureId,
    required String filePath,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.uploadDocxBank(
        token: token,
        lectureId: lectureId,
        filePath: filePath,
      );
      _handleApiResponse(response, (_) {
        emit(QuestionBankOperationSuccess('تم رفع الملف وإنشاء الأسئلة بنجاح'));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 8. تحديث سؤال محدد[cite: 57]
  Future<void> updateQuestion({
    required String token,
    required String questionId,
    String? questionText,
    String? explanation,
    List<OptionModel>? options,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.updateQuestion(
        token: token,
        questionId: questionId,
        questionText: questionText,
        explanation: explanation,
        options: options,
      );
      _handleApiResponse(response, (_) {
        emit(QuestionBankOperationSuccess('تم تعديل السؤال بنجاح'));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 9. حذف سؤال محدد[cite: 57]
  Future<void> deleteQuestion({
    required String token,
    required String questionId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.deleteQuestion(
        token: token,
        questionId: questionId,
      );
      _handleApiResponse(response, (_) {
        emit(QuestionBankOperationSuccess('تم حذف السؤال بنجاح'));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 10. نشر بنك الأسئلة[cite: 57]
  Future<void> publishBank({
    required String token,
    required String bankId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.publishQuestionBank(
        token: token,
        bankId: bankId,
      );
      _handleApiResponse(response, (_) {
        emit(QuestionBankOperationSuccess('تم نشر البنك بنجاح'));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 11. إلغاء نشر بنك الأسئلة[cite: 57]
  Future<void> unpublishBank({
    required String token,
    required String bankId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.unpublishQuestionBank(
        token: token,
        bankId: bankId,
      );
      _handleApiResponse(response, (_) {
        emit(QuestionBankOperationSuccess('تم إلغاء نشر البنك بنجاح'));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  // ==========================================
  // دوال الاختبارات والنتائج (Quiz Executions)
  // ==========================================

  /// 12. إرسال الإجابات للتصحيح[cite: 57]
  Future<void> submitAnswers({
    required String token,
    required String bankId,
    required List<UserAnswerRequest> answers,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.submitQuestionBankAnswers(
        token: token,
        bankId: bankId,
        answers: answers,
      );
      _handleApiResponse(response, (data) {
        if (data != null) {
          emit(QuestionBankSubmissionSuccess(data));
        } else {
          emit(QuestionBankError('حدث خطأ أثناء معالجة النتيجة'));
        }
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 13. جلب جميع المحاولات السابقة للطالب في بنك معين[cite: 57]
  Future<void> fetchMyAttempts({
    required String token,
    required String bankId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.getMyAttempts(
        token: token,
        bankId: bankId,
      );
      _handleApiResponse(response, (data) {
        emit(QuestionBankAttemptsLoaded(data ?? []));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }

  /// 14. جلب نتائج الطلاب (مفيدة للأدوار الإدارية/المحاضرين)[cite: 57]
  Future<void> fetchQuestionBankResults({
    required String token,
    required String bankId,
  }) async {
    emit(QuestionBankLoading());
    try {
      final response = await repository.getQuestionBankResults(
        token: token,
        bankId: bankId,
      );
      _handleApiResponse(response, (data) {
        emit(QuestionBankResultsLoaded(data ?? []));
      });
    } catch (e) {
      emit(QuestionBankError(e.toString()));
    }
  }
}
