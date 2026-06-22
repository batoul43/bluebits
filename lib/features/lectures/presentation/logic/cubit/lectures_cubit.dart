import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'lectures_state.dart';

class LecturesCubit extends Cubit<LecturesState> {
  LecturesCubit() : super(DisplayYears());

  void backToYears() {
    emit(LecturesInitial());
    emit(DisplayYears());
  }

  void displaySemesters(String year) {
    emit(LecturesInitial());
    emit(DisplaySemesters(selectedYear: year));
  }

  void displaySubjects(String year, String semester) {
    emit(LecturesInitial());
    emit(DisplaySubjects(selectedYear: year, selectedSemester: semester));
  }

  // دالة جديدة للذهاب لاختيار النوع
  void displayTypes(String year, String semester, String subject) {
    emit(LecturesInitial());
    emit(
      DisplayTypes(
        selectedYear: year,
        selectedSemester: semester,
        selectedSubject: subject,
      ),
    );
  }

  // دالة جديدة لعرض المحاضرات
  void displayLecturesList(
    String year,
    String semester,
    String subject,
    String type,
  ) {
    emit(LecturesInitial());
    emit(
      DisplayLecturesList(
        selectedYear: year,
        selectedSemester: semester,
        selectedSubject: subject,
        selectedType: type,
      ),
    );
  }
}
