import 'package:bluebits_app/core/shares/acadimic_tasks/logic/academic_task_cubit.dart';
import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/widget/subject_card.dart';
import 'package:bluebits_app/core/widget/year_card.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:bluebits_app/features/tasks/presentation/logic/cubit/acadimmictask_cubit.dart';
import 'package:bluebits_app/features/tasks/presentation/logic/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksScreen extends StatelessWidget {
  TasksScreen({super.key});

  final TextEditingController _taskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PageHeader(
                  title: 'المهام الشخصية',
                  subtitle: 'إدارة مشفرة لخصوصيتك اليومية على جهازك',
                ),
                _buildDivider(theme, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.03),

                // ==========================================
                // 1. قسم المهام الشخصية
                // ==========================================
                _buildPersonalTasksSection(
                  context,
                  theme,
                  screenWidth,
                  screenHeight,
                ),
                SizedBox(height: screenHeight * 0.04),

                // ==========================================
                // 2. قسم البومودورو
                // ==========================================
                _buildPomodoroCard(context, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.05),

                // ==========================================
                // 3. قسم المهام الأكاديمية
                // ==========================================
                const PageHeader(title: 'المهام الأكاديمية', subtitle: ''),
                _buildDivider(theme, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.03),

                _buildAcademicSection(
                  context,
                  theme,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // توابع البناء المنفصلة (Clean Code Widgets)
  // ==========================================

  Widget _buildDivider(
    ThemeData theme,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      height: screenHeight * 0.004,
      width: screenWidth * 0.60,
      color: theme.colorScheme.primary,
    );
  }

  // --- قسم المهام الشخصية ---
  Widget _buildPersonalTasksSection(
    BuildContext context,
    ThemeData theme,
    double screenWidth,
    double screenHeight,
  ) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TasksError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        }
        if (state is TasksLoaded) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: screenWidth * 0.04,
                  offset: Offset(0, screenHeight * 0.006),
                ),
              ],
            ),
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                _buildAddTaskField(context, theme, screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.02),
                Divider(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  thickness: 1,
                ),
                if (state.filteredTasks.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Text(
                      "لا توجد مهام حالياً",
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
                else
                  _buildTasksList(
                    context,
                    state,
                    theme,
                    screenWidth,
                    screenHeight,
                  ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildAddTaskField(
    BuildContext context,
    ThemeData theme,
    double screenWidth,
    double screenHeight,
  ) {
    return Form(
      key: _formKey,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                context.read<TaskCubit>().addTask(
                  _taskController.text.trim(),
                  "مهمة مضافة محلياً",
                  "الآن",
                );
                _taskController.clear();
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(
              width: screenWidth * 0.12,
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add,
                color: theme.colorScheme.onPrimary,
                size: screenWidth * 0.06,
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: TextFormField(
              controller: _taskController,
              decoration: InputDecoration(
                hintText: 'أضف مهمة جديدة..',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.015,
                ),
              ),
              style: theme.textTheme.bodyLarge,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return '';
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(
    BuildContext context,
    TasksLoaded state,
    ThemeData theme,
    double screenWidth,
    double screenHeight,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.filteredTasks.length,
      separatorBuilder: (context, index) => Divider(
        color: theme.colorScheme.onSurface.withOpacity(0.05),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final task = state.filteredTasks[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error.withOpacity(0.5),
                  size: screenWidth * 0.06,
                ),
                onPressed: () => context.read<TaskCubit>().deleteTask(task.id),
              ),
              const Spacer(),
              Text(
                task.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: screenWidth * 0.038,
                  color: task.isCompleted
                      ? theme.colorScheme.onSurface.withOpacity(0.4)
                      : theme.colorScheme.onSurface,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              SizedBox(width: screenWidth * 0.03),
              InkWell(
                onTap: () =>
                    context.read<TaskCubit>().toggleTaskStatus(task.id),
                child: task.isCompleted
                    ? Icon(
                        Icons.check_circle,
                        color: ColorsManager.green,
                        size: screenWidth * 0.065,
                      )
                    : Icon(
                        Icons.radio_button_unchecked,
                        color: theme.colorScheme.onSurface.withOpacity(0.2),
                        size: screenWidth * 0.065,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- قسم البومودورو ---
  Widget _buildPomodoroCard(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: ColorsManager.pomodoroPurple,
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
      ),
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.008,
                ),
                decoration: BoxDecoration(
                  color: ColorsManager.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(screenWidth * 0.05),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.blur_on,
                      color: ColorsManager.white,
                      size: screenWidth * 0.045,
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Text(
                      'جلسة تركيز',
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: screenWidth * 0.032,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                state is TasksLoaded
                    ? '${(state.remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(state.remainingSeconds % 60).toString().padLeft(2, '0')}'
                    : '25:00',
                style: TextStyle(
                  color: ColorsManager.white,
                  fontSize: screenWidth * 0.15,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorsManager.pomodoroPurple.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        size: screenWidth * 0.06,
                        color: ColorsManager.white,
                      ),
                      onPressed: () => context.read<TaskCubit>().stopTimer(),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.06),
                  Container(
                    width: screenWidth * 0.14,
                    height: screenWidth * 0.14,
                    decoration: const BoxDecoration(
                      color: ColorsManager.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        state is TasksLoaded
                            ? (state.isRunning
                                  ? Icons.pause
                                  : Icons.play_arrow_rounded)
                            : Icons.play_arrow_rounded,
                        color: ColorsManager.pomodoroPurple,
                        size: screenWidth * 0.08,
                      ),
                      onPressed: () => context.read<TaskCubit>().startTimer(),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // --- قسم المهام الأكاديمية (السنوات والمواد) ---
  Widget _buildAcademicSection(
    BuildContext context,
    ThemeData theme,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
      ),
      child: BlocBuilder<AcadimmictaskCubit, AcadimictaskState>(
        builder: (context, acadimicState) {
          if (acadimicState is TaskYearAcadimic) {
            return _buildYearsGrid(screenWidth, theme);
          }
          return _buildSubjectsList(
            context,
            acadimicState,
            theme,
            screenWidth,
            screenHeight,
          );
        },
      ),
    );
  }

  Widget _buildYearsGrid(double screenWidth, ThemeData theme) {
    return BlocBuilder<YearCubit, YearState>(
      builder: (context, yearState) {
        if (yearState is YearLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (yearState is YearError) {
          return Center(
            child: Text(
              yearState.message,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        } else if (yearState is YearLoaded) {
          if (yearState.years.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("لا توجد سنوات دراسية مضافة بعد"),
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              crossAxisSpacing: screenWidth * 0.04,
              mainAxisSpacing: screenWidth * 0.04,
              childAspectRatio: 0.85,
            ),
            itemCount: yearState.years.length,
            itemBuilder: (context, index) {
              final yearItem = yearState.years[index];
              return YearCard(
                title: yearItem.name ?? "بدون اسم",
                onTap: () {
                  context.read<AcadimmictaskCubit>().displaySubjects(
                    yearItem.name ?? "",
                  );
                  final yearId = yearItem.sId ?? yearItem.sId.toString();
                  context.read<SubjectCubit>().getSubjectsByYear(yearId);
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSubjectsList(
    BuildContext context,
    AcadimictaskState acadimicState,
    ThemeData theme,
    double screenWidth,
    double screenHeight,
  ) {
    return Column(
      children: [
        if (acadimicState is! TaskYearAcadimic)
          Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () => context.read<AcadimmictaskCubit>().backTOYear(),
              child: Text(
                "العودة للسنوات",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ),
          ),
        if (acadimicState is TaskSubjectAcadimic)
          BlocBuilder<SubjectCubit, SubjectState>(
            builder: (context, subjectState) {
              if (subjectState is GetSubjectsLoading) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (subjectState is GetSubjectsFailure) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      subjectState.errorMessage,
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                );
              } else if (subjectState is GetSubjectsByYearAnsSemester) {
                final subjectsList =
                    subjectState.subjectsByYearSemester.data?.subjects ?? [];
                if (subjectsList.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("لا تتوفر مواد لهذه السنة حالياً"),
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subjectsList.length,
                  itemBuilder: (context, index) {
                    final subject = subjectsList[index];
                    return SubjectCard(
                      isbank: false,
                      year: acadimicState.selectedYear,
                      title: subject.name ?? "مادة بدون اسم",
                      icon: const Icon(
                        Icons.assignment_outlined,
                        color: ColorsManager.orange,
                        size: 22,
                      ),
                      onTap: () {
                        final academicTaskCubit = context
                            .read<AcademicTaskCubit>();
                        final subjectId = subject.sId?.toString() ?? "";

                        academicTaskCubit.fetchTasksByFilter(
                          subjectId: subjectId,
                        );

                        _showAcademicTasksBottomSheet(
                          context,
                          academicTaskCubit,
                          subject.name ?? "المادة",
                          theme,
                          screenWidth,
                          screenHeight,
                        );
                      },
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
      ],
    );
  }

  // ==========================================
  // نافذة عرض المهام الأكاديمية للمادة المحددة
  // ==========================================
  void _showAcademicTasksBottomSheet(
    BuildContext context,
    AcademicTaskCubit academicCubit,
    String subjectName,
    ThemeData theme,
    double screenWidth,
    double screenHeight,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: academicCubit,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              height: screenHeight * 0.75,
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: screenWidth * 0.15,
                      height: 5,
                      decoration: BoxDecoration(
                        color: ColorsManager.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "المهام الأكاديمية: $subjectName",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  Divider(color: theme.colorScheme.primary.withOpacity(0.3)),
                  SizedBox(height: screenHeight * 0.01),
                  Expanded(
                    child: BlocBuilder<AcademicTaskCubit, AcademicTaskState>(
                      builder: (context, state) {
                        if (state is AcademicTaskLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is AcademicTaskError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          );
                        } else if (state is AcademicTasksLoaded) {
                          if (state.tasks.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.assignment_turned_in_outlined,
                                    size: screenWidth * 0.15,
                                    color: ColorsManager.greyText,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),
                                  Text(
                                    "لا يوجد مهام أكاديمية لهذه المادة حالياً",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            );
                          }
                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.tasks.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: screenHeight * 0.015),
                            itemBuilder: (context, index) {
                              final task = state.tasks[index];
                              final isClosed = task.status == 'closed';

                              return Container(
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(
                                    screenWidth * 0.04,
                                  ),
                                  border: Border.all(
                                    color: isClosed
                                        ? ColorsManager.green.withOpacity(0.5)
                                        : theme.colorScheme.primary.withOpacity(
                                            0.2,
                                          ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            task.title,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                                  decoration: isClosed
                                                      ? TextDecoration
                                                            .lineThrough
                                                      : null,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02,
                                            vertical: screenHeight * 0.005,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isClosed
                                                ? ColorsManager.green
                                                      .withOpacity(0.1)
                                                : ColorsManager.orange
                                                      .withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            isClosed ? 'مغلقة' : 'مفتوحة',
                                            style: TextStyle(
                                              color: isClosed
                                                  ? ColorsManager.green
                                                  : ColorsManager.orange,
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (task.description.isNotEmpty) ...[
                                      SizedBox(height: screenHeight * 0.01),
                                      Text(
                                        task.description,
                                        style: theme.textTheme.bodyMedium,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
