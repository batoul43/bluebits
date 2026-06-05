import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/core/widget/page_headers.dart';
import 'package:flutter/material.dart';

class AdminControlPanelScreen extends StatefulWidget {
  const AdminControlPanelScreen({super.key});

  @override
  State<AdminControlPanelScreen> createState() =>
      _AdminControlPanelScreenState();
}

class _AdminControlPanelScreenState extends State<AdminControlPanelScreen> {
  // مفاتيح النماذج (Forms) للتحقق من صحة الإدخال
  final _yearFormKey = GlobalKey<FormState>();
  final _semesterFormKey = GlobalKey<FormState>();
  final _subjectFormKey = GlobalKey<FormState>();

  // متحكمات الحقول للسنة
  final TextEditingController _yearNameController = TextEditingController();
  final TextEditingController _yearOrderController = TextEditingController();

  // متحكمات الحقول للفصل
  final TextEditingController _semesterNameController = TextEditingController();

  // متحكمات الحقول للمادة
  final TextEditingController _subjectNameController = TextEditingController();
  final TextEditingController _subjectDescController = TextEditingController();

  // قيم مبدئية للقوائم المنسدلة (سيتم ربطها لاحقاً بـ API)
  String? _selectedYear;
  String? _selectedSemester;

  @override
  void dispose() {
    _yearNameController.dispose();
    _yearOrderController.dispose();
    _semesterNameController.dispose();
    _subjectNameController.dispose();
    _subjectDescController.dispose();
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
                // ترويسة الصفحة
                const PageHeader(
                  title: 'لوحة التحكم',
                  subtitle: 'إدارة وإنشاء السنوات، الفصول والمواد الأكاديمية',
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: screenHeight * 0.004,
                  width: screenWidth * 0.60,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: screenHeight * 0.04),

                // 1. قسم إنشاء سنة جديدة
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
                          hint: 'اسم السنة (مثال: Year 5)',
                          theme: theme,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        _buildTextField(
                          controller: _yearOrderController,
                          hint: 'ترتيب السنة (مثال: 5)',
                          isNumber: true,
                          theme: theme,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        _buildSubmitButton(
                          title: 'إضافة السنة',
                          onPressed: () {
                            if (_yearFormKey.currentState!.validate()) {
                              // سيتم استدعاء Cubit لاحقاً
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

                // 2. قسم إنشاء فصل جديد
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
                          hint: 'اسم الفصل (مثال: Semester 1)',
                          theme: theme,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        _buildSubmitButton(
                          title: 'إضافة الفصل',
                          onPressed: () {
                            if (_semesterFormKey.currentState!.validate()) {
                              // سيتم استدعاء Cubit لاحقاً
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

                // 3. قسم إنشاء مادة جديدة
                _buildSectionContainer(
                  context: context,
                  title: 'إنشاء مادة جديدة',
                  icon: Icons.book_outlined,
                  color: ColorsManager.pomodoroPurple,
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

                        // قوائم منسدلة لاختيار السنة والفصل
                        Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                hint: 'اختر السنة',
                                value: _selectedYear,
                                items: [
                                  'السنة الأولى',
                                  'السنة الثانية',
                                ], // بيانات وهمية للتصميم
                                onChanged: (val) =>
                                    setState(() => _selectedYear = val),
                                theme: theme,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: _buildDropdown(
                                hint: 'اختر الفصل',
                                value: _selectedSemester,
                                items: [
                                  'الفصل الأول',
                                  'الفصل الثاني',
                                ], // بيانات وهمية للتصميم
                                onChanged: (val) =>
                                    setState(() => _selectedSemester = val),
                                theme: theme,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        _buildSubmitButton(
                          title: 'إضافة المادة',
                          onPressed: () {
                            if (_subjectFormKey.currentState!.validate()) {
                              // سيتم استدعاء Cubit لاحقاً
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
        ),
      ),
    );
  }

  // ويدجت لبناء الحاويات الخاصة بكل قسم
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

  // ويدجت لحقول الإدخال مع الثيم المخصص
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

  // ويدجت للقائمة المنسدلة (Dropdown)
  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required ThemeData theme,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down, color: theme.colorScheme.primary),
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
      onChanged: onChanged,
      validator: (value) => value == null ? 'مطلوب' : null,
    );
  }

  // ويدجت لزر الإرسال
  Widget _buildSubmitButton({
    required String title,
    required VoidCallback onPressed,
    required ThemeData theme,
    required double screenWidth,
  }) {
    return SizedBox(
      width: double.infinity,
      height: screenWidth * 0.12,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
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
