part of 'lectures_cubit.dart';

@immutable
sealed class LecturesState {}

final class LecturesInitial extends LecturesState {}

class DisplayYears extends LecturesState {}

class DisplaySemesters extends LecturesState {
  final String selectedYear;
  DisplaySemesters({required this.selectedYear});
}

class DisplaySubjects extends LecturesState {
  final String selectedYear;
  final String selectedSubject;

  DisplaySubjects({required this.selectedYear, required this.selectedSubject});
}
