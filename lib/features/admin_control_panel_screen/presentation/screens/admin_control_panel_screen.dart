import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/semester/semester_cubit/semester_cubit.dart';
import 'package:bluebits_app/core/shares/subjects/subjects_cubit/subject_cubit.dart';
import 'package:bluebits_app/core/shares/years/models/year_model.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_section_container.dart';
// import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_simple_dropdown.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_submit_button.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_text_field.dart';
import 'package:bluebits_app/features/admin_control_panel_screen/presentation/widjets/admin_year_dropdown.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  // ==========================================
  // 1. مفاتيح النماذج
  // ==========================================
  final _yearFormKey = GlobalKey<FormState>();
  final _updateYearFormKey = GlobalKey<FormState>();
  final _deleteYearFormKey = GlobalKey<FormState>();

  final _semesterFormKey = GlobalKey<FormState>();
  final _updateSemesterFormKey = GlobalKey<FormState>();
  final _deleteSemesterFormKey = GlobalKey<FormState>();

  final _subjectFormKey = GlobalKey<FormState>();
  final _updateSubjectFormKey = GlobalKey<FormState>();
  final _deleteSubjectFormKey = GlobalKey<FormState>();

  // ==========================================
  // 2. متحكمات النصوص
  // ==========================================
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

  // ==========================================
  // 3. النوتيفايرز للقوائم المنسدلة
  // ==========================================
  final ValueNotifier<String?> _selectedYearToUpdateNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedYearToDeleteNotifier = ValueNotifier(
    null,
  );

  final ValueNotifier<String?> _selectedSemesterToUpdateNotifier =
      ValueNotifier(null);
  final ValueNotifier<String?> _selectedSemesterToDeleteNotifier =
      ValueNotifier(null);

  final ValueNotifier<String?> _selectedYearForSubjectNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedSemesterNotifier = ValueNotifier(null);

  final ValueNotifier<String?> _selectedSubjectToUpdateNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedSubjectToDeleteNotifier = ValueNotifier(
    null,
  );

  // ==========================================
  // 4. التخزين المؤقت للبيانات
  // ==========================================
  List<Data> _cachedYears = [];
  List<sem_model.Data> _cachedSemesters = [];
  List<subj_model.Data> _cachedSubjects = [];

  @override
  void initState() {
    super.initState();
    context.read<YearCubit>().fetchAllYears();
    context.read<SemesterCubit>().fetchAllSemesters();
    // جلب المواد عند فتح الشاشة
    context.read<SubjectCubit>().getAllSubjects();
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

    _selectedYearToUpdateNotifier.dispose();
    _selectedYearToDeleteNotifier.dispose();

    _selectedSemesterToUpdateNotifier.dispose();
    _selectedSemesterToDeleteNotifier.dispose();

    _selectedYearForSubjectNotifier.dispose();
    _selectedSemesterNotifier.dispose();
    _selectedSubjectToUpdateNotifier.dispose();
    _selectedSubjectToDeleteNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    // ==========================================
    // مراقبة الحالات لجلب البيانات
    // ==========================================
    final yearState = context.watch<YearCubit>().state;
    final semesterState = context.watch<SemesterCubit>().state;
    final subjectState = context.watch<SubjectCubit>().state;

    if (yearState is YearLoaded) {
      _cachedYears = List.from(yearState.years);
    }
    if (semesterState is SemesterLoaded) {
      _cachedSemesters = List.from(semesterState.semesters);
    }
    if (subjectState is GetSubjectsSuccess) {
      _cachedSubjects = List.from(subjectState.subjectModel.data ?? []);
    }

    final bool isLoading =
        yearState is YearLoading ||
        semesterState is SemesterLoading ||
        subjectState is GetSubjectsLoading ||
        subjectState is SubjectActionLoading;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: MultiBlocListener(
          listeners: [
            // مستمع السنوات
            BlocListener<YearCubit, YearState>(
              listener: (context, state) {
                if (state is YearActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: ColorsManager.green,
                    ),
                  );
                  _yearNameController.clear();
                  _yearOrderController.clear();
                  _newYearNameController.clear();
                  _selectedYearToUpdateNotifier.value = null;
                  _selectedYearToDeleteNotifier.value = null;
                } else if (state is YearError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
            ),

            // مستمع الفصول
            BlocListener<SemesterCubit, SemesterState>(
              listener: (context, state) {
                if (state is SemesterActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: ColorsManager.green,
                    ),
                  );
                  _semesterNameController.clear();
                  _newSemesterNameController.clear();
                  _selectedSemesterToUpdateNotifier.value = null;
                  _selectedSemesterToDeleteNotifier.value = null;
                } else if (state is SemesterError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
            ),

            // مستمع المواد
            BlocListener<SubjectCubit, SubjectState>(
              listener: (context, state) {
                if (state is SubjectActionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: ColorsManager.green,
                    ),
                  );
                  _subjectNameController.clear();
                  _subjectDescController.clear();
                  _newSubjectNameController.clear();
                  _newSubjectDescController.clear();
                  _selectedYearForSubjectNotifier.value = null;
                  _selectedSemesterNotifier.value = null;
                  _selectedSubjectToUpdateNotifier.value = null;
                  _selectedSubjectToDeleteNotifier.value = null;

                  // تحديث قائمة المواد بعد أي عملية نجاح (إضافة، تعديل، حذف)
                  context.read<SubjectCubit>().getAllSubjects();
                } else if (state is SubjectActionFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
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
                            'إدارة وإنشاء وتعديل وحذف السنوات والفصول والمواد',
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: screenHeight * 0.004,
                        width: screenWidth * 0.60,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // ========================================================
                      // أجزاء السنوات الدراسية
                      // ========================================================
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
                                    final token =
                                        await CachHelper.getValue('Token') ??
                                        '';
                                    if (context.mounted) {
                                      context.read<YearCubit>().addYear(
                                        token,
                                        _yearNameController.text.trim(),
                                        int.tryParse(
                                              _yearOrderController.text.trim(),
                                            ) ??
                                            0,
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
                                  if (_updateYearFormKey.currentState!
                                      .validate()) {
                                    final token =
                                        await CachHelper.getValue('Token') ??
                                        '';
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
                                  if (_deleteYearFormKey.currentState!
                                      .validate()) {
                                    final token =
                                        await CachHelper.getValue('Token') ??
                                        '';
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

                      // ========================================================
                      // أجزاء الفصول الدراسية
                      // ========================================================
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
                                  if (_semesterFormKey.currentState!
                                      .validate()) {
                                    if (context.mounted) {
                                      context
                                          .read<SemesterCubit>()
                                          .createSemester(
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

                      AdminSectionContainer(
                        title: 'تعديل اسم فصل دراسي',
                        icon: Icons.edit_note_rounded,
                        color: ColorsManager.orange,
                        child: Form(
                          key: _updateSemesterFormKey,
                          child: Column(
                            children: [
                              ValueListenableBuilder<String?>(
                                valueListenable:
                                    _selectedSemesterToUpdateNotifier,
                                builder: (context, selectedValue, _) {
                                  final isValueValid = _cachedSemesters.any(
                                    (element) =>
                                        element.id?.toString() == selectedValue,
                                  );
                                  final safeValue = isValueValid
                                      ? selectedValue
                                      : null;

                                  return DropdownButtonFormField<String>(
                                    value: safeValue,
                                    isExpanded:
                                        true, // تم إضافة هذه الخاصية لمنع الخطأ
                                    hint: Text(
                                      'اختر الفصل المراد تعديله',
                                      style: theme.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: theme.cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: _cachedSemesters.map((semester) {
                                      return DropdownMenuItem<String>(
                                        value: semester.id?.toString(),
                                        child: Text(
                                          semester.name ?? 'بدون اسم',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        _selectedSemesterToUpdateNotifier
                                                .value =
                                            value,
                                    validator: (value) => value == null
                                        ? 'يرجى اختيار الفصل'
                                        : null,
                                  );
                                },
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
                                  if (_updateSemesterFormKey.currentState!
                                      .validate()) {
                                    if (context.mounted) {
                                      context
                                          .read<SemesterCubit>()
                                          .updateSemester(
                                            _selectedSemesterToUpdateNotifier
                                                .value!,
                                            _newSemesterNameController.text
                                                .trim(),
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

                      AdminSectionContainer(
                        title: 'حذف فصل دراسي',
                        icon: Icons.delete_sweep_outlined,
                        color: theme.colorScheme.error,
                        child: Form(
                          key: _deleteSemesterFormKey,
                          child: Column(
                            children: [
                              ValueListenableBuilder<String?>(
                                valueListenable:
                                    _selectedSemesterToDeleteNotifier,
                                builder: (context, selectedValue, _) {
                                  final isValueValid = _cachedSemesters.any(
                                    (element) =>
                                        element.id?.toString() == selectedValue,
                                  );
                                  final safeValue = isValueValid
                                      ? selectedValue
                                      : null;

                                  return DropdownButtonFormField<String>(
                                    value: safeValue,
                                    isExpanded:
                                        true, // تم إضافة هذه الخاصية لمنع الخطأ
                                    hint: Text(
                                      'اختر الفصل المراد حذفه',
                                      style: theme.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: theme.cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: _cachedSemesters.map((semester) {
                                      return DropdownMenuItem<String>(
                                        value: semester.id?.toString(),
                                        child: Text(
                                          semester.name ?? 'بدون اسم',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        _selectedSemesterToDeleteNotifier
                                                .value =
                                            value,
                                    validator: (value) => value == null
                                        ? 'يرجى اختيار الفصل'
                                        : null,
                                  );
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              AdminSubmitButton(
                                title: 'حذف الفصل نهائياً',
                                isDestructive: true,
                                onPressed: () async {
                                  if (_deleteSemesterFormKey.currentState!
                                      .validate()) {
                                    if (context.mounted) {
                                      context
                                          .read<SemesterCubit>()
                                          .deleteSemester(
                                            _selectedSemesterToDeleteNotifier
                                                .value!,
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

                      // ========================================================
                      // أجزاء المواد الدراسية (الإنشاء - التعديل - الحذف)
                      // ========================================================

                      // 1. إنشاء مادة
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
                                    child: ValueListenableBuilder<String?>(
                                      valueListenable:
                                          _selectedSemesterNotifier,
                                      builder: (context, selectedValue, _) {
                                        final isValueValid = _cachedSemesters
                                            .any(
                                              (element) =>
                                                  element.id?.toString() ==
                                                  selectedValue,
                                            );
                                        final safeValue = isValueValid
                                            ? selectedValue
                                            : null;

                                        return DropdownButtonFormField<String>(
                                          value: safeValue,
                                          isExpanded:
                                              true, // تم إضافة هذه الخاصية مهمة جداً داخل الـ Row
                                          hint: Text(
                                            'اختر الفصل',
                                            style: theme.textTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          decoration: const InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 15,
                                                ),
                                          ),
                                          items: _cachedSemesters.map((
                                            semester,
                                          ) {
                                            return DropdownMenuItem<String>(
                                              value: semester.id?.toString(),
                                              child: Text(
                                                semester.name ?? 'بدون اسم',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (value) =>
                                              _selectedSemesterNotifier.value =
                                                  value,
                                          validator: (value) =>
                                              value == null ? 'مطلوب' : null,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              AdminSubmitButton(
                                title: 'إضافة المادة',
                                onPressed: () async {
                                  if (_subjectFormKey.currentState!
                                      .validate()) {
                                    if (context.mounted) {
                                      context
                                          .read<SubjectCubit>()
                                          .createSubject(
                                            name: _subjectNameController.text
                                                .trim(),
                                            description: _subjectDescController
                                                .text
                                                .trim(),
                                            createdBy: "Admin",
                                            yearId:
                                                _selectedYearForSubjectNotifier
                                                    .value!,
                                            semesterId:
                                                _selectedSemesterNotifier
                                                    .value!,
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

                      // 2. تعديل مادة
                      AdminSectionContainer(
                        title: 'تعديل بيانات مادة',
                        icon: Icons.edit_document,
                        color: Colors.teal,
                        child: Form(
                          key: _updateSubjectFormKey,
                          child: Column(
                            children: [
                              ValueListenableBuilder<String?>(
                                valueListenable:
                                    _selectedSubjectToUpdateNotifier,
                                builder: (context, selectedValue, _) {
                                  final isValueValid = _cachedSubjects.any(
                                    (element) => element.sId == selectedValue,
                                  );
                                  final safeValue = isValueValid
                                      ? selectedValue
                                      : null;

                                  return DropdownButtonFormField<String>(
                                    value: safeValue,
                                    isExpanded:
                                        true, // تم إضافة هذه الخاصية لمنع الخطأ
                                    hint: Text(
                                      'اختر المادة المراد تعديلها',
                                      style: theme.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: theme.cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: _cachedSubjects.map((subject) {
                                      return DropdownMenuItem<String>(
                                        value: subject.sId,
                                        child: Text(
                                          subject.name ?? 'بدون اسم',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      _selectedSubjectToUpdateNotifier.value =
                                          value;
                                      // تعبئة الحقول بالبيانات الحالية
                                      final selectedSubject = _cachedSubjects
                                          .firstWhere(
                                            (element) => element.sId == value,
                                          );
                                      _newSubjectNameController.text =
                                          selectedSubject.name ?? '';
                                      _newSubjectDescController.text =
                                          selectedSubject.description ?? '';
                                    },
                                    validator: (value) => value == null
                                        ? 'يرجى اختيار المادة'
                                        : null,
                                  );
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
                                      .validate()) {
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
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // 3. حذف مادة
                      AdminSectionContainer(
                        title: 'حذف مادة',
                        icon: Icons.delete_forever_outlined,
                        color: theme.colorScheme.error,
                        child: Form(
                          key: _deleteSubjectFormKey,
                          child: Column(
                            children: [
                              ValueListenableBuilder<String?>(
                                valueListenable:
                                    _selectedSubjectToDeleteNotifier,
                                builder: (context, selectedValue, _) {
                                  final isValueValid = _cachedSubjects.any(
                                    (element) => element.sId == selectedValue,
                                  );
                                  final safeValue = isValueValid
                                      ? selectedValue
                                      : null;

                                  return DropdownButtonFormField<String>(
                                    value: safeValue,
                                    isExpanded:
                                        true, // تم إضافة هذه الخاصية لمنع الخطأ
                                    hint: Text(
                                      'اختر المادة المراد حذفها',
                                      style: theme.textTheme.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: theme.cardColor,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    items: _cachedSubjects.map((subject) {
                                      return DropdownMenuItem<String>(
                                        value: subject.sId,
                                        child: Text(
                                          subject.name ?? 'بدون اسم',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) =>
                                        _selectedSubjectToDeleteNotifier.value =
                                            value,
                                    validator: (value) => value == null
                                        ? 'يرجى اختيار المادة'
                                        : null,
                                  );
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              AdminSubmitButton(
                                title: 'حذف المادة نهائياً',
                                isDestructive: true,
                                onPressed: () {
                                  if (_deleteSubjectFormKey.currentState!
                                      .validate()) {
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
}
