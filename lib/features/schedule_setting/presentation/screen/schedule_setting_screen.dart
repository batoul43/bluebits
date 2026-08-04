import 'dart:convert'; // تمت الإضافة من أجل تنسيق الـ JSON

import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/schedule_setting/presentation/logic/schedule_setting_cubit.dart';
import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleManagementScreen extends StatefulWidget {
  const ScheduleManagementScreen({super.key});

  @override
  State<ScheduleManagementScreen> createState() =>
      _ScheduleManagementScreenState();
}

class _ScheduleManagementScreenState extends State<ScheduleManagementScreen> {
  String? selectedSemesterId;
  String currentAcademicYear = "2025-2026";

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    // استدعاء الفصول الدراسية للعرض عند بدء الشاشة
    // يرجى التأكد من اسم الدالة المسؤولة عن جلب الفصول في SemesterCubit
    // (مثلاً getSemesters() أو fetchAllSemesters())
    context.read<SemesterCubit>().fetchAllSemesters();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text("إدارة الجدولة"), centerTitle: true),
        body: BlocConsumer<ScheduleSettingCubit, ScheduleSettingState>(
          listener: (context, state) {
            if (state is ScheduleSettingError) {
              _showSnackBar(context, state.message, ColorsManager.redaccent);
            } else if (state is ScheduleSettingActionResult) {
              _showSnackBar(context, state.message, ColorsManager.green);
            } else if (state is DeleteSuccess) {
              _showSnackBar(context, state.message, ColorsManager.green);
              setState(() => selectedSemesterId = null);
            } else if (state is ScheduleConflictLoaded) {
              _showSnackBar(
                context,
                "تم توليد البيانات بنجاح",
                ColorsManager.green,
              );
            } else if (state is ScheduleSolvetimefoldLoaded) {
              _showSnackBar(
                context,
                "تم حل التعارضات مبدئياً",
                ColorsManager.green,
              );
            } else if (state is ScheduleSolveLoaded) {
              _showSnackBar(
                context,
                "تم بناء الجدول الزمني بنجاح",
                ColorsManager.green,
              );
            } else if (state is SchedulePublishLoaded) {
              _showSnackBar(
                context,
                "تم نشر الجدول للطلاب بنجاح!",
                ColorsManager.blue,
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. قسم اختيار الفصل الدراسي
                      _buildSectionTitle("الفصل الدراسي", theme),
                      const SizedBox(height: 10),
                      _buildSemesterDropdown(theme),
                      const SizedBox(height: 20),

                      // 2. قسم اختيار تواريخ الامتحانات (المطلوبة للـ API)
                      _buildSectionTitle("تواريخ الامتحانات", theme),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDatePickerCard(
                              title: "تاريخ البدء",
                              selectedDate: startDate,
                              icon: Icons.calendar_today,
                              onTap: () =>
                                  _pickDate(context, isStartDate: true),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildDatePickerCard(
                              title: "تاريخ الانتهاء",
                              selectedDate: endDate,
                              icon: Icons.event_available,
                              onTap: () =>
                                  _pickDate(context, isStartDate: false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // 3. زر إنشاء الإعدادات
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed:
                              (selectedSemesterId == null ||
                                  startDate == null ||
                                  endDate == null)
                              ? null
                              : () {
                                  // تجهيز البيانات بالهيكل المطلوب
                                  final configData = {
                                    "semesterId": selectedSemesterId,
                                    "academicYear": currentAcademicYear,
                                    "startDate":
                                        "${startDate!.year}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
                                    "endDate":
                                        "${endDate!.year}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
                                    "excludedDates": ["2026-07-05"],
                                    "excludedDaysOfWeek": [5, 6],
                                    "timeslotsPerDay": 3,
                                    "subjectsConfig": [
                                      {
                                        "subjectId": "a9806d537a1d6c94cafd6248",
                                        "carriedStudentsCount": 5,
                                        "examDurationOverride": 120,
                                      },
                                      {
                                        "subjectId": "f25686320661e6ec3cdd413c",
                                        "carriedStudentsCount": 5,
                                        "examDurationOverride": 90,
                                      },
                                    ],
                                  };

                                  // عرض نافذة التأكيد قبل الإرسال
                                  _showCreateConfirmationDialog(
                                    context,
                                    configData,
                                  );
                                },
                          icon: const Icon(Icons.add_chart),
                          label: const Text(
                            "إنشاء إعدادات جديدة للجدولة",
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // 4. أزرار إدارة إعدادات الفصل وخطوات المعالجة
                      if (selectedSemesterId != null) ...[
                        _buildConfigActionButtons(context),
                        const Divider(height: 40, thickness: 1),
                        _buildSectionTitle("خطوات معالجة الجدول", theme),
                        const SizedBox(height: 15),
                        _buildProcessPipeline(context, state, isDark),
                      ] else ...[
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            "يرجى اختيار الفصل الدراسي وتواريخ الامتحانات للبدء",
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                if (state is ScheduleSettingLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: ColorsManager.blue,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ---- مكونات الواجهة (Widgets) ----

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        color: ColorsManager.blue,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSemesterDropdown(ThemeData theme) {
    return BlocBuilder<SemesterCubit, SemesterState>(
      builder: (context, semesterState) {
        if (semesterState.runtimeType.toString().contains('Loading')) {
          return const Center(child: CircularProgressIndicator());
        }

        List<dynamic> semesterList = [];

        try {
          semesterList =
              (semesterState as dynamic).data ??
              (semesterState as dynamic).semesters ??
              [];
        } catch (e) {
          // تجاهل الخطأ
        }

        if (semesterList.isEmpty) {
          return DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: "لا يوجد فصول دراسية متاحة",
              prefixIcon: Icon(Icons.school_outlined),
            ),
            items: const [],
            onChanged: null,
          );
        }

        return DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: "اختر الفصل الدراسي",
            prefixIcon: Icon(Icons.school_outlined),
          ),
          value: selectedSemesterId,
          items: semesterList.map((semester) {
            final id = (semester.id ?? '').toString();
            final name = (semester.name ?? semester.nameAr ?? "فصل بدون اسم")
                .toString();

            return DropdownMenuItem<String>(value: id, child: Text(name));
          }).toList(),
          onChanged: (val) {
            setState(() {
              selectedSemesterId = val;
            });
          },
        );
      },
    );
  }

  Widget _buildDatePickerCard({
    required String title,
    required DateTime? selectedDate,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: ColorsManager.blue),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              selectedDate == null
                  ? "اختر التاريخ"
                  : "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: selectedDate == null
                    ? FontWeight.normal
                    : FontWeight.bold,
                color: selectedDate == null ? Colors.grey : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined),
            label: const Text("تعديل الإعدادات"),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorsManager.orange,
              side: const BorderSide(color: ColorsManager.orange),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmation(context),
            icon: const Icon(Icons.delete_outline),
            label: const Text("حذف الإعدادات"),
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorsManager.redaccent,
              side: const BorderSide(color: ColorsManager.redaccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessPipeline(
    BuildContext context,
    ScheduleSettingState state,
    bool isDark,
  ) {
    final cubit = context.read<ScheduleSettingCubit>();
    return Column(
      children: [
        _ActionStepCard(
          title: "توليد البيانات",
          description: "جمع بيانات الطلاب، المواد، والتعارضات الأولية.",
          icon: Icons.data_usage_rounded,
          buttonText: "توليد (Generate)",
          onPressed: () {
            if (selectedSemesterId != null)
              cubit.generateScheduleData(selectedSemesterId!);
          },
          isDark: isDark,
        ),
        _ActionStepCard(
          title: "معالجة Timefold",
          description: "حل التعارضات المعقدة وتحسين الجدولة برمجياً.",
          icon: Icons.psychology_outlined,
          buttonText: "تشغيل Timefold",
          onPressed: () {
            if (selectedSemesterId != null) {
              cubit.solveTimefold({
                "semesterId": selectedSemesterId,
                "academicYear": currentAcademicYear,
              });
            }
          },
          isDark: isDark,
        ),
        _ActionStepCard(
          title: "بناء الجدول (Solve)",
          description: "تسكين المواد في الأيام والفترات الزمنية المتاحة.",
          icon: Icons.build_circle_outlined,
          buttonText: "بناء (Solve)",
          onPressed: () {
            if (selectedSemesterId != null)
              cubit.solveSchedule(selectedSemesterId, currentAcademicYear);
          },
          isDark: isDark,
        ),
        _ActionStepCard(
          title: "عرض النتيجة",
          description: "مراجعة الجدول الزمني قبل نشره للطلاب.",
          icon: Icons.preview_outlined,
          buttonText: "عرض (Result)",
          onPressed: () {
            if (selectedSemesterId != null)
              cubit.getScheduleResult(selectedSemesterId!);
          },
          isDark: isDark,
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: () {
              if (selectedSemesterId != null)
                _showPublishConfirmation(context, cubit);
            },
            icon: const Icon(Icons.rocket_launch, color: Colors.white),
            label: const Text(
              "نشر الجدول للطلاب (Publish)",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.green,
            ),
          ),
        ),
      ],
    );
  }

  // ---- الدوال المساعدة ----

  // دالة عرض النافذة المنبثقة للتأكيد قبل إرسال البيانات
  void _showCreateConfirmationDialog(
    BuildContext context,
    Map<String, dynamic> bodyPayload,
  ) {
    // تنسيق الـ JSON ليظهر بشكل جميل
    final String prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(bodyPayload);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.data_object, color: ColorsManager.blue),
            const SizedBox(width: 10),
            const Text("تأكيد إرسال الجدولة", style: TextStyle(fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "يرجى مراجعة البيانات قبل إنشاء الجدولة:",
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 15),
              // مربع عرض الكود JSON
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                ),
                child: SelectableText(
                  prettyJson,
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              // استدعاء دالة الإنشاء من الـ Cubit
              context.read<ScheduleSettingCubit>().createConfig(bodyPayload);
            },
            child: const Text("تأكيد وإرسال"),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final initialDate = isStartDate
        ? (startDate ?? DateTime.now())
        : (endDate ?? (startDate ?? DateTime.now()));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: ColorsManager.blue),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          if (startDate != null && pickedDate.isBefore(startDate!)) {
            _showSnackBar(
              context,
              "تاريخ الانتهاء لا يمكن أن يكون قبل تاريخ البدء",
              ColorsManager.redaccent,
            );
          } else {
            endDate = pickedDate;
          }
        }
      });
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("تأكيد الحذف"),
        content: const Text(
          "هل أنت متأكد من حذف إعدادات الجدولة لهذا الفصل؟ لا يمكن التراجع عن هذا الإجراء.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.redaccent,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (selectedSemesterId != null) {
                context.read<ScheduleSettingCubit>().deleteScheduleConfig(
                  selectedSemesterId!,
                );
              }
            },
            child: const Text("حذف", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPublishConfirmation(
    BuildContext context,
    ScheduleSettingCubit cubit,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("تأكيد النشر"),
        content: const Text(
          "هل أنت متأكد من نشر هذا الجدول؟ سيظهر مباشرة في تطبيق الطلاب.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsManager.green,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              if (selectedSemesterId != null)
                cubit.getSchedulePublish(selectedSemesterId!);
            },
            child: const Text(
              "تأكيد النشر",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _ActionStepCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final String buttonText;
  final VoidCallback onPressed;
  final bool isDark;

  const _ActionStepCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.buttonText,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? ColorsManager.deepNavy : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? Colors.transparent : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorsManager.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: ColorsManager.blue, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? ColorsManager.darkGreyText
                          : ColorsManager.greyText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
