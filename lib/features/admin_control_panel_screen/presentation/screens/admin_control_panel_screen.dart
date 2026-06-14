import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/years/models/year_model.dart';
import 'package:bluebits_app/core/shares/years/presentation/logic/year_cubit.dart';
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/lectures/presentation/widget/page_headers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminControlPanelScreen extends StatefulWidget {
  const AdminControlPanelScreen({super.key});

  @override
  State<AdminControlPanelScreen> createState() =>
      _AdminControlPanelScreenState();
}

class _AdminControlPanelScreenState extends State<AdminControlPanelScreen> {
  // مفاتيح النماذج
  final _yearFormKey = GlobalKey<FormState>();
  final _updateYearFormKey = GlobalKey<FormState>();
  final _deleteYearFormKey = GlobalKey<FormState>();
  final _semesterFormKey = GlobalKey<FormState>();
  final _subjectFormKey = GlobalKey<FormState>();

  // متحكمات الحقول
  final TextEditingController _yearNameController = TextEditingController();
  final TextEditingController _yearOrderController = TextEditingController();
  final TextEditingController _newYearNameController = TextEditingController();
  final TextEditingController _semesterNameController = TextEditingController();
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectDescController = TextEditingController();

  // ValueNotifiers لإدارة القوائم المنسدلة بفعالية
  final ValueNotifier<String?> _selectedYearToUpdateNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedYearToDeleteNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedYearForSubjectNotifier = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _selectedSemesterNotifier = ValueNotifier(null);

  // قائمة محلية تستقبل البيانات المرتبة من الكيوبت
  List<Data> _cachedYears = [];

  @override
  void dispose() {
    _yearNameController.dispose();
    _yearOrderController.dispose();
    _newYearNameController.dispose();
    _semesterNameController.dispose();
    _subjectNameController.dispose();
    _subjectDescController.dispose();

    _selectedYearToUpdateNotifier.dispose();
    _selectedYearToDeleteNotifier.dispose();
    _selectedYearForSubjectNotifier.dispose();
    _selectedSemesterNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: BlocConsumer<YearCubit, YearState>(
          listener: (context, state) {
            if (state is YearActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: ColorsManager.green,
                ),
              );

              // تفريغ الحقول بعد النجاح
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
          builder: (context, state) {
            // استقبال القائمة المرتبة تنازلياً من الكيوبت كما هي
            if (state is YearLoaded) {
              _cachedYears = List.from(state.years);
            }

            return SafeArea(
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
                          subtitle: 'إدارة وإنشاء وتعديل وحذف السنوات والفصول',
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: screenHeight * 0.004,
                          width: screenWidth * 0.60,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(height: screenHeight * 0.04),

                        // ==========================================
                        // 1. قسم إنشاء سنة جديدة
                        // ==========================================
                        _buildSectionContainer(
                          context: context,
                          title: 'إنشاء سنة جديدة',
                          icon: Icons.calendar_month_outlined,
                          color: ColorsManager.blue,
                          child: Form(
                            key: _yearFormKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _yearNameController,
                                  hint: 'اسم السنة (مثال: السنة الأولى)',
                                  theme: theme,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _buildTextField(
                                  controller: _yearOrderController,
                                  hint: 'ترتيب السنة (رقم فقط، مثال: 1)',
                                  isNumber: true,
                                  theme: theme,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _buildSubmitButton(
                                  title: 'إضافة السنة',
                                  onPressed: () async {
                                    if (_yearFormKey.currentState!.validate()) {
                                      final token =
                                          await CachHelper.getValue('Token') ??
                                          '';
                                      final name = _yearNameController.text
                                          .trim();
                                      final order =
                                          int.tryParse(
                                            _yearOrderController.text.trim(),
                                          ) ??
                                          0;

                                      if (context.mounted) {
                                        context.read<YearCubit>().addYear(
                                          token,
                                          name,
                                          order,
                                        );
                                      }
                                    }
                                  },
                                  theme: theme,
                                  screenWidth: screenWidth,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // ==========================================
                        // 2. قسم تعديل سنة موجودة
                        // ==========================================
                        _buildSectionContainer(
                          context: context,
                          title: 'تعديل اسم سنة دراسية',
                          icon: Icons.edit_calendar_outlined,
                          color: ColorsManager.green,
                          child: Form(
                            key: _updateYearFormKey,
                            child: Column(
                              children: [
                                _buildYearObjectDropdown(
                                  hint: 'اختر السنة المراد تعديلها',
                                  notifier: _selectedYearToUpdateNotifier,
                                  yearsList: _cachedYears,
                                  theme: theme,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _buildTextField(
                                  controller: _newYearNameController,
                                  hint: 'الاسم الجديد للسنة',
                                  theme: theme,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _buildSubmitButton(
                                  title: 'حفظ التعديل',
                                  onPressed: () async {
                                    if (_updateYearFormKey.currentState!
                                        .validate()) {
                                      final token =
                                          await CachHelper.getValue('Token') ??
                                          '';
                                      final yearId =
                                          _selectedYearToUpdateNotifier.value!;
                                      final newName = _newYearNameController
                                          .text
                                          .trim();

                                      if (context.mounted) {
                                        context.read<YearCubit>().updateYear(
                                          token,
                                          yearId,
                                          newName,
                                        );
                                      }
                                    }
                                  },
                                  theme: theme,
                                  screenWidth: screenWidth,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // ==========================================
                        // 3. قسم حذف سنة دراسية
                        // ==========================================
                        _buildSectionContainer(
                          context: context,
                          title: 'حذف سنة دراسية',
                          icon: Icons.delete_outline_rounded,
                          color: theme.colorScheme.error,
                          child: Form(
                            key: _deleteYearFormKey,
                            child: Column(
                              children: [
                                _buildYearObjectDropdown(
                                  hint: 'اختر السنة المراد حذفها',
                                  notifier: _selectedYearToDeleteNotifier,
                                  yearsList: _cachedYears,
                                  theme: theme,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _buildSubmitButton(
                                  title: 'حذف السنة نهائياً',
                                  onPressed: () async {
                                    if (_deleteYearFormKey.currentState!
                                        .validate()) {
                                      final token =
                                          await CachHelper.getValue('Token') ??
                                          '';
                                      final yearId =
                                          _selectedYearToDeleteNotifier.value!;

                                      if (context.mounted) {
                                        context.read<YearCubit>().deleteYear(
                                          token,
                                          yearId,
                                        );
                                      }
                                    }
                                  },
                                  theme: theme,
                                  screenWidth: screenWidth,
                                  isDestructive: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // ==========================================
                        // 4. قسم إنشاء فصل جديد
                        // ==========================================
                        _buildSectionContainer(
                          context: context,
                          title: 'إنشاء فصل دراسي',
                          icon: Icons.layers_outlined,
                          color: ColorsManager.orange,
                          child: Form(
                            key: _semesterFormKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _semesterNameController,
                                  hint: 'اسم الفصل (مثال: الفصل الأول)',
                                  theme: theme,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _buildSubmitButton(
                                  title: 'إضافة الفصل',
                                  onPressed: () {
                                    if (_semesterFormKey.currentState!
                                        .validate()) {
                                      // سيتم ربطها لاحقاً
                                    }
                                  },
                                  theme: theme,
                                  screenWidth: screenWidth,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        // ==========================================
                        // 5. قسم إنشاء مادة جديدة
                        // ==========================================
                        _buildSectionContainer(
                          context: context,
                          title: 'إنشاء مادة جديدة',
                          icon: Icons.book_outlined,
                          color: ColorsManager.purpleAccent,
                          child: Form(
                            key: _subjectFormKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                  controller: _subjectNameController,
                                  hint: 'اسم المادة (مثال: أمن الشبكات)',
                                  theme: theme,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                _buildTextField(
                                  controller: _subjectDescController,
                                  hint: 'وصف المادة',
                                  maxLines: 3,
                                  theme: theme,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildYearObjectDropdown(
                                        hint: 'اختر السنة',
                                        notifier:
                                            _selectedYearForSubjectNotifier,
                                        yearsList: _cachedYears,
                                        theme: theme,
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.03),
                                    Expanded(
                                      child: _buildSimpleDropdown(
                                        hint: 'اختر الفصل',
                                        notifier: _selectedSemesterNotifier,
                                        items: const [
                                          'الفصل الأول',
                                          'الفصل الثاني',
                                        ],
                                        theme: theme,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.03),
                                _buildSubmitButton(
                                  title: 'إضافة المادة',
                                  onPressed: () {
                                    if (_subjectFormKey.currentState!
                                        .validate()) {
                                      // سيتم ربطها لاحقاً
                                    }
                                  },
                                  theme: theme,
                                  screenWidth: screenWidth,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                      ],
                    ),
                  ),

                  if (state is YearLoading)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ----------- توابع البناء المنفصلة -----------

  Widget _buildSectionContainer({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: screenWidth * 0.04,
            offset: Offset(0, screenWidth * 0.015),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: screenWidth * 0.07),
              SizedBox(width: screenWidth * 0.03),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 0.5),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required ThemeData theme,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  Widget _buildYearObjectDropdown({
    required String hint,
    required ValueNotifier<String?> notifier,
    required List<Data> yearsList,
    required ThemeData theme,
  }) {
    return ValueListenableBuilder<String?>(
      valueListenable: notifier,
      builder: (context, value, child) {
        // حماية الواجهة في حال تم حذف السنة التي كانت محددة
        final isValueValid = yearsList.any((element) => element.sId == value);
        final safeValue = isValueValid ? value : null;

        return DropdownButtonFormField<String>(
          value: safeValue,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.primary,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
          hint: Text(
            hint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          items: yearsList.map((yearItem) {
            return DropdownMenuItem<String>(
              value: yearItem.sId,
              child: Text(
                yearItem.name ?? 'بدون اسم',
                style: theme.textTheme.bodyLarge,
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            notifier.value = newValue;
          },
          validator: (val) => val == null ? 'مطلوب' : null,
        );
      },
    );
  }

  Widget _buildSimpleDropdown({
    required String hint,
    required ValueNotifier<String?> notifier,
    required List<String> items,
    required ThemeData theme,
  }) {
    return ValueListenableBuilder<String?>(
      valueListenable: notifier,
      builder: (context, value, child) {
        return DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.primary,
          ),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
          hint: Text(
            hint,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: theme.textTheme.bodyLarge),
            );
          }).toList(),
          onChanged: (newValue) {
            notifier.value = newValue;
          },
          validator: (val) => val == null ? 'مطلوب' : null,
        );
      },
    );
  }

  Widget _buildSubmitButton({
    required String title,
    required VoidCallback onPressed,
    required ThemeData theme,
    required double screenWidth,
    bool isDestructive = false,
  }) {
    return SizedBox(
      width: screenWidth,
      height: screenWidth * 0.12,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDestructive
              ? theme.colorScheme.error
              : theme.colorScheme.primary,
          foregroundColor: isDestructive
              ? theme.colorScheme.onError
              : theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
