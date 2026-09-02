part of 'question_bank_cubit.dart';

abstract class QuestionBankState {}

class QuestionBankInitial extends QuestionBankState {}

class QuestionBankLoading extends QuestionBankState {}

/// حالة جلب البنوك على شكل قائمة عادية (حسب المادة أو السنة)
class QuestionBanksListLoaded extends QuestionBankState {
  final List<QuestionBankModel> banks;
  QuestionBanksListLoaded(this.banks);
}

/// حالة جلب البنوك مجمعة ومصنفة حسب السنة الدراسية
class QuestionBanksGroupedByYearLoaded extends QuestionBankState {
  final List<YearBanksGroupModel> groupedBanks;
  QuestionBanksGroupedByYearLoaded(this.groupedBanks);
}

/// حالة جلب بيانات بنك واحد فقط (بدون أسئلته)
class QuestionBankSingleLoaded extends QuestionBankState {
  final QuestionBankModel bank;
  QuestionBankSingleLoaded(this.bank);
}

/// حالة جلب تفاصيل البنك مع الأسئلة الخاصة به
class QuestionBankDetailLoaded extends QuestionBankState {
  final BankWithQuestionsResponse bankDetails;
  QuestionBankDetailLoaded(this.bankDetails);
}

/// حالة جلب نتائج الطلاب في بنك معين
class QuestionBankResultsLoaded extends QuestionBankState {
  final List<QuestionBankResultModel> results;
  QuestionBankResultsLoaded(this.results);
}

/// حالة جلب المحاولات السابقة للطالب
class QuestionBankAttemptsLoaded extends QuestionBankState {
  final List<AttemptModel> attempts;
  QuestionBankAttemptsLoaded(this.attempts);
}

/// حالة النجاح في تقديم الإجابات والتصحيح
class QuestionBankSubmissionSuccess extends QuestionBankState {
  final SubmissionResultModel result;
  QuestionBankSubmissionSuccess(this.result);
}

/// حالة نجاح العمليات (إضافة، تعديل، حذف، نشر، إلغاء نشر)
class QuestionBankOperationSuccess extends QuestionBankState {
  final String message;
  QuestionBankOperationSuccess(this.message);
}

/// حالة حدوث خطأ
class QuestionBankError extends QuestionBankState {
  final String errorMessage;
  QuestionBankError(this.errorMessage);
}
