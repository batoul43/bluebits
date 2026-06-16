import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/auth/data/models/user_login_.dart';
import 'package:bluebits_app/features/auth/data/models/userdata.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/forget_password.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/custombutton.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/customtextfield.dart';
import 'package:bluebits_app/features/layout/layout_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            // استخدام التدرج اللوني من ملف الألوان المحدث
            gradient: LinearGradient(colors: ColorsManager.backgroundGradient),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Image(
                    width: 250,
                    height: 100,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      // استخدام لون شفاف مرن يتناسب مع الخلفية
                      color: ColorsManager.white.withOpacity(0.15),
                      border: Border.all(
                        color: ColorsManager.white.withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ColorsManager.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'تسجيل الدخول',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: ColorsManager
                                    .whiteText, // نصوص فاتحة فوق الخلفية المتدرجة
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // CustomTextField(
                          //   icon: Icons.person_outline,
                          //   isPassword: false,
                          //   controller: _nameController,
                          //   labelText: 'الاسم الكامل',
                          //   hintText: 'محمد',
                          //   validator: (value) {
                          //     if (value == null || value.isEmpty) {
                          //       return "الاسم مطلوب";
                          //     }
                          //     if (value.length < 4) {
                          //       return "الاسم يجب أن يكون 4 حروف فأكثر";
                          //     }
                          //     if (!_nameRegex.hasMatch(value)) {
                          //       return "الاسم يجب أن يحتوي على حروف فقط";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          const SizedBox(height: 20),

                          CustomTextField(
                            icon: Icons.email_outlined,
                            isPassword: false,
                            controller: _emailController,
                            labelText: 'البريد الإلكتروني',
                            hintText: 'example@univ.com',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "البريد الإلكتروني مطلوب";
                              }
                              if (!_emailRegex.hasMatch(value)) {
                                return "صيغة البريد الإلكتروني غير صحيحة";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

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

                          TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgetPassword(),
                              ),
                            ),
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: TextStyle(color: ColorsManager.whiteText),
                            ),
                          ),

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
                                    ? 'جاري الإرسال ... '
                                    : ' تسجيل الدخول',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                      UserLogin(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 40),
                          const Center(
                            child: Text(
                              'أو سجل الدخول عبر :',
                              style: TextStyle(color: ColorsManager.whiteText),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildSocialButton(
                                'assets/images/google.svg',
                                colorScheme,
                              ),
                              _buildSocialButton(
                                'assets/images/facebook.svg',
                                colorScheme,
                              ),
                              _buildSocialButton(
                                'assets/images/apple.svg',
                                colorScheme,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ليس لديك حساب؟ ',
                                style: TextStyle(
                                  color: ColorsManager.whiteText,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                ),
                                child: const Text(
                                  'إنشاء حساب',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String image, ColorScheme colorScheme) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          color: ColorsManager.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorsManager.white.withOpacity(0.2)),
        ),
        child: Center(child: SvgPicture.asset(image, height: 25)),
      ),
    );
  }
}
