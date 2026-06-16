import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/auth/data/models/userdata.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/custombutton.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/customtextfield.dart';
import 'package:bluebits_app/features/layout/layout_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController(); // رقم الطالب
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s\u0600-\u06FF]+$');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: ColorsManager.backgroundGradient),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Image(
                    width: 200,
                    height: 80,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: ColorsManager.white.withOpacity(0.15),
                      border: Border.all(
                        color: ColorsManager.white.withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'إنشاء حساب جديد',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: ColorsManager.whiteText,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),

                          CustomTextField(
                            icon: Icons.person_outline,
                            isPassword: false,
                            controller: _nameController,
                            labelText: 'الاسم الكامل',
                            hintText: 'أدخل اسمك ',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "الاسم مطلوب";
                              }
                              if (!_nameRegex.hasMatch(value)) {
                                return "الاسم يجب أن يحتوي على حروف فقط";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          CustomTextField(
                            icon: Icons.badge_outlined,
                            isPassword: false,
                            controller: _idController,
                            labelText: 'الرقم الجامعي',
                            hintText: ' 12345',
                            validator: (value) {
                              if (value == null || value.isEmpty) return null;
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          CustomTextField(
                            icon: Icons.email_outlined,
                            isPassword: false,
                            controller: _emailController,
                            labelText: 'البريد الإلكتروني',
                            hintText: 'example@univ-aleppo.com',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "البريد الإلكتروني مطلوب";
                              }
                              if (!_emailRegex.hasMatch(value)) {
                                return "البريد غير صحيح";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          CustomTextField(
                            icon: Icons.lock_outline,
                            isPassword: true,
                            controller: _passwordController,
                            labelText: 'كلمة المرور',
                            hintText: '********',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "كلمة المرور مطلوبة";
                              }
                              if (value.length < 8) {
                                return "يجب أن تكون 8 محارف على الأقل";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),

                          _buildYearDropdown(theme),

                          const SizedBox(height: 30),

                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LayoutApp(),
                                  ),
                                );
                              } else if (state is AuthFailed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: ColorsManager.redaccent,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return CustomButton(
                                text: state is AuthLoading
                                    ? 'جاري المعالجة... '
                                    : 'إنشاء الحساب',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signup(
                                      UserData(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        name: _nameController.text,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'لديك حساب بالفعل؟ ',
                                style: TextStyle(
                                  color: ColorsManager.whiteText,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SigninScreen(),
                                  ),
                                ),
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    color: ColorsManager.cyan,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت مخصص لاختيار السنة الدراسية متوافق مع الثيم
  Widget _buildYearDropdown(ThemeData theme) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'السنة الدراسية',
        labelStyle: const TextStyle(
          color: ColorsManager.whiteText,
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.school_outlined,
          color: ColorsManager.whiteText,
        ),
        filled: true,
        fillColor: ColorsManager.white.withOpacity(0.05),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.white.withOpacity(0.3)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.cyan, width: 2),
        ),
      ),
      dropdownColor:
          ColorsManager.deepNavy, // استخدام اللون الداكن المحدث للقائمة
      style: const TextStyle(color: ColorsManager.whiteText, fontSize: 16),
      iconEnabledColor: ColorsManager.whiteText,
      items: ["الأولى", "الثانية", "الثالثة", "الرابعة", "الخامسة"]
          .map((year) => DropdownMenuItem(value: year, child: Text(year)))
          .toList(),
      onChanged: (value) {},
    );
  }
}
