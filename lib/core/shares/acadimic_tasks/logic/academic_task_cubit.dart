import 'package:bluebits_app/core/shares/acadimic_tasks/data/academic_tasks_repository/academic_tasks_repository.dart';
import 'package:bluebits_app/core/shares/acadimic_tasks/data/models/academic_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:flutter/foundation.dart';

part 'academic_task_state.dart';

// دالة خارجية لعملية الـ Parsing في خيط فرعي (Isolate) بعيداً عن الخيط الرئيسي
List<AcademicTaskModel> parseTasksInBackground(List<dynamic> dataList) {
  return dataList
      .map((e) => AcademicTaskModel.fromJson(e as Map<String, dynamic>))
      .toList();
}

class AcademicTaskCubit extends Cubit<AcademicTaskState> {
  final AcademicTaskRepository repository;

  AcademicTaskCubit({required this.repository}) : super(AcademicTaskInitial());

  // 1. جلب كافة المهام الأكاديمية
  Future<void> fetchAllAcademicTasks() async {
    emit(AcademicTaskLoading());
    try {
      print('-------------------------------------------');
      print('🔵 [AcademicTaskCubit] Fetching all academic tasks...');
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.getAllAcademicTasks(token);
      print('📄 [AcademicTaskCubit] Response: $response');
      print('-------------------------------------------');

      if (response['status'] == 'success' || response['isSuccess'] == true) {
        final rawData = response['data'];
        List<dynamic> dataList = [];

        if (rawData is List) {
          dataList = rawData;
        } else if (rawData is Map<String, dynamic>) {
          dataList = rawData['tasks'] ?? [];
        }

        final tasks = await compute(parseTasksInBackground, dataList);
        emit(AcademicTasksLoaded(tasks));
      } else {
        emit(
          AcademicTaskError(
            response['message'] ?? 'فشل في جلب المهام الأكاديمية',
          ),
        );
      }
    } catch (e) {
      print('🔴 [AcademicTaskCubit Error] fetchAllAcademicTasks: $e');
      emit(AcademicTaskError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 2. إنشاء مهمة أكاديمية جديدة
  Future<void> createTask(CreateAcademicTaskRequest request) async {
    emit(AcademicTaskLoading());
    try {
      print('-------------------------------------------');
      print('🔵 [AcademicTaskCubit] Creating new task...');
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.createTask(token, request);
      print('📄 [AcademicTaskCubit] Response: $response');
      print('-------------------------------------------');

      if (response['status'] == 'success' || response['isSuccess'] == true) {
        emit(
          AcademicTaskActionSuccess(
            response['message'] ?? 'تم إنشاء المهمة بنجاح',
          ),
        );
        fetchAllAcademicTasks();
      } else {
        emit(
          AcademicTaskError(
            response['message'] ?? 'فشل في إنشاء المهمة الأكاديمية',
          ),
        );
      }
    } catch (e) {
      print('🔴 [AcademicTaskCubit Error] createTask: $e');
      emit(AcademicTaskError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 3. جلب تفاصيل مهمة عبر الـ ID
  Future<void> fetchTaskById(String taskId) async {
    emit(AcademicTaskLoading());
    try {
      print('-------------------------------------------');
      print('🔵 [AcademicTaskCubit] Fetching task by ID: $taskId');
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.getAcademicTaskById(token, taskId);
      print('📄 [AcademicTaskCubit] Response: $response');
      print('-------------------------------------------');

      if (response['status'] == 'success' || response['isSuccess'] == true) {
        final taskData = response['data']?['task'] ?? response['data'];
        if (taskData != null && taskData is Map<String, dynamic>) {
          final task = AcademicTaskModel.fromJson(taskData);
          emit(AcademicTaskDetailLoaded(task));
        } else {
          emit(AcademicTaskError('بيانات المهمة غير صالحة'));
        }
      } else {
        emit(
          AcademicTaskError(response['message'] ?? 'فشل في جلب تفاصيل المهمة'),
        );
      }
    } catch (e) {
      print('🔴 [AcademicTaskCubit Error] fetchTaskById: $e');
      emit(AcademicTaskError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 4. تحديث مهمة أكاديمية
  Future<void> updateTask(
    String taskId,
    UpdateAcademicTaskRequest request,
  ) async {
    emit(AcademicTaskLoading());
    try {
      print('-------------------------------------------');
      print('🔵 [AcademicTaskCubit] Updating task ID: $taskId');
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.updateTask(token, taskId, request);
      print('📄 [AcademicTaskCubit] Response: $response');
      print('-------------------------------------------');

      if (response['status'] == 'success' || response['isSuccess'] == true) {
        emit(
          AcademicTaskActionSuccess(
            response['message'] ?? 'تم تحديث المهمة بنجاح',
          ),
        );
        fetchAllAcademicTasks();
      } else {
        emit(
          AcademicTaskError(
            response['message'] ?? 'فشل في تحديث المهمة الأكاديمية',
          ),
        );
      }
    } catch (e) {
      print('🔴 [AcademicTaskCubit Error] updateTask: $e');
      emit(AcademicTaskError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 5. حذف مهمة أكاديمية
  Future<void> deleteTask(String taskId) async {
    emit(AcademicTaskLoading());
    try {
      print('-------------------------------------------');
      print('🔵 [AcademicTaskCubit] Deleting task ID: $taskId');
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.deleteTask(token, taskId);
      print('📄 [AcademicTaskCubit] Response: $response');
      print('-------------------------------------------');

      if (response['status'] == 'success' || response['isSuccess'] == true) {
        emit(
          AcademicTaskActionSuccess(
            response['message'] ?? 'تم حذف المهمة بنجاح',
          ),
        );
        fetchAllAcademicTasks();
      } else {
        emit(
          AcademicTaskError(
            response['message'] ?? 'فشل في حذف المهمة الأكاديمية',
          ),
        );
      }
    } catch (e) {
      print('🔴 [AcademicTaskCubit Error] deleteTask: $e');
      emit(AcademicTaskError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 6. إغلاق مهمة أكاديمية يدوياً
  Future<void> closeTask(String taskId) async {
    emit(AcademicTaskLoading());
    try {
      print('-------------------------------------------');
      print('🔵 [AcademicTaskCubit] Closing task ID: $taskId');
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.closeTask(token, taskId);
      print('📄 [AcademicTaskCubit] Response: $response');
      print('-------------------------------------------');

      if (response['status'] == 'success' || response['isSuccess'] == true) {
        emit(
          AcademicTaskActionSuccess(
            response['message'] ?? 'تم إغلاق المهمة بنجاح',
          ),
        );
        fetchAllAcademicTasks();
      } else {
        emit(
          AcademicTaskError(
            response['message'] ?? 'فشل في إغلاق المهمة الأكاديمية',
          ),
        );
      }
    } catch (e) {
      print('🔴 [AcademicTaskCubit Error] closeTask: $e');
      emit(AcademicTaskError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }

  // 7. فلترة المهام حسب السنة أو المادة
  Future<void> fetchTasksByFilter({String? yearId, String? subjectId}) async {
    emit(AcademicTaskLoading());
    try {
      print('-------------------------------------------');
      print(
        '🔵 [AcademicTaskCubit] Filtering tasks (yearId: $yearId, subjectId: $subjectId)...',
      );
      final token = await CachHelper.getValue('Token') ?? '';
      final response = await repository.getTasksByFilter(
        token: token,
        yearId: yearId,
        subjectId: subjectId,
      );
      print('📄 [AcademicTaskCubit] Response: $response');
      print('-------------------------------------------');

      if (response['status'] == 'success' || response['isSuccess'] == true) {
        final rawData = response['data'];
        List<dynamic> dataList = [];

        if (rawData is List) {
          dataList = rawData;
        } else if (rawData is Map<String, dynamic>) {
          dataList = rawData['tasks'] ?? [];
        }

        final tasks = await compute(parseTasksInBackground, dataList);
        emit(AcademicTasksLoaded(tasks));
      } else {
        emit(
          AcademicTaskError(
            response['message'] ?? 'فشل في فلترة المهام الأكاديمية',
          ),
        );
      }
    } catch (e) {
      print('🔴 [AcademicTaskCubit Error] fetchTasksByFilter: $e');
      emit(AcademicTaskError('حدث خطأ في الاتصال: ${e.toString()}'));
    }
  }
}
