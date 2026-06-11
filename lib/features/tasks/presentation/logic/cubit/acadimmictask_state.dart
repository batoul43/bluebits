part of 'acadimmictask_cubit.dart';

abstract class AcadimictaskState {}

class AcadimmictaskInitial extends AcadimictaskState {}

class TaskYearAcadimic extends AcadimictaskState {}

class TaskSubjectAcadimic extends AcadimictaskState {
  final String selectedYear;
  final List subjects;
  TaskSubjectAcadimic(this.selectedYear, this.subjects);
}

class TaskAcadimicType extends AcadimictaskState {
  final String selectedYear;
  final String selectedSubject;
  final List types;
  TaskAcadimicType(this.selectedYear, this.selectedSubject, this.types);
}
