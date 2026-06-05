import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'acadimmictask_state.dart';

class AcadimmictaskCubit extends Cubit<AcadimictaskState> {
  AcadimmictaskCubit() : super(AcadimmictaskInitial());
  void backTOYear() {
    emit(TaskYearAcadimic()); // Replace '2023' with the actual selected year
  }

  void backTOsubject(String year, List subjects) {
    emit(
      TaskSubjectAcadimic(year, subjects),
    ); // Replace '2023' with the actual selected year
  }

  void displaySubjects(String year) {
    // Replace with actual subjects for the selected year
    List subjects = ['Subject 1', 'Subject 2', 'Subject 3'];
    emit(TaskSubjectAcadimic(year, subjects));
  }

  void displayType(String year, String subject) {
    // Replace with actual types for the selected year and subject
    List types = ['Type 1', 'Type 2', 'Type 3'];
    emit(TaskAcadimicType(year, subject, types));
  }
}
