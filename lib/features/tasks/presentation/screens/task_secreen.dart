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
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: screenHeight * 0.004,
                  width: screenWidth * 0.60,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: screenHeight * 0.03),

                // ==========================================
                // 1. قسم المهام الشخصية
                // ==========================================
                BlocBuilder<TaskCubit, TaskState>(
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
                            _buildAddTaskField(
                              context,
                              theme,
                              screenWidth,
                              screenHeight,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Divider(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.1,
                              ),
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
                ),

                SizedBox(height: screenHeight * 0.04),

                // ==========================================
                // 2. قسم البومودورو
                // ==========================================
                _buildPomodoroCard(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.05),

                // ==========================================
                // 3. قسم المهام الأكاديمية (الربط مع SubjectCubit)
                // ==========================================
                const PageHeader(title: 'المهام الأكاديمية', subtitle: ''),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: screenHeight * 0.004,
                  width: screenWidth * 0.60,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: screenHeight * 0.03),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: BlocBuilder<AcadimmictaskCubit, AcadimictaskState>(
                    builder: (context, acadimicState) {
                      // ----------------------------------------
                      // الحالة الأولى: عرض شبكة السنوات
                      // ----------------------------------------
                      if (acadimicState is TaskYearAcadimic) {
                        return BlocBuilder<YearCubit, YearState>(
                          builder: (context, yearState) {
                            if (yearState is YearLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (yearState is YearError) {
                              return Center(
                                child: Text(
                                  yearState.message,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                              );
                            } else if (yearState is YearLoaded) {
                              final yearsList = yearState.years;

                              if (yearsList.isEmpty) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      "لا توجد سنوات دراسية مضافة بعد",
                                    ),
                                  ),
                                );
                              }

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: screenWidth > 600 ? 3 : 2,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 0.85,
                                    ),
                                itemCount: yearsList.length,
                                itemBuilder: (context, index) {
                                  final yearItem = yearsList[index];
                                  return YearCard(
                                    title: yearItem.name ?? "بدون اسم",
                                    onTap: () {
                                      // 1. تغيير واجهة المستخدم لعرض المواد (UI State)
                                      context
                                          .read<AcadimmictaskCubit>()
                                          .displaySubjects(yearItem.name ?? "");

                                      // 2. جلب المواد من السيرفر عبر الكيوبت (Data State)
                                      final yearId =
                                          yearItem.sId ??
                                          yearItem.sId.toString();
                                      context
                                          .read<SubjectCubit>()
                                          .getSubjectsByYear(yearId);
                                    },
                                  );
                                },
                              );
                            }
                            return const SizedBox();
                          },
                        );
                      }

                      // ----------------------------------------
                      // الحالة الثانية: عرض قائمة المواد أو زر العودة
                      // ----------------------------------------
                      return Column(
                        children: [
                          if (acadimicState is! TaskYearAcadimic)
                            Align(
                              alignment: Alignment.topLeft,
                              child: TextButton(
                                child: Text(
                                  "تغيير السنة",
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                onPressed: () {
                                  context
                                      .read<AcadimmictaskCubit>()
                                      .backTOYear();
                                },
                              ),
                            ),

                          if (acadimicState is TaskSubjectAcadimic)
                            // هنا نراقب SubjectCubit للحصول على البيانات الحقيقية
                            BlocBuilder<SubjectCubit, SubjectState>(
                              builder: (context, subjectState) {
                                if (subjectState is GetSubjectsLoading) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (subjectState is GetSubjectsFailure) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        subjectState.errorMessage,
                                        style: TextStyle(
                                          color: theme.colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (subjectState
                                    is GetSubjectsByYearAnsSemester) {
                                  // استخراج قائمة المواد من الموديل
                                  final subjectsList =
                                      subjectState
                                          .subjectsByYearSemester
                                          .data
                                          ?.subjects ??
                                      [];

                                  if (subjectsList.isEmpty) {
                                    return const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text(
                                          "لا تتوفر مواد لهذه السنة حالياً",
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: subjectsList.length,
                                    itemBuilder: (context, index) {
                                      final subject = subjectsList[index];
                                      return SubjectCard(
                                        isbank: true,
                                        onTap: () {
                                          // عند الضغط على مادة معينة لعرض الأنواع (Types)
                                          // context.read<AcadimmictaskCubit>().displayType(acadimicState.selectedYear, subject.name ?? "");
                                        },
                                        year: acadimicState.selectedYear,
                                        title: subject.name ?? "مادة بدون اسم",
                                        icon: const Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: ColorsManager.orange,
                                          size: 22,
                                        ),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox();
                              },
                            )
                          else
                            const SizedBox(),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------- توابع البناء المنفصلة (كما هي بدون تغيير) -----------

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

  Widget _buildPomodoroCard(double screenWidth, double screenHeight) {
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
}
