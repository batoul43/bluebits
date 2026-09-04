import 'dart:convert';
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/features/surveys/surveys_admin/data/models/admin_form_response.dart';
import 'package:bluebits_app/features/surveys/surveys_admin/presentation/logic/admin_survey_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSurveyScreen extends StatefulWidget {
  const AdminSurveyScreen({super.key});

  @override
  State<AdminSurveyScreen> createState() => _AdminSurveyScreenState();
}

class _AdminSurveyScreenState extends State<AdminSurveyScreen> {
  List<AdminFormModel> _cachedForms = [];

  final ScrollController _verticalScrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  @override
  void dispose() {
    _verticalScrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _fetchInitialData() {
    context.read<AdminSurveyCubit>().fetchAllForms();
    context.read<YearCubit>().fetchAllYears();
    context.read<SemesterCubit>().fetchAllSemesters();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الاستبيانات'), centerTitle: true),
      body: BlocConsumer<AdminSurveyCubit, AdminSurveyState>(
        listener: (context, state) {
          if (state is AdminSurveyActionSuccess) {
            _showSnackBar(context, state.message, ColorsManager.green);
            context.read<AdminSurveyCubit>().fetchAllForms();
          } else if (state is AdminSurveyError) {
            _showSnackBar(context, state.message, ColorsManager.redaccent);
          } else if (state is AdminSurveyResultsLoaded) {
            _showResultsDialog(context, state.results);
          }
        },
        builder: (context, state) {
          if (state is AdminSurveysLoaded) {
            _cachedForms = state.forms;
          }

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * (isTablet ? 0.08 : 0.04),
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AdminSurveyHeaderCard(theme: theme),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildSurveysListContent(context, state, isTablet),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  void _showResultsDialog(BuildContext context, dynamic results) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.analytics_rounded, color: ColorsManager.blue),
            const SizedBox(width: 10),
            Text(
              'نتائج الاستبيان',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: size.width > 600 ? 1000 : size.width * 0.95,
          height: size.height * 0.7,
          child: _buildResultsTable(ctx, results),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdminSurveyCubit>().fetchAllForms();
            },
            child: Text(
              'إغلاق',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// قاموس لترجمة أسماء المفاتيح لتبدو احترافية
  String _translateKey(String key) {
    final Map<String, String> translations = {
      'coursename': 'اسم المادة',
      'course': 'المادة',
      'subject': 'المادة',
      'studentname': 'اسم الطالب',
      'student': 'الطالب',
      'name': 'الاسم',
      'email': 'البريد الإلكتروني',
      'semester': 'الفصل الدراسي',
      'year': 'السنة الدراسية',
      'preference': 'الأفضلية',
      'preferences': 'الأفضليات',
      'priority': 'الأولوية',
      'rating': 'التقييم',
      'votes': 'عدد الأصوات',
      'count': 'العدد',
      'status': 'الحالة',
      'date': 'التاريخ',
      'createdat': 'تاريخ التقديم',
      'updatedat': 'تاريخ التحديث',
      'answers': 'الإجابات',
      'answer': 'الإجابة',
      'question': 'السؤال',
    };

    return translations[key.toLowerCase()] ?? key;
  }

  /// دالة ذكية لاستخراج "الاسم" فقط من الكائنات المعقدة (تمنع ظهور الـ ID والتفاصيل الزائدة في الأعمدة الرئيسية)
  String _extractEntityName(dynamic val) {
    if (val == null) return '-';

    if (val is String) {
      try {
        final decoded = jsonDecode(val);
        return _extractEntityName(decoded);
      } catch (_) {
        return val;
      }
    }

    if (val is Map) {
      final nameKeys = [
        'name',
        'title',
        'arname',
        'enname',
        'coursename',
        'studentname',
        'username',
      ];
      for (var k in nameKeys) {
        for (var actualKey in val.keys) {
          if (actualKey.toString().toLowerCase() == k) {
            return val[actualKey].toString();
          }
        }
      }
      return _formatValue(val);
    }

    return val.toString();
  }

  /// دالة لمعالجة وتنسيق البيانات المتداخلة والقوائم
  String _formatValue(dynamic value) {
    if (value == null) return '-';

    if (value is String) {
      final trimmed = value.trim();
      if ((trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'))) {
        try {
          final decoded = jsonDecode(trimmed);
          return _formatValue(decoded);
        } catch (_) {}
      }
    }

    // تنسيق القوائم كنقاط (Bullet points) لتبدو احترافية ومرتبة عمودياً
    if (value is List) {
      if (value.isEmpty) return '-';
      return value.map((e) => '• ${_formatValue(e)}').join('\n');
    }

    if (value is Map) {
      if (value.isEmpty) return '-';

      final filteredEntries = value.entries.where((e) {
        final k = e.key.toString().toLowerCase();
        return !k.contains('id') && k != '_id' && k != '__v';
      });

      if (filteredEntries.isEmpty) return '-';

      return filteredEntries
          .map((e) {
            final k = _translateKey(e.key.toString());
            final v = _formatValue(e.value);
            return '$k: $v';
          })
          .join(' | ');
    }

    final String strValue = value.toString();
    final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}T');
    if (dateRegex.hasMatch(strValue)) {
      final DateTime? parsedDate = DateTime.tryParse(strValue);
      if (parsedDate != null) {
        return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
      }
    }

    return strValue;
  }

  /// أداة لتسهيل بناء نصوص الخلايا مع مسافات مريحة للعين
  Widget _buildCellText(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Text(
        text,
        style: TextStyle(
          height: 1.6,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildResultsTable(BuildContext context, dynamic results) {
    final theme = Theme.of(context);

    if (results == null) return _emptyResultsWidget(theme);

    List<DataColumn> columns = [];
    List<DataRow> rows = [];

    if (results is FormResultsModel) {
      final responsesList = results.responses ?? [];
      if (responsesList.isEmpty) return _emptyResultsWidget(theme);

      if (responsesList.first is Map) {
        // 1. تحديد الأعمدة الثابتة المطلوبة باحترافية
        final List<String> standardHeaders = [
          'اسم الطالب',
          'السنة الدراسية',
          'الفصل الدراسي',
          'المادة / الرغبات',
          'تفاصيل إضافية',
        ];

        columns = standardHeaders
            .map(
              (header) => DataColumn(
                label: Text(
                  header,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
            .toList();

        rows = responsesList.map((item) {
          final mapItem = item as Map;

          // دالة مساعدة للبحث عن القيم بناءً على كلمات مفتاحية (لتوافق مرن مع الـ API)
          dynamic findByKeywords(List<String> keywords) {
            for (var key in mapItem.keys) {
              final lowerKey = key.toString().toLowerCase();
              if (keywords.any((kw) => lowerKey.contains(kw))) {
                return mapItem[key];
              }
            }
            return null;
          }

          // 2. استخراج الحقول الأساسية المطلوبة لكل سطر
          final student = findByKeywords([
            'student',
            'user',
            'name',
            'account',
          ]);
          final year = findByKeywords(['year', 'academic']);
          final semester = findByKeywords(['semester', 'term']);
          final subject = findByKeywords([
            'course',
            'subject',
            'preference',
            'answer',
            'choice',
          ]);

          // 3. تجميع أي بيانات أخرى متبقية في عمود "التفاصيل الإضافية"
          final usedKeys = mapItem.keys.where((k) {
            final lowerK = k.toString().toLowerCase();
            return [
              'student',
              'user',
              'name',
              'account',
              'year',
              'academic',
              'semester',
              'term',
              'course',
              'subject',
              'preference',
              'answer',
              'choice',
            ].any((kw) => lowerK.contains(kw));
          }).toList();

          final otherDetails = Map.fromEntries(
            mapItem.entries.where((e) {
              final k = e.key.toString().toLowerCase();
              return !usedKeys.contains(e.key) &&
                  !k.contains('id') &&
                  k != '__v';
            }),
          );

          return DataRow(
            cells: [
              DataCell(
                _buildCellText(_extractEntityName(student), isBold: true),
              ),
              DataCell(_buildCellText(_extractEntityName(year))),
              DataCell(_buildCellText(_extractEntityName(semester))),
              DataCell(
                _buildCellText(_formatValue(subject)),
              ), // المادة قد تكون قائمة لذلك نستخدم formatValue
              DataCell(
                _buildCellText(
                  otherDetails.isEmpty ? '-' : _formatValue(otherDetails),
                ),
              ),
            ],
          );
        }).toList();
      } else {
        // معالجة إذا كانت الردود نصوص بسيطة وليست كائنات
        columns = const [
          DataColumn(
            label: Text(
              'الردود',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ];
        rows = responsesList
            .map(
              (item) => DataRow(
                cells: [DataCell(_buildCellText(_formatValue(item)))],
              ),
            )
            .toList();
      }
    } else if (results is Map) {
      final filteredResults = Map.fromEntries(
        results.entries.where(
          (e) => !e.key.toString().toLowerCase().contains('id'),
        ),
      );

      if (filteredResults.isEmpty) return _emptyResultsWidget(theme);

      columns = const [
        DataColumn(
          label: Text('العنصر', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataColumn(
          label: Text('النتيجة', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ];
      rows = filteredResults.entries
          .map(
            (entry) => DataRow(
              cells: [
                DataCell(
                  _buildCellText(
                    _translateKey(entry.key.toString()),
                    isBold: true,
                  ),
                ),
                DataCell(_buildCellText(_formatValue(entry.value))),
              ],
            ),
          )
          .toList();
    } else {
      return Center(child: Text(_formatValue(results)));
    }

    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      child: SingleChildScrollView(
        controller: _verticalScrollController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Scrollbar(
          controller: _horizontalScrollController,
          thumbVisibility: true,
          trackVisibility: true,
          interactive: true,
          notificationPredicate: (notif) => notif.depth == 0,
          child: SingleChildScrollView(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                theme.colorScheme.primary.withOpacity(0.1),
              ),
              dataRowMinHeight: 65,
              dataRowMaxHeight: double.infinity,
              columnSpacing: 40,
              border: TableBorder.all(
                color: theme.dividerColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12), // زوايا أنعم للجدول
              ),
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyResultsWidget(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_chart_outlined,
            size: 64,
            color: ColorsManager.greyText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد نتائج لعرضها',
            style: theme.textTheme.titleMedium?.copyWith(
              color: ColorsManager.greyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveysListContent(
    BuildContext context,
    AdminSurveyState state,
    bool isTablet,
  ) {
    if (state is AdminSurveyLoading && _cachedForms.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AdminSurveyError && _cachedForms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: ColorsManager.redaccent,
            ),
            const SizedBox(height: 8),
            Text(state.message, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<AdminSurveyCubit>().fetchAllForms(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (_cachedForms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.poll_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            Text(
              'لا توجد استبيانات متاحة حالياً',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return isTablet
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
            ),
            itemCount: _cachedForms.length,
            itemBuilder: (context, index) =>
                _SurveyCard(form: _cachedForms[index]),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: _cachedForms.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _SurveyCard(form: _cachedForms[index]),
          );
  }
}

class _AdminSurveyHeaderCard extends StatelessWidget {
  final ThemeData theme;

  const _AdminSurveyHeaderCard({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'استبيانات أفضلية المواد',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'قم بنشر استبيانات جديدة ومتابعة إحصائيات وإجابات الطلاب',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: theme.colorScheme.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => _showCreateSurveyDialog(context),
            icon: const Icon(Icons.add_rounded, size: 20),
            label: const Text(
              'استبيان جديد',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateSurveyDialog(BuildContext context) {
    final yearCubit = context.read<YearCubit>();
    final semesterCubit = context.read<SemesterCubit>();
    final adminSurveyCubit = context.read<AdminSurveyCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: yearCubit),
          BlocProvider.value(value: semesterCubit),
          BlocProvider.value(value: adminSurveyCubit),
        ],
        child: const _CreateSurveyDialog(),
      ),
    );
  }
}

class _SurveyCard extends StatelessWidget {
  final AdminFormModel form;

  const _SurveyCard({required this.form});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color statusColor;
    String statusText;
    switch (form.status?.toLowerCase()) {
      case 'open':
        statusColor = ColorsManager.green;
        statusText = 'مفتوح';
        break;
      case 'closed':
        statusColor = ColorsManager.redaccent;
        statusText = 'مغلق';
        break;
      default:
        statusColor = ColorsManager.orange;
        statusText = 'مسودة';
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.08)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'العام الدراسي: ${form.academicYear ?? "غير محدد"}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: BlocBuilder<YearCubit, YearState>(
                    builder: (context, state) {
                      String yearName = form.yearId ?? "غير محدد";
                      if (state is YearLoaded) {
                        try {
                          final yearObj = state.years.firstWhere(
                            (y) => y.sId?.toString() == form.yearId?.toString(),
                          );
                          yearName = yearObj.name ?? yearName;
                        } catch (_) {}
                      }
                      return Text(
                        'السنة الدراسية: $yearName',
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: BlocBuilder<SemesterCubit, SemesterState>(
                    builder: (context, state) {
                      String semesterName = form.semesterId ?? "غير محدد";
                      if (state is SemesterLoaded) {
                        try {
                          final semObj = state.semesters.firstWhere(
                            (s) =>
                                s.id?.toString() == form.semesterId?.toString(),
                          );
                          semesterName = semObj.name ?? semesterName;
                        } catch (_) {}
                      }
                      return Text(
                        'الفصل الدراسي: $semesterName',
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (form.id != null && form.status != 'open')
                  IconButton(
                    tooltip: 'تفعيل الاستبيان',
                    icon: const Icon(
                      Icons.play_circle_fill,
                      color: ColorsManager.green,
                    ),
                    onPressed: () =>
                        context.read<AdminSurveyCubit>().openForm(form.id!),
                  ),
                if (form.id != null && form.status == 'open')
                  IconButton(
                    tooltip: 'إغلاق الاستبيان',
                    icon: const Icon(
                      Icons.stop_circle,
                      color: ColorsManager.orange,
                    ),
                    onPressed: () =>
                        context.read<AdminSurveyCubit>().closeForm(form.id!),
                  ),
                IconButton(
                  tooltip: 'عرض النتائج',
                  icon: const Icon(
                    Icons.bar_chart_rounded,
                    color: ColorsManager.blue,
                  ),
                  onPressed: () {
                    if (form.id != null) {
                      context.read<AdminSurveyCubit>().fetchFormResults(
                        form.id!,
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateSurveyDialog extends StatefulWidget {
  const _CreateSurveyDialog();

  @override
  State<_CreateSurveyDialog> createState() => _CreateSurveyDialogState();
}

class _CreateSurveyDialogState extends State<_CreateSurveyDialog> {
  late final TextEditingController _academicYearController;
  String? _selectedSemesterId;
  String? _selectedYearId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _academicYearController = TextEditingController();
  }

  @override
  void dispose() {
    _academicYearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'إنشاء استبيان جديد',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _academicYearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'العام الدراسي',
                  hintText: 'مثال: 2026-2027',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
                  final regex = RegExp(r'^(\d{4})-(\d{4})$');
                  final match = regex.firstMatch(v.trim());
                  if (match == null) return 'الصيغة غير صحيحة، مثال: 2026-2027';
                  int startYear = int.parse(match.group(1)!);
                  int endYear = int.parse(match.group(2)!);
                  if (endYear != startYear + 1)
                    return 'يجب أن يكون العام الثاني تالياً للعام الأول';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<YearCubit, YearState>(
                builder: (context, state) {
                  List years = [];
                  bool isLoading = state is YearLoading;
                  if (state is YearLoaded) years = state.years;

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: isLoading
                          ? 'جاري تحميل السنوات...'
                          : 'اختر السنة الدراسية',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: _selectedYearId,
                    items: years.map((year) {
                      return DropdownMenuItem<String>(
                        value: year.sId?.toString() ?? '',
                        child: Text(year.name ?? 'سنة غير مسماة'),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (val) => setState(() => _selectedYearId = val),
                    validator: (v) => v == null || v.isEmpty
                        ? 'يرجى اختيار السنة الدراسية'
                        : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<SemesterCubit, SemesterState>(
                builder: (context, state) {
                  List semesters = [];
                  bool isLoading = state is SemesterLoading;
                  if (state is SemesterLoaded) semesters = state.semesters;

                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: isLoading
                          ? 'جاري تحميل الفصول...'
                          : 'اختر الفصل الدراسي',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    value: _selectedSemesterId,
                    items: semesters.map((semester) {
                      return DropdownMenuItem<String>(
                        value: semester.id?.toString() ?? '',
                        child: Text(semester.name ?? 'فصل غير مسمى'),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (val) => setState(() => _selectedSemesterId = val),
                    validator: (v) => v == null || v.isEmpty
                        ? 'يرجى اختيار الفصل الدراسي'
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<AdminSurveyCubit>().createForm(
                _selectedSemesterId!,
                _selectedYearId!,
                _academicYearController.text.trim(),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('إنشاء', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
