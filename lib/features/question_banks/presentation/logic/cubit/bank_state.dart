part of 'bank_cubit.dart';

@immutable
sealed class BankState {}

final class BankInitial extends BankState {}

final class BankLoading extends BankState {}

final class BankYear extends BankState {}

final class BankSubject extends BankState {
  final String selectedYear;
  final List subjects;
  BankSubject(this.selectedYear, this.subjects);
}

final class BankQuestion extends BankState {
  final String selectedyear;
  final String selectedsubject;
  final List<QuestionModel> questions;

  BankQuestion({
    required this.selectedyear,
    required this.selectedsubject,
    required this.questions,
  });
}

final class BankEmpty extends BankState {
  final String selectedYear;

  BankEmpty({required this.selectedYear});
}
