import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'lectures_state.dart';

class LecturesCubit extends Cubit<LecturesState> {
  LecturesCubit() : super(DisplayYears());
  void backTOYear() {
    emit(LecturesInitial());
    emit(DisplayYears());
  }

  void displaySemesters(String year) {
    emit(LecturesInitial());
    emit(DisplaySemesters(selectedYear: year));
  }

  void displaySubjects(String year, String subject) {
    emit(LecturesInitial());
    emit(DisplaySubjects(selectedYear: year, selectedSubject: subject));
  }

  void backToSemesters(String year) {
    emit(LecturesInitial());
    emit(DisplaySemesters(selectedYear: year));
  }
}
