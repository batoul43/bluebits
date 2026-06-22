part of 'lesson_lecture_cubit.dart';

abstract class LessonLectureState {}

class LessonLectureInitial extends LessonLectureState {}

class LessonLectureLoading extends LessonLectureState {}

class LessonLecturesLoaded extends LessonLectureState {
  final List<Data> lessonLectures;
  LessonLecturesLoaded(this.lessonLectures);
}

class LessonLectureDetailLoaded extends LessonLectureState {
  final Data lessonLecture;
  LessonLectureDetailLoaded(this.lessonLecture);
}

class LessonLectureActionSuccess extends LessonLectureState {
  final String message;
  LessonLectureActionSuccess(this.message);
}

class LessonLectureError extends LessonLectureState {
  final String message;
  LessonLectureError(this.message);
}
