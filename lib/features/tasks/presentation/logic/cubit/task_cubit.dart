import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/features/tasks/data/models/task_model.dart';
import 'package:meta/meta.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final List<TaskModel> _allTasks = [];
  int _activeStatusIndex = 0;
  Timer? _timer;

  static const String _storageKey = 'secure_personal_tasks_data';

  // قراءة المهام وتشفيرها من الذاكرة فور فتح الصفحة
  Future<void> loadTasks() async {
    try {
      final String? savedData = await CachHelper.getValue(_storageKey);
      if (savedData != null && savedData.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(savedData);
        _allTasks.clear();
        _allTasks.addAll(
          decodedList.map((item) => TaskModel.fromjson(item)).toList(),
        );
      }
      _applyFilter();
    } catch (e) {
      emit(TasksError("فشل في تحميل المهام المحلية"));
      _applyFilter();
    }
  }

  // حفظ تلقائي فوري مشفر في الذاكرة المحلية للجهاز بعد كل تعديل
  Future<void> _saveToSecureStorage() async {
    final String encodedData = jsonEncode(
      _allTasks.map((t) => t.toMap()).toList(),
    );
    await CachHelper.setValue(_storageKey, encodedData);
  }

  // إضافة مهمة جديدة وحفظها
  Future<void> addTask(String title, String description, String time) async {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      time: time,
      isAcademic: false,
    );
    _allTasks.add(newTask);
    await _saveToSecureStorage();

    _applyFilter();
  }

  // تحديد المهمة كمكتملة أو قيد التنفيذ
  Future<void> toggleTaskStatus(String taskId) async {
    final index = _allTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _allTasks[index].isCompleted = !_allTasks[index].isCompleted;
      await _saveToSecureStorage();
      _applyFilter();
    }
  }

  // حذف المهمة نهائياً من ذاكرة الجهاز الآمنة
  Future<void> deleteTask(String taskId) async {
    _allTasks.removeWhere((t) => t.id == taskId);
    await _saveToSecureStorage();
    _applyFilter();
  }

  // تغيير تبويب الفلترة
  void changeStatusFilter(int index) {
    _activeStatusIndex = index;
    _applyFilter();
  }

  // الفلترة وبث الحالة بمرجع ذاكرة جديد .toList() لإجبار الواجهة على التحديث النظيف
  void _applyFilter() {
    final List<TaskModel> result = _allTasks.where((task) {
      if (_activeStatusIndex == 1 && task.isCompleted) return false;
      if (_activeStatusIndex == 2 && !task.isCompleted) return false;
      return true;
    }).toList();

    // نحتفظ بحالة التايمر الحالية عشان ما يتصفر العداد عند الفلترة أو إضافة مهمة
    int currentSeconds = 25 * 60;
    bool currentRunning = false;

    if (state is TasksLoaded) {
      currentSeconds = (state as TasksLoaded).remainingSeconds;
      currentRunning = (state as TasksLoaded).isRunning;
    }

    emit(
      TasksLoaded(
        filteredTasks: result,
        activeStatusIndex: _activeStatusIndex,
        activeTypeIndex: 0,
        remainingSeconds: currentSeconds,
        isRunning: currentRunning,
      ),
    );
  }

  // هذا التابع يتم استدعاؤه عند الضغط على زر التشغيل/الإيقاف
  void startTimer() {
    if (state is! TasksLoaded) return;
    final currentState = state as TasksLoaded;

    // 1. إذا كان شغال -> وقفه تماماً والغِ النبضات في الخلفية
    if (currentState.isRunning) {
      _timer?.cancel(); // إيقاف تدفق النبضات فوراً
      emit(currentState.copyWith(isRunning: false));
    }
    // 2. إذا كان متوقف -> شغّله من جديد بنفس الثواني المتبقية
    else {
      // خطوة أمان احتياطية: نلغي أي تايمر قديم معلق لتجنب التكرار
      _timer?.cancel();

      emit(currentState.copyWith(isRunning: true));

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state is TasksLoaded) {
          final s = state as TasksLoaded;
          if (s.remainingSeconds > 0) {
            emit(s.copyWith(remainingSeconds: s.remainingSeconds - 1));
          } else {
            stopTimer(); // دالة الإيقاف عند انتهاء الوقت (تأكد أنها تحتوي على _timer?.cancel())
          }
        }
      });
    }
  }

  // دالة إيقاف التايمر
  void stopTimer() {
    _timer?.cancel(); // تنظيف الذاكرة
    if (state is TasksLoaded) {
      final currentState = state as TasksLoaded;
      emit(
        currentState.copyWith(
          isRunning: false,
          remainingSeconds: 25 * 60, // أو القيمة الافتراضية للـ Reset
        ),
      );
    }
  }

  // لا تنسَ إلغاء التايمر عند حذف الـ Cubit لمنع تسريب الذاكرة
  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
