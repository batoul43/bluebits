part of 'subject_cubit.dart';

abstract class SubjectState {}

class SubjectInitial extends SubjectState {}

// ==========================================
// حالات جلب البيانات (Get All, By Year, By Semester, By Id)
// ==========================================
class GetSubjectsLoading extends SubjectState {}

class GetSubjectsSuccess extends SubjectState {
  final SubjectModel subjectModel;
  GetSubjectsSuccess(this.subjectModel);
}

class GetSubjectsByYearAnsSemester extends SubjectState {
  final SubjectsByYearSemester subjectsByYearSemester;
  GetSubjectsByYearAnsSemester(this.subjectsByYearSemester);
}

class GetSubjectsFailure extends SubjectState {
  final String errorMessage;
  GetSubjectsFailure(this.errorMessage);
}

// ==========================================
// حالات الإجراءات (Create, Update, Delete)
// ==========================================
class SubjectActionLoading extends SubjectState {}

class SubjectActionSuccess extends SubjectState {
  final SubjectModel subjectModel;
  final String message; // تمرير رسالة نجاح لعرضها كـ SnackBar مثلاً
  SubjectActionSuccess(this.subjectModel, this.message);
}

class SubjectActionFailure extends SubjectState {
  final String errorMessage;
  SubjectActionFailure(this.errorMessage);
}
