import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_solve_model.dart';
import 'package:bluebits_app/features/schedule_setting/presentation/logic/schedule_setting_cubit.dart';
import 'package:bluebits_app/features/schedule_setting/data/models/schedule_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ActiveAction { none, solve, result, publish }

class ScheduleSettingsScreen extends StatefulWidget {
  const ScheduleSettingsScreen({super.key});

  @override
  State<ScheduleSettingsScreen> createState() => _ScheduleSettingsScreenState();
}

class _ScheduleSettingsScreenState extends State<ScheduleSettingsScreen> {
  String? selectedSemesterId;
  ActiveAction _activeAction = ActiveAction.none;
  String _currentAcademicYear = "2026-2027";
  dynamic _currentSettings;

  bool _isLoadingSettings = false;
  String? _settingsError;

  @override
  void initState() {
    super.initState();
    context.read<SemesterCubit>().fetchAllSemesters();
    context.read<SubjectCubit>().getAllSubjects();
  }

  void _clearLoading() {
    if (mounted) {
      setState(() => _activeAction = ActiveAction.none);
    }
  }

  void _refreshCurrentSemester() {
    if (selectedSemesterId != null) {
      setState(() {
        _isLoadingSettings = true;
        _settingsError = null;
      });
      context.read<ScheduleSettingCubit>().getSettingPerSemester(
        selectedSemesterId!,
      );
    }
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
      body: BlocListener<ScheduleSettingCubit, ScheduleSettingState>(
        listener: (context, state) {
          if (_activeAction == ActiveAction.solve) {
            if (state is ScheduleConflictLoaded) {
              try {
                final Map<String, dynamic> timefoldData =
                    (state.scheduleConflict as dynamic).toJson();
                context.read<ScheduleSettingCubit>().solveTimefold(
                  timefoldData,
                );
              } catch (e) {
                _showSnackBar(
                  context,
                  'خطأ في تحويل بيانات Timefold: $e',
                  theme.colorScheme.error,
                );
                _clearLoading();
              }
            } else if (state is ScheduleSolvetimefoldLoaded) {
              context.read<ScheduleSettingCubit>().solveSchedule(
                selectedSemesterId ?? "",
                _currentAcademicYear,
              );
            } else if (state is ScheduleSolveLoaded) {
              _clearLoading();
              _showSnackBar(
                context,
                'تمت عملية الجدولة (Solve) بنجاح!',
                Colors.green,
              );
              if (selectedSemesterId != null) {
                context.read<ScheduleSettingCubit>().getScheduleResult(
                  selectedSemesterId!,
                );
              }
            } else if (state is ScheduleSettingError) {
              _clearLoading();
              _showSnackBar(context, state.message, theme.colorScheme.error);
            }
          } else {
            if (state is ScheduleResultLoaded) {
              _clearLoading();
              _showResultDialog(context, state.scheduleResultModel);
            } else if (state is SchedulePublishLoaded) {
              _clearLoading();
              _showSnackBar(
                context,
                'تم نشر الجدول للطلاب بنجاح!',
                Colors.green,
              );
              _refreshCurrentSemester();
            } else if (state is SettingPerSemesterLoaded) {
              setState(() {
                _isLoadingSettings = false;
                _settingsError = null;
                _currentSettings = state.settingPerSemesterModel;
              });
              final config = state.settingPerSemesterModel.data;
              if (config != null && (config as dynamic).academicYear != null) {
                _currentAcademicYear = (config as dynamic).academicYear
                    .toString();
              }
            } else if (state is ScheduleSettingActionResult) {
              _showSnackBar(context, state.message, Colors.green);
              _refreshCurrentSemester();
            } else if (state is UpdateScheduleConfig) {
              _showSnackBar(context, 'تم التحديث بنجاح', Colors.green);
              _refreshCurrentSemester();
            } else if (state is DeleteSuccess) {
              _showSnackBar(context, state.message, theme.colorScheme.error);
              setState(() {
                selectedSemesterId = null;
                _currentSettings = null;
              });
            } else if (state is ScheduleSettingError) {
              _clearLoading();
              _showSnackBar(context, state.message, theme.colorScheme.error);
              if (_isLoadingSettings) {
                setState(() {
                  _isLoadingSettings = false;
                  _settingsError = state.message;
                });
              }
            }
          }
        },
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSemesterDropdown(theme),
                  const SizedBox(height: 24),
                  Expanded(child: _buildSettingsContent(theme)),
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

  Widget _buildOperationButtons(BuildContext context, ThemeData theme) {
    final isBusy = _activeAction != ActiveAction.none;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _buildActionButton(
          label: 'Solve',
          icon: Icons.auto_awesome,
          color: theme.colorScheme.primary,
          textColor: theme.colorScheme.onPrimary,
          isLoading: _activeAction == ActiveAction.solve,
          onPressed: isBusy
              ? null
              : () {
                  setState(() => _activeAction = ActiveAction.solve);
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
          isLoading: _activeAction == ActiveAction.result,
          onPressed: isBusy
              ? null
              : () {
                  setState(() => _activeAction = ActiveAction.result);
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
          isLoading: _activeAction == ActiveAction.publish,
          onPressed: isBusy ? null : () => _confirmPublish(context, theme),
        ),
      ],
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
          disabledBackgroundColor: color.withOpacity(0.6),
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
                  strokeWidth: 2.5,
                ),
              )
            : Icon(icon, size: 20, color: textColor),
        label: Text(
          isLoading ? 'جاري التحميل...' : label,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return '-';
    try {
      final parsedDate = DateTime.parse(rawDate);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return rawDate;
    }
  }

  void _showResultDialog(BuildContext context, ScheduleResultModel result) {
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
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.table_chart_rounded,
                          color: Colors.orange.shade700,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'نتيجة الجدولة النهائية',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'إجمالي الامتحانات: ${scheduleItems.length}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: theme.iconTheme.color),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Expanded(
                child: scheduleItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 64,
                              color: theme.hintColor.withOpacity(0.4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد بيانات جدولة متاحة حالياً',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: theme.dividerColor.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DataTable(
                                  headingRowHeight: 48,
                                  dataRowMaxHeight: 56,
                                  horizontalMargin: 20,
                                  columnSpacing: 28,
                                  headingRowColor: WidgetStateProperty.all(
                                    theme.colorScheme.primary.withOpacity(0.08),
                                  ),
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        '#',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'المادة الدراسية',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'تاريخ الامتحان',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'الفترة الزمنية',
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: theme.colorScheme.primary,
                                            ),
                                      ),
                                    ),
                                  ],
                                  rows: scheduleItems.asMap().entries.map((
                                    entry,
                                  ) {
                                    final index = entry.key + 1;
                                    final item = entry.value;
                                    final isEven = index % 2 == 0;

                                    return DataRow(
                                      color: WidgetStateProperty.all(
                                        isEven
                                            ? theme.colorScheme.surface
                                            : theme.colorScheme.primary
                                                  .withOpacity(0.02),
                                      ),
                                      cells: [
                                        DataCell(
                                          Text(
                                            '$index',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.hintColor,
                                                ),
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.book_outlined,
                                                size: 18,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                item.subjectName?.toString() ??
                                                    '-',
                                                style: theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.calendar_month_outlined,
                                                size: 16,
                                                color: Colors.blueGrey,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _formatDate(item.examDate),
                                                style:
                                                    theme.textTheme.bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.access_time_rounded,
                                                  size: 14,
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  item.timeslot?.toString() ??
                                                      '-',
                                                  style: theme
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                        color: theme
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
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
              setState(() => _activeAction = ActiveAction.publish);
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
          final isValueValid =
              selectedSemesterId == null ||
              state.semesters.any((s) => s.id == selectedSemesterId);

          return DropdownButtonFormField<String>(
            isExpanded: true,
            menuMaxHeight: 300,
            decoration: InputDecoration(
              labelText: 'اختر الفصل الدراسي',
              hintText: 'اضغط لاختيار الفصل من القائمة',
              prefixIcon: Icon(
                Icons.calendar_month,
                color: theme.colorScheme.primary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            dropdownColor: theme.colorScheme.surface,
            value: isValueValid ? selectedSemesterId : null,
            items: state.semesters.map((semester) {
              return DropdownMenuItem<String>(
                value: semester.id,
                child: Text(
                  semester.name ?? 'فصل غير مسمى',
                  style: theme.textTheme.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSemesterId = value;
                _currentSettings = null;
                _settingsError = null;
                if (value != null) {
                  _isLoadingSettings = true;
                }
              });
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
    if (selectedSemesterId == null) {
      return _buildEmptyState('يرجى اختيار فصل دراسي لعرض إعداداته', theme);
    }

    if (_isLoadingSettings) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_settingsError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            // const SizedBox(height: 16),
            // Text(
            //   'عذراً، حدث خطأ',
            //   style: theme.textTheme.titleLarge?.copyWith(
            //     color: theme.colorScheme.error,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(height: 8),
            _buildEmptyState('لا توجد إعدادات لهذا الفصل.', theme),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 24),
            //   child: Text(
            //     _settingsError!,
            //     style: theme.textTheme.bodyMedium,
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // const SizedBox(height: 24),
            // ElevatedButton.icon(
            //   onPressed: _refreshCurrentSemester,
            //   icon: const Icon(Icons.refresh),
            //   label: const Text('إعادة المحاولة'),
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 24,
            //       vertical: 12,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    }

    if (_currentSettings == null) {
      return _buildEmptyState('لا توجد إعدادات لهذا الفصل.', theme);
    }

    final config = _currentSettings!.data;
    if (config == null) {
      return _buildEmptyState('لا توجد إعدادات لهذا الفصل.', theme);
    }

    final configId = (config as dynamic).sId ?? (config as dynamic).id;
    // جلب قائمة المواد المثبتة لكي نعرضها في قسم مخصص
    final List<dynamic> subjectsList =
        (config as dynamic).subjectsConfig as List<dynamic>? ?? [];

    return SingleChildScrollView(
      child: Card(
        color: theme.colorScheme.surface,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                        onPressed: () =>
                            _showSettingsDialog(context, existingData: config),
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
                (config as dynamic).academicYear ?? '',
                theme,
              ),
              _buildInfoRow(
                'تاريخ البداية:',
                _formatDate((config as dynamic).startDate),
                theme,
              ),
              _buildInfoRow(
                'تاريخ النهاية:',
                _formatDate((config as dynamic).endDate),
                theme,
              ),
              _buildInfoRow(
                'الفترات يومياً:',
                '${(config as dynamic).timeslotsPerDay ?? 0}',
                theme,
              ),

              // تمت إضافة الكود الخاص بعرض قائمة المواد المثبتة هنا
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'المواد المثبتة (Subjects Config):',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              if (subjectsList.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'لم يتم إضافة أي مواد مثبتة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subjectsList.length,
                  itemBuilder: (context, index) {
                    final subjectItem = subjectsList[index];
                    final subInfo = (subjectItem as dynamic).subjectId;

                    String sName = 'غير معروف';
                    if (subInfo != null) {
                      try {
                        sName =
                            subInfo.name ?? subInfo.sId ?? subInfo.toString();
                      } catch (_) {
                        sName = subInfo.toString();
                      }
                    }

                    final count =
                        (subjectItem as dynamic).carriedStudentsCount ?? 0;
                    final duration =
                        (subjectItem as dynamic).examDurationOverride ?? 0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 0,
                      color: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: theme.dividerColor.withOpacity(0.5),
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.bookmark_added,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(
                          sName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'الطلاب المحملين: $count  |  المدة: $duration دقيقة',
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
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

  void _showAddSubjectDialog(
    BuildContext context,
    StateSetter parentSetState,
    List<Map<String, dynamic>> subjectsList,
    ThemeData theme,
    SubjectCubit subjectCubit,
  ) {
    final countCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String? selectedSubjectId;
    String? selectedSubjectName;

    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 600;

    showDialog(
      context: context,
      builder: (ctx) => BlocProvider.value(
        value: subjectCubit,
        child: StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'إضافة مادة مثبتة',
                style: theme.textTheme.titleLarge,
              ),
              content: SizedBox(
                width: isDesktop ? 500 : size.width * 0.9,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BlocBuilder<SubjectCubit, SubjectState>(
                        builder: (context, state) {
                          if (state is GetSubjectsLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else if (state is GetSubjectsSuccess) {
                            final subjects =
                                (state.subjectModel as dynamic).data
                                    as List<dynamic>? ??
                                [];

                            return DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'اختر المادة',
                                border: OutlineInputBorder(),
                              ),
                              value: selectedSubjectId,
                              items: subjects.map((sub) {
                                final id =
                                    (sub as dynamic).sId ?? (sub as dynamic).id;
                                final name =
                                    (sub as dynamic).name ?? 'مادة بدون اسم';
                                return DropdownMenuItem<String>(
                                  value: id.toString(),
                                  child: Text(name.toString()),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setDialogState(() {
                                  selectedSubjectId = val;

                                  // التعديل الذي قمنا به لضمان أمان التعيين وعدم انهيار التطبيق
                                  final matchingSubjects = subjects.where(
                                    (s) =>
                                        ((s as dynamic).sId ??
                                                (s as dynamic).id)
                                            .toString() ==
                                        val,
                                  );

                                  final selectedSub =
                                      matchingSubjects.isNotEmpty
                                      ? matchingSubjects.first
                                      : null;

                                  selectedSubjectName = selectedSub != null
                                      ? (selectedSub as dynamic).name
                                      : null;
                                });
                              },
                              validator: (val) => val == null || val.isEmpty
                                  ? 'يرجى اختيار المادة'
                                  : null,
                            );
                          } else if (state is GetSubjectsFailure) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Text(
                                'خطأ في جلب المواد: ${state.errorMessage}',
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: countCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'عدد الطلاب المحملين',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: durationCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'مدة الامتحان المخصصة (دقائق)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        selectedSubjectId != null) {
                      parentSetState(() {
                        subjectsList.add({
                          "subjectId": selectedSubjectId,
                          "subjectName":
                              selectedSubjectName ?? selectedSubjectId,
                          "carriedStudentsCount":
                              int.tryParse(countCtrl.text) ?? 0,
                          "examDurationOverride":
                              int.tryParse(durationCtrl.text) ?? 120,
                        });
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(
                    'إضافة',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context, {dynamic existingData}) {
    final size = MediaQuery.sizeOf(context);
    final isDesktop = size.width > 600;
    final theme = Theme.of(context);

    final semesterCubit = context.read<SemesterCubit>();
    final scheduleSettingCubit = context.read<ScheduleSettingCubit>();
    final subjectCubit = context.read<SubjectCubit>();

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

    List<Map<String, dynamic>> subjectsConfigList = [];
    if (existingData != null) {
      try {
        final dynamic existingSubjects =
            (existingData as dynamic).subjectsConfig;
        if (existingSubjects != null && existingSubjects is List) {
          subjectsConfigList = existingSubjects.map<Map<String, dynamic>>((e) {
            final subObj = (e as dynamic).subjectId;
            String sId = "";
            String sName = "";

            if (subObj is String) {
              sId = subObj;
              sName = (e as dynamic).subjectName ?? subObj;
            } else if (subObj != null) {
              try {
                sId = subObj.sId ?? subObj.id?.toString() ?? "";
                sName = subObj.name ?? (e as dynamic).subjectName ?? sId;
              } catch (_) {
                sId = subObj.toString();
                sName = (e as dynamic).subjectName ?? sId;
              }
            }

            return {
              "subjectId": sId,
              "subjectName": sName,
              "carriedStudentsCount": (e as dynamic).carriedStudentsCount ?? 0,
              "examDurationOverride": (e as dynamic).examDurationOverride ?? 0,
            };
          }).toList();
        }
      } catch (_) {}
    }

    showDialog(
      context: context,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: semesterCubit),
          BlocProvider.value(value: scheduleSettingCubit),
          BlocProvider.value(value: subjectCubit),
        ],
        child: Dialog(
          insetPadding: const EdgeInsets.all(16),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateDialog) {
              return Container(
                width: isDesktop ? 650 : size.width * 0.95,
                constraints: BoxConstraints(maxHeight: size.height * 0.9),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocBuilder<SemesterCubit, SemesterState>(
                              builder: (context, state) {
                                if (state is SemesterLoaded) {
                                  final isValueValid = state.semesters.any(
                                    (s) => s.id == dialogSelectedSemesterId,
                                  );
                                  return DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    menuMaxHeight: 300,
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
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    items: state.semesters.map((semester) {
                                      return DropdownMenuItem<String>(
                                        value: semester.id,
                                        child: Text(
                                          semester.name ?? 'فصل غير مسمى',
                                          style: theme.textTheme.bodyLarge,
                                          overflow: TextOverflow.ellipsis,
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            const Divider(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'المواد المثبتة',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _showAddSubjectDialog(
                                    context,
                                    setStateDialog,
                                    subjectsConfigList,
                                    theme,
                                    subjectCubit,
                                  ),
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('إضافة مادة'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (subjectsConfigList.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.05,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  'لم يتم إضافة أي مواد مثبتة بعد.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: theme.hintColor),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: subjectsConfigList.length,
                                itemBuilder: (context, index) {
                                  final subject = subjectsConfigList[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                        color: theme.dividerColor,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        'المادة: ${subject["subjectName"] ?? subject["subjectId"]}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'محملين: ${subject["carriedStudentsCount"]}  |  مدة: ${subject["examDurationOverride"]} دقيقة',
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: theme.colorScheme.error,
                                        ),
                                        onPressed: () {
                                          setStateDialog(() {
                                            subjectsConfigList.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                  fontSize: 16,
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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

                                final cleanSubjectsConfigList =
                                    subjectsConfigList.map((e) {
                                      return {
                                        "subjectId": e["subjectId"],
                                        "carriedStudentsCount":
                                            e["carriedStudentsCount"],
                                        "examDurationOverride":
                                            e["examDurationOverride"],
                                      };
                                    }).toList();

                                final configData = {
                                  "semesterId": dialogSelectedSemesterId,
                                  "academicYear": academicYearCtrl.text,
                                  "startDate": startDateCtrl.text,
                                  "endDate": endDateCtrl.text,
                                  "excludedDates": ["2026-07-05"],
                                  "excludedDaysOfWeek": [5, 6],
                                  "timeslotsPerDay":
                                      int.tryParse(timeslotsCtrl.text) ?? 3,
                                  "subjectsConfig": cleanSubjectsConfigList,
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
                                existingData == null
                                    ? 'إنشاء وحفظ'
                                    : 'تحديث البيانات',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
      builder: (context, child) =>
          Theme(data: Theme.of(context), child: child!),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
