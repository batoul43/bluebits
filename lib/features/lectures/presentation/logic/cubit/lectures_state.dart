part of 'lectures_cubit.dart';

@immutable
abstract class LecturesState {}

final class LecturesInitial extends LecturesState {}

class DisplayYears extends LecturesState {}

class DisplaySemesters extends LecturesState {
  final String selectedYear;
  DisplaySemesters({required this.selectedYear});
}

class DisplaySubjects extends LecturesState {
  final String selectedYear;
  final String selectedSemester; // تم تصحيح المسمى ليكون دقيقاً

  DisplaySubjects({required this.selectedYear, required this.selectedSemester});
}

// حالة جديدة: عرض أنواع المحاضرات (نظري / عملي)
class DisplayTypes extends LecturesState {
  final String selectedYear;
  final String selectedSemester;
  final String selectedSubject;

  DisplayTypes({
    required this.selectedYear,
    required this.selectedSemester,
    required this.selectedSubject,
  });
}

// حالة جديدة: عرض قائمة المحاضرات المفلترة
class DisplayLecturesList extends LecturesState {
  final String selectedYear;
  final String selectedSemester;
  final String selectedSubject;
  final String selectedType;

  DisplayLecturesList({
    required this.selectedYear,
    required this.selectedSemester,
    required this.selectedSubject,
    required this.selectedType,
  });
}
