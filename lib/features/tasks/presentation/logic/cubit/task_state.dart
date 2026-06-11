part of 'task_cubit.dart';

@immutable
abstract class TaskState {}

final class TaskInitial extends TaskState {}

class TasksLoaded extends TaskState {
  final List<TaskModel> filteredTasks;
  final int activeStatusIndex; // 0: الكل، 1: قيد التنفيذ، 2: المكتملة
  final int activeTypeIndex;

  // --- متحولات التايمر الجديدة ---
  final int remainingSeconds;
  final bool isRunning;

  TasksLoaded({
    required this.filteredTasks,
    required this.activeStatusIndex,
    required this.activeTypeIndex,
    this.remainingSeconds = 25 * 60, // القيمة الافتراضية 25 دقيقة
    this.isRunning = false,
  });

  // --- دالة النسخ لتحديث التايمر بسهولة ---
  TasksLoaded copyWith({
    List<TaskModel>? filteredTasks,
    int? activeStatusIndex,
    int? activeTypeIndex,
    int? remainingSeconds,
    bool? isRunning,
  }) {
    return TasksLoaded(
      filteredTasks: filteredTasks ?? this.filteredTasks,
      activeStatusIndex: activeStatusIndex ?? this.activeStatusIndex,
      activeTypeIndex: activeTypeIndex ?? this.activeTypeIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

class TasksError extends TaskState {
  final String message;
  TasksError(this.message);
}
