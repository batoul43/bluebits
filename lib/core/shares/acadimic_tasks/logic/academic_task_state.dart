part of 'academic_task_cubit.dart';

abstract class AcademicTaskState {}

class AcademicTaskInitial extends AcademicTaskState {}

class AcademicTaskLoading extends AcademicTaskState {}

class AcademicTasksLoaded extends AcademicTaskState {
  final List<AcademicTaskModel> tasks;
  AcademicTasksLoaded(this.tasks);
}

class AcademicTaskDetailLoaded extends AcademicTaskState {
  final AcademicTaskModel task;
  AcademicTaskDetailLoaded(this.task);
}

class AcademicTaskActionSuccess extends AcademicTaskState {
  final String message;
  AcademicTaskActionSuccess(this.message);
}

class AcademicTaskError extends AcademicTaskState {
  final String message;
  AcademicTaskError(this.message);
}
