import 'package:bluebits_app/core/shares/question_banks/data/api_service/question_bank_api_service.dart';
import 'package:bluebits_app/core/shares/question_banks/data/models/general_question_bank.dart';
import 'package:bluebits_app/core/shares/question_banks/data/models/quesion_banks_model.dart';
import 'package:bluebits_app/core/shares/question_banks/data/models/quiz_execution_models.dart';

class QuestionBankRepository {
  final QuestionBankApiService apiService;

  QuestionBankRepository(this.apiService);

  /// رفع أسئلة متعددة دفعة واحدة
  Future<ApiResponse<QuestionBankModel>> bulkUploadQuestions({
    required String token,
    required String lectureId,
    required List<QuestionModel> questions,
  }) async {
    final response = await apiService.bulkUploadQuestions(
      token: token,
      lectureId: lectureId,
      questions: questions.map((e) => e.toJson()).toList(),
    );
    return ApiResponse.fromJson(
      response,
      (data) => QuestionBankModel.fromJson(data),
    );
  }

  /// رفع بنك أسئلة عبر ملف Word (.docx)
  Future<ApiResponse<QuestionBankModel>> uploadDocxBank({
    required String token,
    required String lectureId,
    required String filePath,
  }) async {
    final response = await apiService.uploadDocxBank(
      token: token,
      lectureId: lectureId,
      filePath: filePath,
    );
    return ApiResponse.fromJson(
      response,
      (data) => QuestionBankModel.fromJson(data),
    );
  }

  /// تحديث بيانات سؤال فردي
  Future<ApiResponse<QuestionModel>> updateQuestion({
    required String token,
    required String questionId,
    String? questionText,
    String? explanation,
    List<OptionModel>? options,
  }) async {
    final response = await apiService.updateQuestion(
      token: token,
      questionId: questionId,
      questionText: questionText,
      explanation: explanation,
      options: options?.map((e) => e.toJson()).toList(),
    );
    return ApiResponse.fromJson(
      response,
      (data) => QuestionModel.fromJson(data),
    );
  }

  /// حذف سؤال من البنك
  Future<ApiResponse<QuestionModel>> deleteQuestion({
    required String token,
    required String questionId,
  }) async {
    final response = await apiService.deleteQuestion(
      token: token,
      questionId: questionId,
    );
    return ApiResponse.fromJson(
      response,
      (data) => QuestionModel.fromJson(data),
    );
  }

  /// نشر بنك الأسئلة
  Future<ApiResponse<QuestionBankModel>> publishQuestionBank({
    required String token,
    required String bankId,
  }) async {
    final response = await apiService.publishQuestionBank(
      token: token,
      bankId: bankId,
    );
    return ApiResponse.fromJson(
      response,
      (data) => QuestionBankModel.fromJson(data),
    );
  }

  /// إلغاء نشر بنك الأسئلة
  Future<ApiResponse<QuestionBankModel>> unpublishQuestionBank({
    required String token,
    required String bankId,
  }) async {
    final response = await apiService.unpublishQuestionBank(
      token: token,
      bankId: bankId,
    );
    return ApiResponse.fromJson(
      response,
      (data) => QuestionBankModel.fromJson(data),
    );
  }

  /// جلب بنك الأسئلة مع قائمة الأسئلة الخاصة به
  Future<ApiResponse<BankWithQuestionsResponse>> getQuestionBankById({
    required String token,
    required String bankId,
  }) async {
    final response = await apiService.getQuestionBankById(
      token: token,
      bankId: bankId,
    );
    return ApiResponse.fromJson(
      response,
      (data) => BankWithQuestionsResponse.fromJson(data),
    );
  }

  /// جلب البنوك مقسمة ومصنفة حسب السنين الدراسية
  Future<ApiResponse<List<YearBanksGroupModel>>> getBanksSortedByYear({
    required String token,
    String? subjectId,
  }) async {
    final response = await apiService.getBanksSortedByYear(
      token: token,
      subjectId: subjectId,
    );
    return ApiResponse.fromJson(
      response,
      (data) =>
          (data as List).map((e) => YearBanksGroupModel.fromJson(e)).toList(),
    );
  }

  /// جلب بنك أسئلة الخاص بمحاضرة معينة
  Future<ApiResponse<QuestionBankModel>> getQuestionBankByLectureId({
    required String token,
    required String lectureId,
  }) async {
    final response = await apiService.getQuestionBankByLectureId(
      token: token,
      lectureId: lectureId,
    );
    return ApiResponse.fromJson(
      response,
      (data) => QuestionBankModel.fromJson(data),
    );
  }

  /// جلب البنوك التابعة لسنة دراسية
  Future<ApiResponse<List<QuestionBankModel>>> getQuestionBanksByYearId({
    required String token,
    required String yearId,
  }) async {
    final response = await apiService.getQuestionBanksByYearId(
      token: token,
      yearId: yearId,
    );
    return ApiResponse.fromJson(
      response,
      (data) =>
          (data as List).map((e) => QuestionBankModel.fromJson(e)).toList(),
    );
  }

  /// جلب البنوك التابعة لمادة دراسية
  Future<ApiResponse<List<QuestionBankModel>>> getQuestionBanksBySubjectId({
    required String token,
    required String subjectId,
  }) async {
    final response = await apiService.getQuestionBanksBySubjectId(
      token: token,
      subjectId: subjectId,
    );
    return ApiResponse.fromJson(
      response,
      (data) =>
          (data as List).map((e) => QuestionBankModel.fromJson(e)).toList(),
    );
  }

  /// جلب نتائج الطلاب لبنك أسئلة
  Future<ApiResponse<List<QuestionBankResultModel>>> getQuestionBankResults({
    required String token,
    required String bankId,
  }) async {
    final response = await apiService.getQuestionBankResults(
      token: token,
      bankId: bankId,
    );
    return ApiResponse.fromJson(
      response,
      (data) => (data as List)
          .map((e) => QuestionBankResultModel.fromJson(e))
          .toList(),
    );
  }

  /// إرسال إجابات الطالب لتصحيحها والحصول على النتيجة والتغذية الراجعة
  Future<ApiResponse<SubmissionResultModel>> submitQuestionBankAnswers({
    required String token,
    required String bankId,
    required List<UserAnswerRequest> answers,
  }) async {
    final response = await apiService.submitQuestionBankAnswers(
      token: token,
      bankId: bankId,
      answers: answers.map((e) => e.toJson()).toList(),
    );
    return ApiResponse.fromJson(
      response,
      (data) => SubmissionResultModel.fromJson(data),
    );
  }

  /// جلب المحاولات السابقة للمستخدم الحالي في بنك أسئلة معين
  Future<ApiResponse<List<AttemptModel>>> getMyAttempts({
    required String token,
    required String bankId,
  }) async {
    final response = await apiService.getMyAttempts(
      token: token,
      bankId: bankId,
    );
    return ApiResponse.fromJson(
      response,
      (data) => (data as List).map((e) => AttemptModel.fromJson(e)).toList(),
    );
  }
}
