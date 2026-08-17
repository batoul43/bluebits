import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:bluebits_app/features/schedule_setting/presentation/logic/schedule_setting_cubit.dart';
// تأكد من صحة مسارات الاستيراد هذه حسب بنية مشروعك
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_result_model.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_solve_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleSettingsScreen extends StatefulWidget {
  const ScheduleSettingsScreen({super.key});

  @override
  State<ScheduleSettingsScreen> createState() => _ScheduleSettingsScreenState();
}

class _ScheduleSettingsScreenState extends State<ScheduleSettingsScreen> {
  String? selectedSemesterId;

  // متغير للتحكم في تسلسل عملية الـ Solve وإظهار مؤشر التحميل
  bool _isSolvingSequence = false;

  @override
  void initState() {
    super.initState();
    context.read<SemesterCubit>().fetchAllSemesters();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 600;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'إعدادات الجدولة',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ScheduleSettingCubit, ScheduleSettingState>(
            listener: (context, state) {
              // --- معالجة التسلسل الخاص بزر Solve ---
              if (state is ScheduleConflictLoaded && _isSolvingSequence) {
                try {
                  final Map<String, dynamic> timefoldData =
                      (state.scheduleConflict as dynamic).toJson();
                  context.read<ScheduleSettingCubit>().solveTimefold(
                    timefoldData,
                  );
                } catch (e) {
                  _showSnackBar(
                    context,
                    'خطأ في تحويل بيانات Timefold',
                    theme.colorScheme.error,
                  );
                  setState(() => _isSolvingSequence = false);
                }
              } else if (state is ScheduleSolvetimefoldLoaded &&
                  _isSolvingSequence) {
                context.read<ScheduleSettingCubit>().solveSchedule(
                  "6a37ceda7e2759fcacd44d81",
                  "2026-2027",
                );
              } else if (state is ScheduleSolveLoaded && _isSolvingSequence) {
                setState(() => _isSolvingSequence = false);
                _showSnackBar(
                  context,
                  'تمت عملية الجدولة (Solve) بنجاح!',
                  Colors.green,
                );
              }
              // --- معالجة عرض النتائج (Result) ---
              else if (state is ScheduleResultLoaded) {
                _showResultDialog(context, state.scheduleResultModel);
              }
              // --- معالجة النشر (Publish) ---
              else if (state is SchedulePublishLoaded) {
                _showSnackBar(
                  context,
                  'تم نشر الجدول للطلاب بنجاح!',
                  Colors.green,
                );
              }
              // --- الحالات العامة للإعدادات ---
              else if (state is ScheduleSettingActionResult) {
                _showSnackBar(context, state.message, Colors.green);
                _refreshCurrentSemester();
              } else if (state is UpdateScheduleConfig) {
                _showSnackBar(context, 'تم التحديث بنجاح', Colors.green);
                _refreshCurrentSemester();
              } else if (state is DeleteSuccess) {
                _showSnackBar(context, state.message, theme.colorScheme.error);
                setState(() => selectedSemesterId = null);
              } else if (state is ScheduleSettingError) {
                setState(() => _isSolvingSequence = false);
                _showSnackBar(context, state.message, theme.colorScheme.error);
              }
            },
          ),
        ],
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32.0 : 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _showSettingsDialog(context),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('إنشاء إعدادات جديدة'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSemesterDropdown(theme),
                  const SizedBox(height: 24),
                  Expanded(child: _buildSettingsContent(theme)),

                  // --- أزرار العمليات (Solve, Result, Publish) ---
                  if (selectedSemesterId != null) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildOperationButtons(context, theme),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _refreshCurrentSemester() {
    if (selectedSemesterId != null) {
      context.read<ScheduleSettingCubit>().getSettingPerSemester(
        selectedSemesterId,
      );
    }
  }

  Widget _buildOperationButtons(BuildContext context, ThemeData theme) {
    return BlocBuilder<ScheduleSettingCubit, ScheduleSettingState>(
      builder: (context, state) {
        final isLoading = state is ScheduleSettingLoading || _isSolvingSequence;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            _buildActionButton(
              label: _isSolvingSequence ? 'جاري الحل...' : 'Solve',
              icon: Icons.auto_awesome,
              color: theme.colorScheme.primary,
              textColor: theme.colorScheme.onPrimary,
              isLoading: _isSolvingSequence,
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() => _isSolvingSequence = true);
                      context.read<ScheduleSettingCubit>().generateScheduleData(
                        selectedSemesterId!,
                      );
                    },
            ),
            _buildActionButton(
              label: 'Result',
              icon: Icons.table_chart_rounded,
              color: Colors.orange.shade700,
              textColor: Colors.white,
              isLoading:
                  isLoading &&
                  !_isSolvingSequence &&
                  state is! ScheduleSettingLoading,
              onPressed: isLoading
                  ? null
                  : () {
                      context.read<ScheduleSettingCubit>().getScheduleResult(
                        selectedSemesterId!,
                      );
                    },
            ),
            _buildActionButton(
              label: 'Publish',
              icon: Icons.campaign_rounded,
              color: Colors.green.shade700,
              textColor: Colors.white,
              isLoading: false,
              onPressed: isLoading
                  ? null
                  : () {
                      _confirmPublish(context, theme);
                    },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return SizedBox(
      width: 150,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        onPressed: onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2,
                ),
              )
            : Icon(icon, size: 20, color: textColor),
        label: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }

  // --- تم تحديث هذه الدالة بالكامل بناءً على بياناتك ---
  void _showResultDialog(BuildContext context, dynamic resultModel) {
    // استخراج القائمة من timetable وتحديد نوعها
    final ScheduleResultModel result = resultModel as ScheduleResultModel;
    final List<TimetableItem> scheduleItems = result.data?.timetable ?? [];

    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 600;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: isDesktop ? 900 : size.width * 0.95,
          constraints: BoxConstraints(maxHeight: size.height * 0.85),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.table_chart, color: Colors.orange.shade700),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            'نتيجة الجدولة',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.iconTheme.color),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: scheduleItems.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد بيانات لعرضها',
                          style: theme.textTheme.bodyLarge,
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(
                              theme.colorScheme.primary.withOpacity(0.1),
                            ),
                            columns: [
                              DataColumn(
                                label: Text(
                                  'المادة',
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'التاريخ',
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'الفترة',
                                  style: theme.textTheme.titleSmall,
                                ),
                              ),
                            ],
                            rows: scheduleItems.map((item) {
                              // استخدام خصائص الكائن item بدلاً من الـ Map
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(
                                      item.subjectName ?? '-',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      item.examDate ?? '-',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      item.timeslot?.toString() ?? '-',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmPublish(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('تأكيد النشر', style: theme.textTheme.titleLarge),
        content: Text(
          'هل أنت متأكد من نشر الجدول؟ سيصبح متاحاً للطلاب لرؤيته.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ScheduleSettingCubit>().getSchedulePublish(
                selectedSemesterId!,
              );
            },
            child: const Text('نشر', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterDropdown(ThemeData theme) {
    return BlocBuilder<SemesterCubit, SemesterState>(
      builder: (context, state) {
        if (state is SemesterLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SemesterLoaded) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'اختر الفصل الدراسي',
              hintText: 'اضغط لاختيار الفصل من القائمة',
              prefixIcon: Icon(
                Icons.calendar_month,
                color: theme.colorScheme.primary,
              ),
            ),
            dropdownColor: theme.colorScheme.surface,
            value: selectedSemesterId,
            items: state.semesters.map((semester) {
              return DropdownMenuItem<String>(
                value: semester.id,
                child: Text(
                  semester.name ?? 'فصل غير مسمى',
                  style: theme.textTheme.bodyLarge,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedSemesterId = value);
              if (value != null) {
                context.read<ScheduleSettingCubit>().getSettingPerSemester(
                  value,
                );
              }
            },
          );
        } else if (state is SemesterError) {
          return Text(
            'خطأ: ${state.message}',
            style: TextStyle(color: theme.colorScheme.error),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSettingsContent(ThemeData theme) {
    return BlocBuilder<ScheduleSettingCubit, ScheduleSettingState>(
      buildWhen: (previous, current) =>
          current is SettingPerSemesterLoaded ||
          current is ScheduleSettingLoading,
      builder: (context, state) {
        if (selectedSemesterId == null) {
          return _buildEmptyState('يرجى اختيار فصل دراسي لعرض إعداداته', theme);
        }

        if (state is ScheduleSettingLoading && !_isSolvingSequence) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SettingPerSemesterLoaded) {
          final config = state.settingPerSemesterModel.data;
          if (config == null) {
            return _buildEmptyState('لا توجد إعدادات لهذا الفصل.', theme);
          }

          final configId = (config as dynamic).sId ?? (config as dynamic).id;

          return SingleChildScrollView(
            child: Card(
              color: theme.colorScheme.surface,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تفاصيل الإعدادات',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () => _showSettingsDialog(
                                context,
                                existingData: config,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: () =>
                                  _confirmDelete(context, configId, theme),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 30),
                    _buildInfoRow(
                      'العام الدراسي:',
                      config.academicYear ?? '',
                      theme,
                    ),
                    _buildInfoRow(
                      'تاريخ البداية:',
                      config.startDate ?? '',
                      theme,
                    ),
                    _buildInfoRow(
                      'تاريخ النهاية:',
                      config.endDate ?? '',
                      theme,
                    ),
                    _buildInfoRow(
                      'الفترات يومياً:',
                      '${config.timeslotsPerDay ?? 0}',
                      theme,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: theme.textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.settings_suggest,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String? configId, ThemeData theme) {
    if (configId == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('تأكيد الحذف', style: theme.textTheme.titleLarge),
        content: Text(
          'هل أنت متأكد من حذف هذه الإعدادات؟',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'إلغاء',
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ScheduleSettingCubit>().deleteScheduleConfig(
                configId,
              );
            },
            child: Text(
              'حذف',
              style: TextStyle(color: theme.colorScheme.onError),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, {dynamic existingData}) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 600;
    final theme = Theme.of(context);

    // 1. التقاط الـ Cubits من السياق الحالي (قبل فتح الـ Dialog)
    final semesterCubit = context.read<SemesterCubit>();
    final scheduleSettingCubit = context.read<ScheduleSettingCubit>();

    // القيم المبدئية
    String? dialogSelectedSemesterId = existingData?.semesterId is String
        ? existingData?.semesterId
        : (existingData?.semesterId?.sId ??
              existingData?.semesterId?.id ??
              selectedSemesterId);

    final academicYearCtrl = TextEditingController(
      text: existingData?.academicYear ?? '2025-2026',
    );
    final startDateCtrl = TextEditingController(
      text: existingData?.startDate ?? '',
    );
    final endDateCtrl = TextEditingController(
      text: existingData?.endDate ?? '',
    );
    final timeslotsCtrl = TextEditingController(
      text: existingData?.timeslotsPerDay?.toString() ?? '3',
    );

    showDialog(
      context: context,
      builder: (ctx) => MultiBlocProvider(
        // 2. تمرير الـ Cubits عبر MultiBlocProvider
        providers: [
          BlocProvider.value(value: semesterCubit),
          BlocProvider.value(value: scheduleSettingCubit),
        ],
        child: Dialog(
          insetPadding: const EdgeInsets.all(16),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Container(
                width: isDesktop ? 550 : size.width * 0.95,
                constraints: BoxConstraints(maxHeight: size.height * 0.85),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // الهيدر
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              existingData == null
                                  ? 'إنشاء إعدادات جديدة'
                                  : 'تعديل الإعدادات',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: theme.iconTheme.color,
                            ),
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ],
                      ),
                    ),
                    // الحقول
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            BlocBuilder<SemesterCubit, SemesterState>(
                              builder: (context, state) {
                                if (state is SemesterLoaded) {
                                  final isValueValid = state.semesters.any(
                                    (s) => s.id == dialogSelectedSemesterId,
                                  );

                                  return DropdownButtonFormField<String>(
                                    value: isValueValid
                                        ? dialogSelectedSemesterId
                                        : null,
                                    dropdownColor: theme.colorScheme.surface,
                                    decoration: InputDecoration(
                                      labelText: 'الفصل الدراسي',
                                      hintText: 'اختر الفصل الدراسي من القائمة',
                                      prefixIcon: Icon(
                                        Icons.school,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    items: state.semesters.map((semester) {
                                      return DropdownMenuItem<String>(
                                        value: semester.id,
                                        child: Text(
                                          semester.name ?? 'فصل غير مسمى',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setStateDialog(
                                        () => dialogSelectedSemesterId = value,
                                      );
                                    },
                                  );
                                } else if (state is SemesterLoading) {
                                  return const CircularProgressIndicator();
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: academicYearCtrl,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'العام الدراسي',
                                hintText: 'مثال: 2025-2026',
                                prefixIcon: Icon(
                                  Icons.date_range,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: startDateCtrl,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'تاريخ البداية',
                                hintText: 'اختر تاريخ بدء الفصل',
                                prefixIcon: Icon(
                                  Icons.calendar_month,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context, startDateCtrl),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: endDateCtrl,
                              style: theme.textTheme.bodyLarge,
                              decoration: InputDecoration(
                                labelText: 'تاريخ النهاية',
                                hintText: 'اختر تاريخ نهاية الفصل',
                                prefixIcon: Icon(
                                  Icons.event_busy,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context, endDateCtrl),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: timeslotsCtrl,
                              style: theme.textTheme.bodyLarge,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'عدد الفترات يومياً',
                                hintText: 'مثال: 3',
                                prefixIcon: Icon(
                                  Icons.access_time,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // أزرار الحفظ
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                foregroundColor: theme.colorScheme.onPrimary,
                              ),
                              onPressed: () {
                                if (dialogSelectedSemesterId == null) {
                                  _showSnackBar(
                                    context,
                                    'يرجى اختيار الفصل الدراسي أولاً',
                                    theme.colorScheme.error,
                                  );
                                  return;
                                }

                                final configData = {
                                  "semesterId": dialogSelectedSemesterId,
                                  "academicYear": academicYearCtrl.text,
                                  "startDate": startDateCtrl.text,
                                  "endDate": endDateCtrl.text,
                                  "excludedDates": ["2026-07-05"],
                                  "excludedDaysOfWeek": [5, 6],
                                  "timeslotsPerDay":
                                      int.tryParse(timeslotsCtrl.text) ?? 3,
                                  "subjectsConfig": [
                                    {
                                      "subjectId": "6a3d2d9bedcb44989eaa5e37",
                                      "carriedStudentsCount": 45,
                                      "examDurationOverride": 120,
                                    },
                                  ],
                                };

                                Navigator.pop(ctx);
                                if (existingData == null) {
                                  context
                                      .read<ScheduleSettingCubit>()
                                      .createConfig(configData);
                                } else {
                                  final targetId =
                                      (existingData as dynamic).sId ??
                                      (existingData as dynamic).id;
                                  context
                                      .read<ScheduleSettingCubit>()
                                      .updateScheduleConfig(
                                        targetId,
                                        configData,
                                      );
                                }
                              },
                              child: Text(
                                existingData == null ? 'إنشاء' : 'حفظ',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
