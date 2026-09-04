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
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_submit_button.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_text_field.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_year_dropdown.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  // 1. مفاتيح النماذج (Form Keys)
  // ===========================================================================
  final _yearFormKey = GlobalKey<FormState>();
  final _updateYearFormKey = GlobalKey<FormState>();

  final _semesterFormKey = GlobalKey<FormState>();
  final _updateSemesterFormKey = GlobalKey<FormState>();

  final _subjectFormKey = GlobalKey<FormState>();
  final _updateSubjectFormKey = GlobalKey<FormState>();

  final _lectureFormKey = GlobalKey<FormState>();
  final _updateLectureFormKey = GlobalKey<FormState>();
  final _deleteLectureFormKey = GlobalKey<FormState>();

  // ===========================================================================
  // 2. متحكمات النصوص (Text Controllers)
  // ===========================================================================
  final TextEditingController _yearNameController = TextEditingController();
  final TextEditingController _yearOrderController = TextEditingController();
  final TextEditingController _newYearNameController = TextEditingController();

  final TextEditingController _semesterNameController = TextEditingController();
  final TextEditingController _newSemesterNameController =
      TextEditingController();

  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectDescController = TextEditingController();
  final TextEditingController _newSubjectNameController =
      TextEditingController();
  final TextEditingController _newSubjectDescController =
      TextEditingController();

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
  // 3. النوتيفايرز (Value Notifiers)
  // ===========================================================================
  final ValueNotifier<String?> _selectedYearToUpdateNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedSemesterToUpdateNotifier =
      ValueNotifier(null);

  final ValueNotifier<String?> _selectedYearForSubjectNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedSemesterNotifier = ValueNotifier(null);

  final ValueNotifier<String?> _subjManageYear = ValueNotifier(null);
  final ValueNotifier<String?> _subjManageSemester = ValueNotifier(null);
  final ValueNotifier<String?> _selectedSubjectToUpdateNotifier = ValueNotifier(
    null,
  );

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

  // متحكمات التبويبات الداخلية (Tabs) لكل قسم
  final ValueNotifier<int> _yearTabNotifier = ValueNotifier(0);
  final ValueNotifier<int> _semesterTabNotifier = ValueNotifier(0);
  final ValueNotifier<int> _subjectTabNotifier = ValueNotifier(0);
  final ValueNotifier<int> _lectureTabNotifier = ValueNotifier(0);

  // ===========================================================================
  // 4. القوائم المخبأة (Cached Data)
  // ===========================================================================
  List<year_model.Data> _cachedYears = [];
  List<sem_model.Data> _cachedSemesters = [];
  List<subj_model.Data> _cachedSubjects = [];
  List<lec_model.Data> _cachedLectures = [];

  final List<String> _lectureTypes = ['نظري', 'عملي'];

  // ===========================================================================
  // 5. دورة حياة الشاشة (Lifecycle)
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

  void _initCascadingResetListeners() {
    _subjManageYear.addListener(
      () => _selectedSubjectToUpdateNotifier.value = null,
    );
    _subjManageSemester.addListener(
      () => _selectedSubjectToUpdateNotifier.value = null,
    );

    _lecUploadYear.addListener(() => _lecUploadSubject.value = null);
    _lecUploadSemester.addListener(() => _lecUploadSubject.value = null);

    _lecManageYear.addListener(() => _resetLectureSelection());
    _lecManageSemester.addListener(() => _resetLectureSelection());
    _lecManageSubject.addListener(() => _resetLectureSelection());
    _lecManageType.addListener(() => _resetLectureSelection());
  }

  void _resetLectureSelection() {
    _selectedLectureToUpdateNotifier.value = null;
    _selectedLectureToDeleteNotifier.value = null;
    _cachedLectures.clear();
  }

  @override
  void dispose() {
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

    _yearTabNotifier.dispose();
    _semesterTabNotifier.dispose();
    _subjectTabNotifier.dispose();
    _lectureTabNotifier.dispose();
    super.dispose();
  }

  // ===========================================================================
  // 6. الدوال المساعدة الأساسية (Helper Methods)
  // ===========================================================================
  List<subj_model.Data> _getFilteredSubjects(
    String? yearId,
    String? semesterId,
  ) {
    if (yearId == null || semesterId == null) return [];
    return _cachedSubjects.where((subject) {
      String? getSafeId(dynamic field) {
        if (field == null) return null;
        if (field is String) return field.trim();
        if (field is int) return field.toString();
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

      return getSafeId((subject as dynamic).yearId) == yearId.trim() &&
          getSafeId((subject).semesterId) == semesterId.trim();
    }).toList();
  }

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
      _showErrorSnackBar(
        context,
        'يرجى تحديد كافة الفلاتر الأربعة أولاً',
        Theme.of(context),
      );
    }
  }

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
      if (mounted)
        _showErrorSnackBar(
          context,
          'خطأ أثناء اختيار الملف: $e',
          Theme.of(context),
        );
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

    final yearState = context.watch<YearCubit>().state;
    final semesterState = context.watch<SemesterCubit>().state;
    final subjectState = context.watch<SubjectCubit>().state;
    final lectureState = context.watch<LessonLectureCubit>().state;

    if (yearState is YearLoaded) _cachedYears = List.from(yearState.years);
    if (semesterState is SemesterLoaded)
      _cachedSemesters = List.from(semesterState.semesters);
    if (subjectState is GetSubjectsSuccess)
      _cachedSubjects = List.from(subjectState.subjectModel.data ?? []);
    if (lectureState is LessonLecturesLoaded)
      _cachedLectures = List.from(lectureState.lessonLectures);

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
            BlocListener<YearCubit, YearState>(
              listener: (context, state) {
                if (state is YearActionSuccess) {
                  _showSuccessSnackBar(context, state.message);
                  _yearNameController.clear();
                  _yearOrderController.clear();
                  _newYearNameController.clear();
                  _selectedYearToUpdateNotifier.value = null;
                  context.read<YearCubit>().fetchAllYears();
                } else if (state is YearError)
                  _showErrorSnackBar(context, state.message, theme);
              },
            ),
            BlocListener<SemesterCubit, SemesterState>(
              listener: (context, state) {
                if (state is SemesterActionSuccess) {
                  _showSuccessSnackBar(context, state.message);
                  _semesterNameController.clear();
                  _newSemesterNameController.clear();
                  _selectedSemesterToUpdateNotifier.value = null;
                  context.read<SemesterCubit>().fetchAllSemesters();
                } else if (state is SemesterError)
                  _showErrorSnackBar(context, state.message, theme);
              },
            ),
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
                  context.read<SubjectCubit>().getAllSubjects();
                } else if (state is SubjectActionFailure)
                  _showErrorSnackBar(context, state.errorMessage, theme);
              },
            ),
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
                  if (_lecManageYear.value != null &&
                      _lecManageSemester.value != null &&
                      _lecManageSubject.value != null) {
                    _fetchLecturesByFilters();
                  }
                } else if (state is LessonLectureError)
                  _showErrorSnackBar(context, state.message, theme);
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
                            'إدارة متقدمة للسنوات، الفصول، المواد، والمحاضرات',
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 24),
                        height: screenHeight * 0.004,
                        width: screenWidth * 0.40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),

                      // الأقسام الرئيسية مصممة بأسلوب Accordion
                      _buildExpandableSection(
                        title: 'إدارة السنوات الدراسية',
                        icon: Icons.calendar_month_outlined,
                        color: ColorsManager.blue,
                        children: [_buildYearsManagement(theme, screenHeight)],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      _buildExpandableSection(
                        title: 'إدارة الفصول الدراسية',
                        icon: Icons.layers_outlined,
                        color: ColorsManager.orange,
                        children: [
                          _buildSemestersManagement(theme, screenHeight),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      _buildExpandableSection(
                        title: 'إدارة المواد الأكاديمية',
                        icon: Icons.book_outlined,
                        color: ColorsManager.purpleAccent,
                        children: [
                          _buildSubjectsManagement(
                            theme,
                            screenHeight,
                            screenWidth,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      _buildExpandableSection(
                        title: 'إدارة المحاضرات',
                        icon: Icons.video_library_outlined,
                        color: ColorsManager.pomodoroPurple,
                        children: [
                          _buildLecturesManagement(
                            theme,
                            screenHeight,
                            screenWidth,
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
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
  // 8. بناء مكونات الواجهة الداخلية (UI Builders)
  // ===========================================================================

  Widget _buildYearsManagement(ThemeData theme, double screenHeight) {
    return _buildTabbedView(
      notifier: _yearTabNotifier,
      tabs: const ['إنشاء سنة', 'تعديل سنة'],
      views: [
        // Tab 0: إنشاء
        Form(
          key: _yearFormKey,
          child: Column(
            children: [
              AdminTextField(
                controller: _yearNameController,
                hint: 'اسم السنة (مثال: السنة الأولى)',
              ),
              SizedBox(height: screenHeight * 0.015),
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
                    if (mounted)
                      context.read<YearCubit>().addYear(
                        token,
                        _yearNameController.text.trim(),
                        int.tryParse(_yearOrderController.text.trim()) ?? 0,
                      );
                  }
                },
              ),
            ],
          ),
        ),
        // Tab 1: تعديل
        Form(
          key: _updateYearFormKey,
          child: Column(
            children: [
              AdminYearDropdown(
                hint: 'اختر السنة',
                notifier: _selectedYearToUpdateNotifier,
                yearsList: _cachedYears,
              ),
              SizedBox(height: screenHeight * 0.015),
              AdminTextField(
                controller: _newYearNameController,
                hint: 'الاسم الجديد',
              ),
              SizedBox(height: screenHeight * 0.02),
              AdminSubmitButton(
                title: 'حفظ التعديل',
                onPressed: () async {
                  if (_updateYearFormKey.currentState!.validate() &&
                      _selectedYearToUpdateNotifier.value != null) {
                    final token = await CachHelper.getValue('Token') ?? '';
                    if (mounted)
                      context.read<YearCubit>().updateYear(
                        token,
                        _selectedYearToUpdateNotifier.value!,
                        _newYearNameController.text.trim(),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ],
      theme: theme,
    );
  }

  Widget _buildSemestersManagement(ThemeData theme, double screenHeight) {
    return _buildTabbedView(
      notifier: _semesterTabNotifier,
      tabs: const ['إنشاء فصل', 'تعديل فصل'],
      views: [
        Form(
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
                  if (_semesterFormKey.currentState!.validate() && mounted) {
                    context.read<SemesterCubit>().createSemester(
                      _semesterNameController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        Form(
          key: _updateSemesterFormKey,
          child: Column(
            children: [
              _buildCustomGenericDropdown<sem_model.Data>(
                hint: 'اختر الفصل',
                notifier: _selectedSemesterToUpdateNotifier,
                itemsList: _cachedSemesters,
                extractId: (i) =>
                    (i).id?.toString() ?? (i).id?.toString() ?? '',
                extractName: (i) => (i).name ?? '',
              ),
              SizedBox(height: screenHeight * 0.015),
              AdminTextField(
                controller: _newSemesterNameController,
                hint: 'الاسم الجديد',
              ),
              SizedBox(height: screenHeight * 0.02),
              AdminSubmitButton(
                title: 'حفظ التعديل',
                onPressed: () {
                  if (_updateSemesterFormKey.currentState!.validate() &&
                      _selectedSemesterToUpdateNotifier.value != null &&
                      mounted) {
                    context.read<SemesterCubit>().updateSemester(
                      _selectedSemesterToUpdateNotifier.value!,
                      _newSemesterNameController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
      theme: theme,
    );
  }

  Widget _buildSubjectsManagement(
    ThemeData theme,
    double screenHeight,
    double screenWidth,
  ) {
    return _buildTabbedView(
      notifier: _subjectTabNotifier,
      tabs: const ['إنشاء مادة', 'تعديل مادة'],
      views: [
        Form(
          key: _subjectFormKey,
          child: Column(
            children: [
              AdminTextField(
                controller: _subjectNameController,
                hint: 'اسم المادة',
              ),
              SizedBox(height: screenHeight * 0.015),
              AdminTextField(
                controller: _subjectDescController,
                hint: 'وصف المادة',
                maxLines: 2,
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                children: [
                  Expanded(
                    child: AdminYearDropdown(
                      hint: 'السنة',
                      notifier: _selectedYearForSubjectNotifier,
                      yearsList: _cachedYears,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Expanded(
                    child: _buildCustomGenericDropdown<sem_model.Data>(
                      hint: 'الفصل',
                      notifier: _selectedSemesterNotifier,
                      itemsList: _cachedSemesters,
                      extractId: (i) =>
                          (i).id?.toString() ?? (i).id?.toString() ?? '',
                      extractName: (i) => (i).name ?? '',
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              AdminSubmitButton(
                title: 'إضافة المادة',
                onPressed: () {
                  if (_subjectFormKey.currentState!.validate() &&
                      _selectedYearForSubjectNotifier.value != null &&
                      _selectedSemesterNotifier.value != null &&
                      mounted) {
                    context.read<SubjectCubit>().createSubject(
                      name: _subjectNameController.text.trim(),
                      description: _subjectDescController.text.trim(),
                      createdBy: "Admin",
                      yearId: _selectedYearForSubjectNotifier.value!,
                      semesterId: _selectedSemesterNotifier.value!,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        ValueListenableBuilder<String?>(
          valueListenable: _subjManageYear,
          builder: (context, yId, _) => ValueListenableBuilder<String?>(
            valueListenable: _subjManageSemester,
            builder: (context, sId, _) {
              final matchingSubjects = _getFilteredSubjects(yId, sId);
              return Form(
                key: _updateSubjectFormKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AdminYearDropdown(
                            hint: 'حدد السنة',
                            notifier: _subjManageYear,
                            yearsList: _cachedYears,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: _buildCustomGenericDropdown<sem_model.Data>(
                            hint: 'حدد الفصل',
                            notifier: _subjManageSemester,
                            itemsList: _cachedSemesters,
                            extractId: (i) =>
                                (i).id?.toString() ?? (i).id?.toString() ?? '',
                            extractName: (i) => (i).name ?? '',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    _buildCustomGenericDropdown<subj_model.Data>(
                      hint: 'اختر المادة المراد تعديلها',
                      notifier: _selectedSubjectToUpdateNotifier,
                      itemsList: matchingSubjects,
                      extractId: (i) =>
                          (i).sId?.toString() ?? (i).sId?.toString() ?? '',
                      extractName: (i) => (i).name ?? '',
                      onSelectionChanged: (val) {
                        if (val != null && matchingSubjects.isNotEmpty) {
                          final match = matchingSubjects.firstWhere(
                            (s) =>
                                ((s).sId?.toString() ?? (s).sId?.toString()) ==
                                val,
                          );
                          _newSubjectNameController.text = (match).name ?? '';
                          _newSubjectDescController.text =
                              (match).description ?? '';
                        }
                      },
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    AdminTextField(
                      controller: _newSubjectNameController,
                      hint: 'الاسم الجديد',
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    AdminTextField(
                      controller: _newSubjectDescController,
                      hint: 'الوصف الجديد',
                      maxLines: 2,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    AdminSubmitButton(
                      title: 'حفظ تعديل المادة',
                      onPressed: () {
                        if (_updateSubjectFormKey.currentState!.validate() &&
                            _selectedSubjectToUpdateNotifier.value != null &&
                            mounted) {
                          context.read<SubjectCubit>().updateSubject(
                            subjectId: _selectedSubjectToUpdateNotifier.value!,
                            name: _newSubjectNameController.text.trim(),
                            description: _newSubjectDescController.text.trim(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
      theme: theme,
    );
  }

  Widget _buildLecturesManagement(
    ThemeData theme,
    double screenHeight,
    double screenWidth,
  ) {
    return _buildTabbedView(
      notifier: _lectureTabNotifier,
      tabs: const ['رفع محاضرة', 'إدارة المحاضرات'],
      views: [
        // Tab 0: رفع
        Form(
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
                  SizedBox(width: screenWidth * 0.02),
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
              SizedBox(height: screenHeight * 0.015),
              ValueListenableBuilder<String?>(
                valueListenable: _lecUploadYear,
                builder: (context, yId, _) => ValueListenableBuilder<String?>(
                  valueListenable: _lecUploadSemester,
                  builder: (context, sId, _) =>
                      _buildCustomGenericDropdown<subj_model.Data>(
                        hint: 'المادة',
                        notifier: _lecUploadSubject,
                        itemsList: _getFilteredSubjects(yId, sId),
                        extractId: (i) =>
                            (i).sId?.toString() ?? (i).sId?.toString() ?? '',
                        extractName: (i) => (i).name ?? '',
                      ),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              AdminTextField(
                controller: _lectureTitleController,
                hint: 'عنوان المحاضرة',
              ),
              SizedBox(height: screenHeight * 0.015),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: AdminTextField(
                      controller: _lectureFilePathController,
                      hint: 'مسار الملف المختار',
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.02),
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
              SizedBox(height: screenHeight * 0.015),
              Row(
                children: [
                  Expanded(
                    child: _buildTextDropdownOnly(
                      hint: 'النوع',
                      notifier: _lecUploadType,
                      elements: _lectureTypes,
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLecturePublished,
                      builder: (context, published, _) => Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
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
                          dense: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              AdminSubmitButton(
                title: 'رفع ونشر المحاضرة',
                onPressed: () async {
                  if (_lectureFormKey.currentState!.validate() &&
                      _lecUploadSubject.value != null &&
                      _lecUploadType.value != null &&
                      _lectureFilePathController.text.isNotEmpty) {
                    final token = await CachHelper.getValue('Token') ?? '';
                    if (mounted) {
                      String backendType = _lecUploadType.value! == 'عملي'
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
                  }
                },
              ),
            ],
          ),
        ),

        // Tab 1: إدارة (تعديل وحذف)
        Column(
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
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: _buildCustomGenericDropdown<sem_model.Data>(
                    hint: 'الفصل',
                    notifier: _lecManageSemester,
                    itemsList: _cachedSemesters,
                    extractId: (i) =>
                        (i).id?.toString() ?? (i).id?.toString() ?? '',
                    extractName: (i) => (i).name ?? '',
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            ValueListenableBuilder<String?>(
              valueListenable: _lecManageYear,
              builder: (context, yId, _) => ValueListenableBuilder<String?>(
                valueListenable: _lecManageSemester,
                builder: (context, sId, _) => Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildCustomGenericDropdown<subj_model.Data>(
                        hint: 'المادة',
                        notifier: _lecManageSubject,
                        itemsList: _getFilteredSubjects(yId, sId),
                        extractId: (i) =>
                            (i).sId?.toString() ?? (i).sId?.toString() ?? '',
                        extractName: (i) => (i).name ?? '',
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
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
            SizedBox(height: screenHeight * 0.015),
            ElevatedButton.icon(
              onPressed: _fetchLecturesByFilters,
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              label: const Text(
                'جلب المحاضرات',
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
            const Divider(height: 30),
            BlocBuilder<LessonLectureCubit, LessonLectureState>(
              builder: (context, state) {
                if (_cachedLectures.isEmpty)
                  return const Text(
                    'لا توجد محاضرات تطابق الفلاتر المحددة.',
                    style: TextStyle(color: ColorsManager.greyText),
                  );
                return Column(
                  children: [
                    Form(
                      key: _updateLectureFormKey,
                      child: Column(
                        children: [
                          _buildCustomGenericDropdown<lec_model.Data>(
                            hint: 'حدد المحاضرة',
                            notifier: _selectedLectureToUpdateNotifier,
                            itemsList: _cachedLectures,
                            extractId: (i) =>
                                (i).id?.toString() ?? (i).id?.toString() ?? '',
                            extractName: (i) => (i).title ?? '',
                            onSelectionChanged: (val) {
                              if (val != null) {
                                final lecture = _cachedLectures.firstWhere(
                                  (l) =>
                                      ((l).id?.toString() ??
                                          (l).id?.toString()) ==
                                      val,
                                );
                                _newLectureTitleController.text =
                                    lecture.title ?? '';
                                _newLectureDescController.text =
                                    lecture.description ?? '';
                                _newLectureFilePathController.clear();
                                _selectedLectureToDeleteNotifier.value =
                                    val; // Sync delete notifier
                              }
                            },
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          AdminTextField(
                            controller: _newLectureTitleController,
                            hint: 'العنوان الجديد',
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: AdminTextField(
                                  controller: _newLectureFilePathController,
                                  hint: 'رفع ملف جديد (اختياري)',
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
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
                          SizedBox(height: screenHeight * 0.015),
                          Row(
                            children: [
                              Expanded(
                                child: AdminSubmitButton(
                                  title: 'حفظ التعديل',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  onPressed: () async {
                                    if (_updateLectureFormKey.currentState!
                                            .validate() &&
                                        _selectedLectureToUpdateNotifier
                                                .value !=
                                            null &&
                                        mounted) {
                                      final token =
                                          await CachHelper.getValue('Token') ??
                                          '';
                                      context
                                          .read<LessonLectureCubit>()
                                          .updateLecture(
                                            token,
                                            _selectedLectureToUpdateNotifier
                                                .value!,
                                            _newLectureTitleController.text
                                                .trim(),
                                            _newLectureDescController.text
                                                .trim(),
                                            _newLectureFilePathController
                                                    .text
                                                    .isNotEmpty
                                                ? _newLectureFilePathController
                                                      .text
                                                      .trim()
                                                : null,
                                          );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Form(
                                  key: _deleteLectureFormKey,
                                  child: AdminSubmitButton(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                        0.035,
                                    title: 'حذف المحاضرة',
                                    isDestructive: true,
                                    onPressed: () async {
                                      if (_selectedLectureToDeleteNotifier
                                                  .value !=
                                              null &&
                                          mounted) {
                                        final token =
                                            await CachHelper.getValue(
                                              'Token',
                                            ) ??
                                            '';
                                        context
                                            .read<LessonLectureCubit>()
                                            .deleteLecture(
                                              token,
                                              _selectedLectureToDeleteNotifier
                                                  .value!,
                                            );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
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
      ],
      theme: theme,
    );
  }

  // ===========================================================================
  // 9. دوال تصميم الحاويات والأدوات الذكية
  // ===========================================================================

  /// تصميم البطاقة القابلة للتمدد (Accordion)
  Widget _buildExpandableSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedIconColor: color,
          iconColor: color,
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
                top: 0,
              ),
              child: Column(children: children),
            ),
          ],
        ),
      ),
    );
  }

  /// تصميم التنقل بين التبويبات (Tabs) داخل البطاقة
  Widget _buildTabbedView({
    required ValueNotifier<int> notifier,
    required List<String> tabs,
    required List<Widget> views,
    required ThemeData theme,
  }) {
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (context, currentIndex, _) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = currentIndex == index;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => notifier.value = index,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3),
                                    blurRadius: 4,
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          tabs[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: views[currentIndex],
            ),
          ],
        );
      },
    );
  }

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
            fillColor: Theme.of(context).scaffoldBackgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: itemsList
              .map(
                (item) => DropdownMenuItem<String>(
                  value: extractId(item),
                  child: Text(
                    extractName(item),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            notifier.value = value;
            if (onSelectionChanged != null) onSelectionChanged(value);
          },
          validator: (value) => value == null ? 'الحقل إلزامي' : null,
        );
      },
    );
  }

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
          fillColor: Theme.of(context).scaffoldBackgroundColor,
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
        validator: (val) => val == null ? 'مطلوب' : null,
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ColorsManager.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext ctx, String msg, ThemeData theme) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
