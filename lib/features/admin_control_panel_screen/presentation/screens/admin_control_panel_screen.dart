import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/lessonslacture/lessonlecturecubit/lesson_lecture_cubit.dart';
import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/core/shares/years/models/year_model.dart'
    as year_model;
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/shares/lessonslacture/data/models/lesson_lecture_models.dart'
    as lec_model;
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_section_container.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_submit_button.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_text_field.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_year_dropdown.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// استدعاء الحزمة الرسمية لاختيار الملفات
import 'package:file_selector/file_selector.dart';

import 'package:bluebits_app/core/shares/semester/data/models/semestrs_model.dart'
    as sem_model;
import 'package:bluebits_app/core/shares/subjects/data/models/subjects_models.dart'
    as subj_model;

class AdminControlPanelScreen extends StatefulWidget {
  const AdminControlPanelScreen({super.key});

  @override
  State<AdminControlPanelScreen> createState() =>
      _AdminControlPanelScreenState();
}

class _AdminControlPanelScreenState extends State<AdminControlPanelScreen> {
  // ===========================================================================
  // 1. مفاتيح النماذج (Form Keys) لكل قسم لضمان التحقق المنفصل
  // ===========================================================================

  // مفاتيح عمليات (السنوات)
  final _yearFormKey = GlobalKey<FormState>();
  final _updateYearFormKey = GlobalKey<FormState>();
  final _deleteYearFormKey = GlobalKey<FormState>();

  // مفاتيح عمليات (الفصول)
  final _semesterFormKey = GlobalKey<FormState>();
  final _updateSemesterFormKey = GlobalKey<FormState>();
  final _deleteSemesterFormKey = GlobalKey<FormState>();

  // مفاتيح عمليات (المواد)
  final _subjectFormKey = GlobalKey<FormState>();
  final _updateSubjectFormKey = GlobalKey<FormState>();
  final _deleteSubjectFormKey = GlobalKey<FormState>();

  // مفاتيح عمليات (المحاضرات)
  final _lectureFormKey = GlobalKey<FormState>();
  final _updateLectureFormKey = GlobalKey<FormState>();
  final _deleteLectureFormKey = GlobalKey<FormState>();

  // ===========================================================================
  // 2. متحكمات النصوص (Text Controllers)
  // ===========================================================================

  // متحكمات (السنوات)
  final TextEditingController _yearNameController = TextEditingController();
  final TextEditingController _yearOrderController = TextEditingController();
  final TextEditingController _newYearNameController = TextEditingController();

  // متحكمات (الفصول)
  final TextEditingController _semesterNameController = TextEditingController();
  final TextEditingController _newSemesterNameController =
      TextEditingController();

  // متحكمات (المواد)
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectDescController = TextEditingController();
  final TextEditingController _newSubjectNameController =
      TextEditingController();
  final TextEditingController _newSubjectDescController =
      TextEditingController();

  // متحكمات (المحاضرات)
  final TextEditingController _lectureTitleController = TextEditingController();
  final TextEditingController _lectureDescController = TextEditingController();
  final TextEditingController _lectureFilePathController =
      TextEditingController();
  final TextEditingController _newLectureTitleController =
      TextEditingController();
  final TextEditingController _newLectureDescController =
      TextEditingController();
  final TextEditingController _newLectureFilePathController =
      TextEditingController();

  // ===========================================================================
  // 3. النوتيفايرز (Value Notifiers) لإدارة القوائم المنسدلة
  // ===========================================================================

  // نوتيفايرز عمليات (السنوات)
  final ValueNotifier<String?> _selectedYearToUpdateNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedYearToDeleteNotifier = ValueNotifier(
    null,
  );

  // نوتيفايرز عمليات (الفصول)
  final ValueNotifier<String?> _selectedSemesterToUpdateNotifier =
      ValueNotifier(null);
  final ValueNotifier<String?> _selectedSemesterToDeleteNotifier =
      ValueNotifier(null);

  // نوتيفايرز عمليات (المواد)
  final ValueNotifier<String?> _selectedYearForSubjectNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedSemesterNotifier = ValueNotifier(null);
  final ValueNotifier<String?> _subjManageYear = ValueNotifier(null);
  final ValueNotifier<String?> _subjManageSemester = ValueNotifier(null);
  final ValueNotifier<String?> _selectedSubjectToUpdateNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedSubjectToDeleteNotifier = ValueNotifier(
    null,
  );

  // نوتيفايرز عمليات (المحاضرات)
  final ValueNotifier<String?> _lecUploadYear = ValueNotifier(null);
  final ValueNotifier<String?> _lecUploadSemester = ValueNotifier(null);
  final ValueNotifier<String?> _lecUploadSubject = ValueNotifier(null);
  final ValueNotifier<String?> _lecUploadType = ValueNotifier(null);
  final ValueNotifier<bool> _isLecturePublished = ValueNotifier(true);

  final ValueNotifier<String?> _lecManageYear = ValueNotifier(null);
  final ValueNotifier<String?> _lecManageSemester = ValueNotifier(null);
  final ValueNotifier<String?> _lecManageSubject = ValueNotifier(null);
  final ValueNotifier<String?> _lecManageType = ValueNotifier(null);
  final ValueNotifier<String?> _selectedLectureToUpdateNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedLectureToDeleteNotifier = ValueNotifier(
    null,
  );

  // ===========================================================================
  // 4. القوائم المخبأة (Cached Data)
  // ===========================================================================
  List<year_model.Data> _cachedYears = [];
  List<sem_model.Data> _cachedSemesters = [];
  List<subj_model.Data> _cachedSubjects = [];
  List<lec_model.Data> _cachedLectures = [];

  final List<String> _lectureTypes = ['نظري', 'عملي'];

  // ===========================================================================
  // 5. دورة حياة الشاشة (Lifecycle) وتصفير الفلاتر
  // ===========================================================================
  @override
  void initState() {
    super.initState();
    _initCascadingResetListeners();
    _fetchScreenInitialData();
  }

  void _fetchScreenInitialData() {
    context.read<YearCubit>().fetchAllYears();
    context.read<SemesterCubit>().fetchAllSemesters();
    context.read<SubjectCubit>().getAllSubjects();
  }

  // تصفير القوائم الفرعية بذكاء لتجنب الخطأ وتكرار البيانات
  void _initCascadingResetListeners() {
    _subjManageYear.addListener(() => _resetSubjectSelection());
    _subjManageSemester.addListener(() => _resetSubjectSelection());

    _lecUploadYear.addListener(() => _lecUploadSubject.value = null);
    _lecUploadSemester.addListener(() => _lecUploadSubject.value = null);

    _lecManageYear.addListener(() => _resetLectureSelection());
    _lecManageSemester.addListener(() => _resetLectureSelection());
    _lecManageSubject.addListener(() => _resetLectureSelection());
    _lecManageType.addListener(() => _resetLectureSelection());
  }

  void _resetSubjectSelection() {
    _selectedSubjectToUpdateNotifier.value = null;
    _selectedSubjectToDeleteNotifier.value = null;
  }

  void _resetLectureSelection() {
    _selectedLectureToUpdateNotifier.value = null;
    _selectedLectureToDeleteNotifier.value = null;
    _cachedLectures.clear();
  }

  @override
  void dispose() {
    // تنظيف المتحكمات
    _yearNameController.dispose();
    _yearOrderController.dispose();
    _newYearNameController.dispose();
    _semesterNameController.dispose();
    _newSemesterNameController.dispose();
    _subjectNameController.dispose();
    _subjectDescController.dispose();
    _newSubjectNameController.dispose();
    _newSubjectDescController.dispose();
    _lectureTitleController.dispose();
    _lectureDescController.dispose();
    _lectureFilePathController.dispose();
    _newLectureTitleController.dispose();
    _newLectureDescController.dispose();
    _newLectureFilePathController.dispose();

    // تنظيف النوتيفايرز
    _selectedYearToUpdateNotifier.dispose();
    _selectedYearToDeleteNotifier.dispose();
    _selectedSemesterToUpdateNotifier.dispose();
    _selectedSemesterToDeleteNotifier.dispose();
    _selectedYearForSubjectNotifier.dispose();
    _selectedSemesterNotifier.dispose();
    _subjManageYear.dispose();
    _subjManageSemester.dispose();
    _selectedSubjectToUpdateNotifier.dispose();
    _selectedSubjectToDeleteNotifier.dispose();
    _lecUploadYear.dispose();
    _lecUploadSemester.dispose();
    _lecUploadSubject.dispose();
    _lecUploadType.dispose();
    _isLecturePublished.dispose();
    _lecManageYear.dispose();
    _lecManageSemester.dispose();
    _lecManageSubject.dispose();
    _lecManageType.dispose();
    _selectedLectureToUpdateNotifier.dispose();
    _selectedLectureToDeleteNotifier.dispose();

    super.dispose();
  }

  // ===========================================================================
  // 6. الدوال المساعدة الأساسية (Helper Methods)
  // ===========================================================================

  /// الحل الجذري لمشكلة (مصفوفة المواد لا تعمل):
  /// هذه الدالة تستخرج الـ ID بذكاء وتمنع أي تعارض بين الـ String والـ Object القادم من السيرفر
  List<subj_model.Data> _getFilteredSubjects(
    String? yearId,
    String? semesterId,
  ) {
    if (yearId == null || semesterId == null) return [];

    return _cachedSubjects.where((subject) {
      // الدالة الداخلية: مستخرج ذكي وآمن للـ ID
      String? getSafeId(dynamic field) {
        if (field == null) return null;
        if (field is String) return field.trim();
        if (field is int) return field.toString();
        // محاولة استخراج ID إذا كان الكائن Populated Object من السيرفر
        try {
          if (field.sId != null) return field.sId.toString().trim();
        } catch (_) {}
        try {
          if (field.id != null) return field.id.toString().trim();
        } catch (_) {}
        try {
          if (field['_id'] != null) return field['_id'].toString().trim();
        } catch (_) {}
        return field.toString().trim();
      }

      final String? sYearId = getSafeId((subject as dynamic).yearId);
      final String? sSemId = getSafeId((subject as dynamic).semesterId);

      return sYearId == yearId.trim() && sSemId == semesterId.trim();
    }).toList();
  }

  /// جلب المحاضرات باستخدام الفلاتر الأربعة
  void _fetchLecturesByFilters() async {
    final year = _lecManageYear.value;
    final semester = _lecManageSemester.value;
    final subject = _lecManageSubject.value;
    final type = _lecManageType.value;

    if (year != null && semester != null && subject != null && type != null) {
      final token = await CachHelper.getValue('Token') ?? '';
      if (mounted) {
        context
            .read<LessonLectureCubit>()
            .fetchLecturesByYearSemesterSubjectType(
              token,
              year,
              semester,
              subject,
              type,
            );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى تحديد كافة الفلاتر الأربعة أولاً (سنة/فصل/مادة/نوع)',
          ),
        ),
      );
    }
  }

  /// منتقي الملفات الآمن
  Future<void> _pickFileWithSelector(TextEditingController controller) async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'Documents',
        extensions: <String>['pdf', 'doc', 'docx', 'ppt', 'pptx'],
      );
      final XFile? file = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );
      if (file != null) controller.text = file.path;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ أثناء اختيار الملف: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  // ===========================================================================
  // 7. بناء واجهة المستخدم الرئيسية (Main Build)
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    // مراقبة حالات الـ Cubit وتحديث البيانات المخبأة
    final yearState = context.watch<YearCubit>().state;
    final semesterState = context.watch<SemesterCubit>().state;
    final subjectState = context.watch<SubjectCubit>().state;
    final lectureState = context.watch<LessonLectureCubit>().state;

    if (yearState is YearLoaded) _cachedYears = List.from(yearState.years);
    if (semesterState is SemesterLoaded) {
      _cachedSemesters = List.from(semesterState.semesters);
    }
    if (subjectState is GetSubjectsSuccess) {
      _cachedSubjects = List.from(subjectState.subjectModel.data ?? []);
    }
    if (lectureState is LessonLecturesLoaded) {
      _cachedLectures = List.from(lectureState.lessonLectures);
    }
    final bool isLoading =
        yearState is YearLoading ||
        semesterState is SemesterLoading ||
        subjectState is GetSubjectsLoading ||
        subjectState is SubjectActionLoading ||
        lectureState is LessonLectureLoading;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: MultiBlocListener(
          listeners: [
            // ------ مستمع عمليات السنوات ------
            BlocListener<YearCubit, YearState>(
              listener: (context, state) {
                if (state is YearActionSuccess) {
                  _showSuccessSnackBar(context, state.message);
                  _yearNameController.clear();
                  _yearOrderController.clear();
                  _newYearNameController.clear();
                  _selectedYearToUpdateNotifier.value = null;
                  _selectedYearToDeleteNotifier.value = null;
                  context.read<YearCubit>().fetchAllYears();
                } else if (state is YearError) {
                  _showErrorSnackBar(context, state.message, theme);
                }
              },
            ),
            // ------ مستمع عمليات الفصول ------
            BlocListener<SemesterCubit, SemesterState>(
              listener: (context, state) {
                if (state is SemesterActionSuccess) {
                  _showSuccessSnackBar(context, state.message);
                  _semesterNameController.clear();
                  _newSemesterNameController.clear();
                  _selectedSemesterToUpdateNotifier.value = null;
                  _selectedSemesterToDeleteNotifier.value = null;
                  context.read<SemesterCubit>().fetchAllSemesters();
                } else if (state is SemesterError) {
                  _showErrorSnackBar(context, state.message, theme);
                }
              },
            ),
            // ------ مستمع عمليات المواد ------
            BlocListener<SubjectCubit, SubjectState>(
              listener: (context, state) {
                if (state is SubjectActionSuccess) {
                  _showSuccessSnackBar(context, state.message);
                  _subjectNameController.clear();
                  _subjectDescController.clear();
                  _newSubjectNameController.clear();
                  _newSubjectDescController.clear();
                  _selectedYearForSubjectNotifier.value = null;
                  _selectedSemesterNotifier.value = null;
                  _selectedSubjectToUpdateNotifier.value = null;
                  _selectedSubjectToDeleteNotifier.value = null;
                  context.read<SubjectCubit>().getAllSubjects();
                } else if (state is SubjectActionFailure) {
                  _showErrorSnackBar(context, state.errorMessage, theme);
                }
              },
            ),
            // ------ مستمع عمليات المحاضرات ------
            BlocListener<LessonLectureCubit, LessonLectureState>(
              listener: (context, state) {
                if (state is LessonLectureActionSuccess) {
                  _showSuccessSnackBar(context, state.message);
                  _lectureTitleController.clear();
                  _lectureDescController.clear();
                  _lectureFilePathController.clear();
                  _newLectureTitleController.clear();
                  _newLectureDescController.clear();
                  _newLectureFilePathController.clear();
                  _selectedLectureToUpdateNotifier.value = null;
                  _selectedLectureToDeleteNotifier.value = null;

                  // التحديث التلقائي الفوري للمحاضرات المعروضة بعد التعديل أو الحذف
                  if (_lecManageYear.value != null &&
                      _lecManageSemester.value != null &&
                      _lecManageSubject.value != null &&
                      _lecManageType.value != null) {
                    _fetchLecturesByFilters();
                  }
                } else if (state is LessonLectureError) {
                  _showErrorSnackBar(context, state.message, theme);
                }
              },
            ),
          ],
          child: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageHeader(
                        title: 'لوحة التحكم',
                        subtitle:
                            'إدارة وإنشاء وتعديل وحذف السنوات والفصول والمواد والمحاضرات',
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 24),
                        height: screenHeight * 0.004,
                        width: screenWidth * 0.60,
                        color: theme.colorScheme.primary,
                      ),

                      // تفريغ الواجهة إلى أجزاء (Sections)
                      _buildYearsManagementSection(theme, screenHeight),
                      _buildSemestersManagementSection(theme, screenHeight),
                      _buildSubjectsManagementSection(
                        theme,
                        screenHeight,
                        screenWidth,
                      ),
                      _buildLecturesManagementSection(
                        theme,
                        screenHeight,
                        screenWidth,
                        context,
                      ),

                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
                // مؤشر التحميل العام
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 8. أقسام الواجهة (UI Modules / Sections)
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // [القسم الأول]: إدارة السنوات الدراسية (إنشاء - تعديل - حذف)
  // ---------------------------------------------------------------------------
  Widget _buildYearsManagementSection(ThemeData theme, double screenHeight) {
    return Column(
      children: [
        // --- 1. إنشاء سنة جديدة ---
        AdminSectionContainer(
          title: 'إنشاء سنة جديدة',
          icon: Icons.calendar_month_outlined,
          color: ColorsManager.blue,
          child: Form(
            key: _yearFormKey,
            child: Column(
              children: [
                AdminTextField(
                  controller: _yearNameController,
                  hint: 'اسم السنة (مثال: السنة الأولى)',
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminTextField(
                  controller: _yearOrderController,
                  hint: 'ترتيب السنة (رقم فقط)',
                  isNumber: true,
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminSubmitButton(
                  title: 'إضافة السنة',
                  onPressed: () async {
                    if (_yearFormKey.currentState!.validate()) {
                      final token = await CachHelper.getValue('Token') ?? '';
                      if (context.mounted) {
                        context.read<YearCubit>().addYear(
                          token,
                          _yearNameController.text.trim(),
                          int.tryParse(_yearOrderController.text.trim()) ?? 0,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),

        // --- 2. تعديل سنة دراسية ---
        AdminSectionContainer(
          title: 'تعديل اسم سنة دراسية',
          icon: Icons.edit_calendar_outlined,
          color: ColorsManager.green,
          child: Form(
            key: _updateYearFormKey,
            child: Column(
              children: [
                AdminYearDropdown(
                  hint: 'اختر السنة المراد تعديلها',
                  notifier: _selectedYearToUpdateNotifier,
                  yearsList: _cachedYears,
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminTextField(
                  controller: _newYearNameController,
                  hint: 'الاسم الجديد للسنة',
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminSubmitButton(
                  title: 'حفظ التعديل',
                  onPressed: () async {
                    if (_updateYearFormKey.currentState!.validate() &&
                        _selectedYearToUpdateNotifier.value != null) {
                      final token = await CachHelper.getValue('Token') ?? '';
                      if (context.mounted) {
                        context.read<YearCubit>().updateYear(
                          token,
                          _selectedYearToUpdateNotifier.value!,
                          _newYearNameController.text.trim(),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),

        // --- 3. حذف سنة دراسية ---
        AdminSectionContainer(
          title: 'حذف سنة دراسية',
          icon: Icons.delete_outline_rounded,
          color: theme.colorScheme.error,
          child: Form(
            key: _deleteYearFormKey,
            child: Column(
              children: [
                AdminYearDropdown(
                  hint: 'اختر السنة المراد حذفها',
                  notifier: _selectedYearToDeleteNotifier,
                  yearsList: _cachedYears,
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminSubmitButton(
                  title: 'حذف السنة نهائياً',
                  isDestructive: true,
                  onPressed: () async {
                    if (_deleteYearFormKey.currentState!.validate() &&
                        _selectedYearToDeleteNotifier.value != null) {
                      final token = await CachHelper.getValue('Token') ?? '';
                      if (context.mounted) {
                        context.read<YearCubit>().deleteYear(
                          token,
                          _selectedYearToDeleteNotifier.value!,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // [القسم الثاني]: إدارة الفصول الدراسية (إنشاء - تعديل - حذف)
  // ---------------------------------------------------------------------------
  Widget _buildSemestersManagementSection(
    ThemeData theme,
    double screenHeight,
  ) {
    return Column(
      children: [
        // --- 1. إنشاء فصل دراسي ---
        AdminSectionContainer(
          title: 'إنشاء فصل دراسي',
          icon: Icons.layers_outlined,
          color: ColorsManager.orange,
          child: Form(
            key: _semesterFormKey,
            child: Column(
              children: [
                AdminTextField(
                  controller: _semesterNameController,
                  hint: 'اسم الفصل (مثال: الفصل الأول)',
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminSubmitButton(
                  title: 'إضافة الفصل',
                  onPressed: () {
                    if (_semesterFormKey.currentState!.validate()) {
                      if (context.mounted) {
                        context.read<SemesterCubit>().createSemester(
                          _semesterNameController.text.trim(),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),

        // --- 2. تعديل فصل دراسي ---
        AdminSectionContainer(
          title: 'تعديل اسم فصل دراسي',
          icon: Icons.edit_note_rounded,
          color: ColorsManager.orange,
          child: Form(
            key: _updateSemesterFormKey,
            child: Column(
              children: [
                _buildCustomGenericDropdown<sem_model.Data>(
                  hint: 'اختر الفصل المراد تعديله',
                  notifier: _selectedSemesterToUpdateNotifier,
                  itemsList: _cachedSemesters,
                  extractId: (i) =>
                      (i as dynamic).id?.toString() ??
                      (i as dynamic).sId?.toString() ??
                      '',
                  extractName: (i) => (i as dynamic).name ?? 'بدون اسم',
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminTextField(
                  controller: _newSemesterNameController,
                  hint: 'الاسم الجديد للفصل',
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminSubmitButton(
                  title: 'حفظ تعديل الفصل',
                  onPressed: () async {
                    if (_updateSemesterFormKey.currentState!.validate() &&
                        _selectedSemesterToUpdateNotifier.value != null) {
                      if (context.mounted) {
                        context.read<SemesterCubit>().updateSemester(
                          _selectedSemesterToUpdateNotifier.value!,
                          _newSemesterNameController.text.trim(),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),

        // --- 3. حذف فصل دراسي ---
        AdminSectionContainer(
          title: 'حذف فصل دراسي',
          icon: Icons.delete_sweep_outlined,
          color: theme.colorScheme.error,
          child: Form(
            key: _deleteSemesterFormKey,
            child: Column(
              children: [
                _buildCustomGenericDropdown<sem_model.Data>(
                  hint: 'اختر الفصل المراد حذفه',
                  notifier: _selectedSemesterToDeleteNotifier,
                  itemsList: _cachedSemesters,
                  extractId: (i) =>
                      (i as dynamic).id?.toString() ??
                      (i as dynamic).sId?.toString() ??
                      '',
                  extractName: (i) => (i as dynamic).name ?? 'بدون اسم',
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminSubmitButton(
                  title: 'حذف الفصل نهائياً',
                  isDestructive: true,
                  onPressed: () async {
                    if (_deleteSemesterFormKey.currentState!.validate() &&
                        _selectedSemesterToDeleteNotifier.value != null) {
                      if (context.mounted) {
                        context.read<SemesterCubit>().deleteSemester(
                          _selectedSemesterToDeleteNotifier.value!,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // [القسم الثالث]: إدارة المواد الأكاديمية (الإنشاء والتعديل والحذف المفلتر)
  // ---------------------------------------------------------------------------
  Widget _buildSubjectsManagementSection(
    ThemeData theme,
    double screenHeight,
    double screenWidth,
  ) {
    return Column(
      children: [
        // --- 1. إنشاء مادة جديدة ---
        AdminSectionContainer(
          title: 'إنشاء مادة جديدة',
          icon: Icons.book_outlined,
          color: ColorsManager.purpleAccent,
          child: Form(
            key: _subjectFormKey,
            child: Column(
              children: [
                AdminTextField(
                  controller: _subjectNameController,
                  hint: 'اسم المادة (مثال: أمن الشبكات)',
                ),
                SizedBox(height: screenHeight * 0.02),
                AdminTextField(
                  controller: _subjectDescController,
                  hint: 'وصف المادة',
                  maxLines: 3,
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  children: [
                    Expanded(
                      child: AdminYearDropdown(
                        hint: 'اختر السنة',
                        notifier: _selectedYearForSubjectNotifier,
                        yearsList: _cachedYears,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Expanded(
                      child: _buildCustomGenericDropdown<sem_model.Data>(
                        hint: 'اختر الفصل',
                        notifier: _selectedSemesterNotifier,
                        itemsList: _cachedSemesters,
                        extractId: (i) =>
                            (i as dynamic).id?.toString() ??
                            (i as dynamic).sId?.toString() ??
                            '',
                        extractName: (i) => (i as dynamic).name ?? 'بدون اسم',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                AdminSubmitButton(
                  title: 'إضافة المادة',
                  onPressed: () async {
                    if (_subjectFormKey.currentState!.validate() &&
                        _selectedYearForSubjectNotifier.value != null &&
                        _selectedSemesterNotifier.value != null) {
                      if (context.mounted) {
                        context.read<SubjectCubit>().createSubject(
                          name: _subjectNameController.text.trim(),
                          description: _subjectDescController.text.trim(),
                          createdBy: "Admin",
                          yearId: _selectedYearForSubjectNotifier.value!,
                          semesterId: _selectedSemesterNotifier.value!,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),

        // --- 2 & 3. تعديل وحذف مادة (باستخدام الفلترة الآمنة) ---
        AdminSectionContainer(
          title: 'إدارة المواد (تعديل / حذف)',
          icon: Icons.edit_note,
          color: Colors.teal,
          child: Column(
            children: [
              // الفلاتر
              Row(
                children: [
                  Expanded(
                    child: AdminYearDropdown(
                      hint: 'حدد السنة',
                      notifier: _subjManageYear,
                      yearsList: _cachedYears,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCustomGenericDropdown<sem_model.Data>(
                      hint: 'حدد الفصل',
                      notifier: _subjManageSemester,
                      itemsList: _cachedSemesters,
                      extractId: (i) =>
                          (i as dynamic).id?.toString() ??
                          (i as dynamic).sId?.toString() ??
                          '',
                      extractName: (i) => (i as dynamic).name ?? '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<String?>(
                valueListenable: _subjManageYear,
                builder: (context, yId, _) => ValueListenableBuilder<String?>(
                  valueListenable: _subjManageSemester,
                  builder: (context, sId, _) {
                    // هنا يتم استدعاء دالة الفلترة القوية والمحمية
                    final matchingSubjects = _getFilteredSubjects(yId, sId);
                    return Column(
                      children: [
                        // -- فورم تعديل المادة --
                        Form(
                          key: _updateSubjectFormKey,
                          child: Column(
                            children: [
                              _buildCustomGenericDropdown<subj_model.Data>(
                                hint: 'اختر المادة المراد تعديلها',
                                notifier: _selectedSubjectToUpdateNotifier,
                                itemsList: matchingSubjects,
                                extractId: (i) =>
                                    (i as dynamic).sId?.toString() ??
                                    (i as dynamic).id?.toString() ??
                                    '',
                                extractName: (i) => (i as dynamic).name ?? '',
                                onSelectionChanged: (val) {
                                  if (val != null &&
                                      matchingSubjects.isNotEmpty) {
                                    final match = matchingSubjects.firstWhere(
                                      (s) =>
                                          ((s as dynamic).sId?.toString() ??
                                              (s as dynamic).id?.toString()) ==
                                          val,
                                    );
                                    _newSubjectNameController.text =
                                        (match as dynamic).name ?? '';
                                    _newSubjectDescController.text =
                                        (match as dynamic).description ?? '';
                                  }
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              AdminTextField(
                                controller: _newSubjectNameController,
                                hint: 'الاسم الجديد للمادة',
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              AdminTextField(
                                controller: _newSubjectDescController,
                                hint: 'الوصف الجديد للمادة',
                                maxLines: 3,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              AdminSubmitButton(
                                title: 'حفظ تعديل المادة',
                                onPressed: () {
                                  if (_updateSubjectFormKey.currentState!
                                          .validate() &&
                                      _selectedSubjectToUpdateNotifier.value !=
                                          null) {
                                    if (context.mounted) {
                                      context
                                          .read<SubjectCubit>()
                                          .updateSubject(
                                            subjectId:
                                                _selectedSubjectToUpdateNotifier
                                                    .value!,
                                            name: _newSubjectNameController.text
                                                .trim(),
                                            description:
                                                _newSubjectDescController.text
                                                    .trim(),
                                          );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(),
                        ),
                        // -- فورم حذف المادة --
                        Form(
                          key: _deleteSubjectFormKey,
                          child: Column(
                            children: [
                              _buildCustomGenericDropdown<subj_model.Data>(
                                hint: 'اختر المادة المراد حذفها',
                                notifier: _selectedSubjectToDeleteNotifier,
                                itemsList: matchingSubjects,
                                extractId: (i) =>
                                    (i as dynamic).sId?.toString() ??
                                    (i as dynamic).id?.toString() ??
                                    '',
                                extractName: (i) => (i as dynamic).name ?? '',
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              AdminSubmitButton(
                                title: 'حذف المادة نهائياً',
                                isDestructive: true,
                                onPressed: () {
                                  if (_deleteSubjectFormKey.currentState!
                                          .validate() &&
                                      _selectedSubjectToDeleteNotifier.value !=
                                          null) {
                                    if (context.mounted) {
                                      context
                                          .read<SubjectCubit>()
                                          .deleteSubject(
                                            _selectedSubjectToDeleteNotifier
                                                .value!,
                                          );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // [القسم الرابع]: إدارة المحاضرات الأكاديمية (إنشاء - تعديل - حذف متقدم)
  // ---------------------------------------------------------------------------
  Widget _buildLecturesManagementSection(
    ThemeData theme,
    double screenHeight,
    double screenWidth,
    BuildContext context,
  ) {
    return Column(
      children: [
        // --- 1. رفع ونشر محاضرة جديدة ---
        AdminSectionContainer(
          title: 'رفع محاضرة جديدة',
          icon: Icons.cloud_upload_outlined,
          color: ColorsManager.pomodoroPurple,
          child: Form(
            key: _lectureFormKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AdminYearDropdown(
                        hint: 'السنة',
                        notifier: _lecUploadYear,
                        yearsList: _cachedYears,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCustomGenericDropdown<sem_model.Data>(
                        hint: 'الفصل',
                        notifier: _lecUploadSemester,
                        itemsList: _cachedSemesters,
                        extractId: (i) =>
                            (i).id?.toString() ?? (i).id?.toString() ?? '',
                        extractName: (i) => (i).name ?? '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<String?>(
                  valueListenable: _lecUploadYear,
                  builder: (context, yId, _) => ValueListenableBuilder<String?>(
                    valueListenable: _lecUploadSemester,
                    builder: (context, sId, _) =>
                        _buildCustomGenericDropdown<subj_model.Data>(
                          hint: 'المادة المستهدفة',
                          notifier: _lecUploadSubject,
                          itemsList: _getFilteredSubjects(
                            yId,
                            sId,
                          ), // استخدام الفلتر الآمن
                          extractId: (i) =>
                              (i).sId?.toString() ?? (i).sId?.toString() ?? '',
                          extractName: (i) => (i).name ?? '',
                        ),
                  ),
                ),
                const SizedBox(height: 12),
                AdminTextField(
                  controller: _lectureTitleController,
                  hint: 'عنوان المحاضرة الرئيسي',
                ),
                const SizedBox(height: 12),
                AdminTextField(
                  controller: _lectureDescController,
                  hint: 'وصف المحاضرة',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AdminTextField(
                        controller: _lectureFilePathController,
                        hint: 'مسار الملف المختار',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () =>
                            _pickFileWithSelector(_lectureFilePathController),
                        child: const Icon(
                          Icons.attach_file_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextDropdownOnly(
                        hint: 'تصنيف المحاضرة',
                        notifier: _lecUploadType,
                        elements: _lectureTypes,
                      ),
                    ),
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _isLecturePublished,
                        builder: (context, published, _) => CheckboxListTile(
                          title: const Text(
                            'إتاحة للطلاب',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          value: published,
                          activeColor: ColorsManager.blue,
                          onChanged: (val) =>
                              _isLecturePublished.value = val ?? true,
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AdminSubmitButton(
                  title: 'رفع ونشر المحاضرة',
                  onPressed: () async {
                    if (_lectureFormKey.currentState!.validate() &&
                        _lecUploadSubject.value != null &&
                        _lecUploadType.value != null &&
                        _lectureFilePathController.text.isNotEmpty) {
                      final token = await CachHelper.getValue('Token') ?? '';
                      if (context.mounted) {
                        print(
                          'Uploading lecture with title: ${_lectureTitleController.text.trim()}',
                        );
                        print(
                          'Uploading lecture with description: ${_lectureDescController.text.trim()}',
                        );
                        print(
                          'Uploading lecture with subject ID: ${_lecUploadSubject.value!}',
                        );
                        print(
                          'Uploading lecture with type: ${_lecUploadType.value!}',
                        );
                        print(
                          'Uploading lecture with published status: ${_isLecturePublished.value}',
                        );
                        print(
                          'Uploading lecture with file path: ${_lectureFilePathController.text.trim()}',
                        );
                        // 1. تحويل القيمة العربية إلى القيمة الإنجليزية التي يقبلها الباك إند
                        String uiType = _lecUploadType.value!;
                        String backendType = uiType == 'عملي'
                            ? 'practical'
                            : 'theoretical';
                        context.read<LessonLectureCubit>().uploadLecture(
                          token,
                          _lectureTitleController.text.trim(),
                          _lectureDescController.text.trim(),
                          _lecUploadSubject.value!,
                          backendType,
                          _isLecturePublished.value,
                          _lectureFilePathController.text.trim(),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'يرجى تحديد كافة الفلاتر واختيار ملف المحاضرة',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.03),

        // --- 2 & 3. استعراض وتعديل وحذف محاضرة (عبر الفلاتر الرباعية) ---
        AdminSectionContainer(
          title: 'إدارة المحاضرات (استعراض / تعديل / حذف)',
          icon: Icons.folder,
          color: ColorsManager.deepNavy,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: AdminYearDropdown(
                      hint: 'السنة',
                      notifier: _lecManageYear,
                      yearsList: _cachedYears,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildCustomGenericDropdown<sem_model.Data>(
                      hint: 'الفصل',
                      notifier: _lecManageSemester,
                      itemsList: _cachedSemesters,
                      extractId: (i) =>
                          (i as dynamic).id?.toString() ??
                          (i as dynamic).sId?.toString() ??
                          '',
                      extractName: (i) => (i as dynamic).name ?? '',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<String?>(
                valueListenable: _lecManageYear,
                builder: (context, yId, _) => ValueListenableBuilder<String?>(
                  valueListenable: _lecManageSemester,
                  builder: (context, sId, _) => Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildCustomGenericDropdown<subj_model.Data>(
                          hint: 'اختر المادة',
                          notifier: _lecManageSubject,
                          itemsList: _getFilteredSubjects(
                            yId,
                            sId,
                          ), // استخدام الفلتر الآمن
                          extractId: (i) =>
                              (i as dynamic).sId?.toString() ??
                              (i as dynamic).id?.toString() ??
                              '',
                          extractName: (i) => (i as dynamic).name ?? '',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextDropdownOnly(
                          hint: 'النوع',
                          notifier: _lecManageType,
                          elements: _lectureTypes,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchLecturesByFilters,
                icon: const Icon(Icons.search_rounded, color: Colors.white),
                label: const Text(
                  'جلب واستعراض المحاضرات',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: ColorsManager.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(),
              ),

              BlocBuilder<LessonLectureCubit, LessonLectureState>(
                builder: (context, state) {
                  if (_cachedLectures.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'لا توجد محاضرات تطابق الفلاتر المحددة.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ColorsManager.greyText),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      // -- فورم تعديل المحاضرة --
                      Form(
                        key: _updateLectureFormKey,
                        child: Column(
                          children: [
                            _buildCustomGenericDropdown<lec_model.Data>(
                              hint: 'حدد المحاضرة للتعديل',
                              notifier: _selectedLectureToUpdateNotifier,
                              itemsList: _cachedLectures,
                              extractId: (i) =>
                                  (i as dynamic).id?.toString() ??
                                  (i as dynamic).sId?.toString() ??
                                  '',
                              extractName: (i) =>
                                  (i as dynamic).title ?? 'بدون عنوان',
                              onSelectionChanged: (val) {
                                if (val != null && _cachedLectures.isNotEmpty) {
                                  final lecture = _cachedLectures.firstWhere(
                                    (l) =>
                                        ((l as dynamic).id?.toString() ??
                                            (l as dynamic).sId?.toString()) ==
                                        val,
                                  );
                                  _newLectureTitleController.text =
                                      (lecture as dynamic).title ?? '';
                                  _newLectureDescController.text =
                                      (lecture as dynamic).description ?? '';
                                  _newLectureFilePathController.clear();
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            AdminTextField(
                              controller: _newLectureTitleController,
                              hint: 'العنوان الجديد',
                            ),
                            const SizedBox(height: 12),
                            AdminTextField(
                              controller: _newLectureDescController,
                              hint: 'الوصف الجديد',
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: AdminTextField(
                                    controller: _newLectureFilePathController,
                                    hint:
                                        'ارفع الملف القديم للاحتفاظ به أو الملف الجديد',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      backgroundColor: ColorsManager.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => _pickFileWithSelector(
                                      _newLectureFilePathController,
                                    ),
                                    child: const Icon(
                                      Icons.edit_document,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AdminSubmitButton(
                              title: 'تطبيق تحديثات المحاضرة',
                              onPressed: () async {
                                if (_updateLectureFormKey.currentState!
                                        .validate() &&
                                    _selectedLectureToUpdateNotifier.value !=
                                        null) {
                                  final token =
                                      await CachHelper.getValue('Token') ?? '';
                                  if (context.mounted) {
                                    context
                                        .read<LessonLectureCubit>()
                                        .updateLecture(
                                          token,
                                          _selectedLectureToUpdateNotifier
                                              .value!,
                                          _newLectureTitleController.text
                                              .trim(),
                                          _newLectureDescController.text.trim(),
                                          _newLectureFilePathController
                                                  .text
                                                  .isNotEmpty
                                              ? _newLectureFilePathController
                                                    .text
                                                    .trim()
                                              : null,
                                        );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(),
                      ),

                      // -- فورم حذف المحاضرة --
                      Form(
                        key: _deleteLectureFormKey,
                        child: Column(
                          children: [
                            _buildCustomGenericDropdown<lec_model.Data>(
                              hint: 'حدد المحاضرة للإزالة',
                              notifier: _selectedLectureToDeleteNotifier,
                              itemsList: _cachedLectures,
                              extractId: (i) =>
                                  (i as dynamic).id?.toString() ??
                                  (i as dynamic).sId?.toString() ??
                                  '',
                              extractName: (i) =>
                                  (i as dynamic).title ?? 'بدون عنوان',
                            ),
                            const SizedBox(height: 16),
                            AdminSubmitButton(
                              title: 'حذف المحاضرة نهائياً',
                              isDestructive: true,
                              onPressed: () async {
                                if (_deleteLectureFormKey.currentState!
                                        .validate() &&
                                    _selectedLectureToDeleteNotifier.value !=
                                        null) {
                                  final token =
                                      await CachHelper.getValue('Token') ?? '';
                                  if (context.mounted) {
                                    context
                                        .read<LessonLectureCubit>()
                                        .deleteLecture(
                                          token,
                                          _selectedLectureToDeleteNotifier
                                              .value!,
                                        );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // 9. الدوال المساعدة لبناء الواجهات (Widgets Builders & Helpers)
  // ===========================================================================

  /// دالة ديناميكية لإنشاء القوائم المنسدلة مع حماية قصوى من أخطاء الـ Null و الـ Types
  Widget _buildCustomGenericDropdown<T>({
    required String hint,
    required ValueNotifier<String?> notifier,
    required List<T> itemsList,
    required String Function(T) extractId,
    required String Function(T) extractName,
    void Function(String?)? onSelectionChanged,
  }) {
    return ValueListenableBuilder<String?>(
      valueListenable: notifier,
      builder: (context, currentValue, _) {
        // التحقق من أن القيمة الحالية لا تزال موجودة ضمن المصفوفة لتجنب الكراش
        final bool checkValidity = itemsList.any(
          (element) => extractId(element) == currentValue,
        );

        return DropdownButtonFormField<String>(
          initialValue: checkValidity ? currentValue : null,
          isExpanded: true,
          hint: Text(
            hint,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: itemsList.map((item) {
            return DropdownMenuItem<String>(
              value: extractId(item),
              child: Text(
                extractName(item),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            notifier.value = value;
            if (onSelectionChanged != null) onSelectionChanged(value);
          },
          validator: (value) => value == null ? 'الحقل إلزامي' : null,
        );
      },
    );
  }

  /// دالة لإنشاء قائمة منسدلة للنصوص البسيطة (مثل: نظري/عملي)
  Widget _buildTextDropdownOnly({
    required String hint,
    required ValueNotifier<String?> notifier,
    required List<String> elements,
  }) {
    return ValueListenableBuilder<String?>(
      valueListenable: notifier,
      builder: (context, value, _) => DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        hint: Text(hint, style: const TextStyle(fontSize: 13)),
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        items: elements
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 14)),
              ),
            )
            .toList(),
        onChanged: (val) => notifier.value = val,
        validator: (val) => val == null ? 'الحقل إلزامي' : null,
      ),
    );
  }

  /// إشعارات التنبيه (SnackBars)
  void _showSuccessSnackBar(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: ColorsManager.green),
    );
  }

  void _showErrorSnackBar(BuildContext ctx, String msg, ThemeData theme) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: theme.colorScheme.error),
    );
  }
}
