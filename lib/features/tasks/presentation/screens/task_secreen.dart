import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/widget/subject_card.dart';
import 'package:bluebits_app/core/widget/year_card.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:bluebits_app/features/tasks/presentation/logic/cubit/acadimmictask_cubit.dart';
import 'package:bluebits_app/features/tasks/presentation/logic/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// مسار ملف الألوان

class TasksScreen extends StatelessWidget {
  TasksScreen({super.key});

  // تعريف المتحكمات داخل الـ StatelessWidget
  final TextEditingController _taskController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // 1. الميديا كويري للحصول على أبعاد متجاوبة
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // 2. استدعاء الثيم الحالي (المبني في app_theme.dart)
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl, // واجهة باللغة العربية
      child: Scaffold(
        // أخذ لون الخلفية تلقائياً من الثيم (lightBlue أو darkBlue)
        backgroundColor: theme.scaffoldBackgroundColor,

        // تم إزالة الـ AppBar بالكامل، ونستخدم SafeArea لحماية المحتوى من النوتش العلوية
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, // هوامش متجاوبة 5%
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- استخدام PageHeader المرفق من قبلك ---
                const PageHeader(
                  title: 'المهام الشخصية',
                  subtitle: 'إدارة مشفرة لخصوصيتك اليومية على جهازك',
                ),
                // الخط الأزرق التزييني أسفل العنوان (كما في الصورة)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: screenHeight * 0.004,
                  width: screenWidth * 0.60,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: screenHeight * 0.03),

                // --- الحاوية الرئيسية للمهام ---
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
                          color: theme
                              .colorScheme
                              .surface, // أبيض بالفاتح، كحلي بالداكن
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
                            // حقل الإدخال
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

                            // قائمة المهام
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
                    return SizedBox();
                  },
                ),

                SizedBox(height: screenHeight * 0.04),

                // --- كرت البومودورو (جلسة التركيز) ---
                _buildPomodoroCard(screenWidth, screenHeight),
                SizedBox(height: screenHeight * 0.05),
                PageHeader(title: 'المهام الأكادمية', subtitle: ''),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: screenHeight * 0.004,
                  width: screenWidth * 0.60,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface, // اللون الأبيض من الثيم
                    borderRadius: BorderRadius.circular(
                      25,
                    ), // نفس انحناء بطاقات الـ Home
                  ),
                  child: BlocBuilder<AcadimmictaskCubit, AcadimictaskState>(
                    builder: (context, state) {
                      if (state is TaskYearAcadimic) {
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: screenWidth > 600 ? 3 : 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.85,
                          children: [
                            YearCard(
                              title: "السنة الأولى",
                              onTap: () {
                                context
                                    .read<AcadimmictaskCubit>()
                                    .displaySubjects("السنة الأولى");
                              },
                            ),
                            YearCard(
                              title: "السنة الثانية",
                              onTap: () {
                                context
                                    .read<AcadimmictaskCubit>()
                                    .displaySubjects("السنة الثانية");
                              },
                            ),
                            YearCard(
                              title: "السنة الثالثة",
                              onTap: () {
                                context
                                    .read<AcadimmictaskCubit>()
                                    .displaySubjects("السنة الثالثة");
                              },
                            ),
                            YearCard(
                              title: "السنة الرابعة",
                              onTap: () {
                                context
                                    .read<AcadimmictaskCubit>()
                                    .displaySubjects("السنة الرابعة");
                              },
                            ),
                          ],
                        );
                      }

                      // For other states show change-year button and subjects if available
                      return Column(
                        children: [
                          state is! TaskYearAcadimic
                              ? Align(
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
                                )
                              : SizedBox(),
                          if (state is TaskSubjectAcadimic)
                            state.subjects.isEmpty
                                ? Center(
                                    child: Text(
                                      "لا تتوفر مهام لهذه السنة حاليا",
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: state.subjects.length,
                                    itemBuilder: (context, index) {
                                      return SubjectCard(
                                        isbank: true,
                                        onTap: () {},
                                        year: state.selectedYear,
                                        title: state.subjects[index],
                                        icon: Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: ColorsManager.orange,
                                          size: 22,
                                        ),
                                      );
                                    },
                                  )
                          else
                            SizedBox(),
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

  // ----------- توابع البناء المنفصلة -----------

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
          // زر الإضافة
          InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                context.read<TaskCubit>().addTask(
                  _taskController.text.trim(),
                  "مهمة مضافة محلياً",
                  "الآن",
                );
                _taskController.clear();
                FocusScope.of(context).unfocus(); // إغلاق الكيبورد بعد الإضافة
              }
            },
            child: Container(
              width: screenWidth * 0.12, // يعتمد على عرض الشاشة بدلاً من 48
              height: screenWidth * 0.12,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary, // الأزرق أو السماوي حسب الثيم
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

          // TextFormField
          Expanded(
            child: TextFormField(
              controller: _taskController,
              // تم ترك الـ InputDecoration شبه فارغ لأن الثيم في app_theme.dart سيتكفل بالباقي
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
      physics: NeverScrollableScrollPhysics(),
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
                      ) // الأخضر
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
    // اللون البنفسجي المميز في الصورة
    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: ColorsManager.purple,
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
                state
                        is TasksLoaded // التعديل هنا
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
                      color: ColorsManager.purple.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        size: screenWidth * 0.06,
                        color: ColorsManager.white,
                      ),
                      onPressed: () {
                        context.read<TaskCubit>().stopTimer();
                      },
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.06),
                  Container(
                    width:
                        screenWidth *
                        0.14, // حجم زر التشغيل يعتمد على الميديا كويري
                    height: screenWidth * 0.14,
                    decoration: BoxDecoration(
                      color: ColorsManager.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        state
                                is TasksLoaded // التعديل هنا
                            ? state.isRunning
                                  ? Icons.pause
                                  : Icons.play_arrow_rounded
                            : Icons.play_arrow_rounded,

                        color: ColorsManager.purple,
                        size: screenWidth * 0.08,
                      ),
                      onPressed: () {
                        context.read<TaskCubit>().startTimer();
                      },
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
