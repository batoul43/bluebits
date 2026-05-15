part of 'lectures_cubit.dart';

@immutable
sealed class LecturesState {}

final class LecturesInitial extends LecturesState {}

class DisplayYears extends LecturesState {}

class DisplaySemesters extends LecturesState {
  final String selectedYear;
  DisplaySemesters(this.selectedYear);
}
