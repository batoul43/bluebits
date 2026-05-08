import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/custombutton.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

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
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  // أيقونة توضيحية لعملية استعادة كلمة المرور
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: ColorsManager.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: ColorsManager.cyan,
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 30),

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
                              'استعادة كلمة المرور',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: ColorsManager.whiteText,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'أدخل بريدك الإلكتروني الجامعي المسجل وسنرسل لك رابطاً لتعيين كلمة مرور جديدة.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorsManager.whiteText,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 30),

                          CustomTextField(
                            icon: Icons.email_outlined,
                            isPassword: false,
                            controller: _emailController,
                            labelText: 'البريد الإلكتروني',
                            hintText: 'example@univ-aleppo.com',
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "البريد الإلكتروني مطلوب";
                              if (!_emailRegex.hasMatch(value))
                                return "صيغة البريد غير صحيحة";
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "تم إرسال رابط الاستعادة بنجاح",
                                    ),
                                    backgroundColor: ColorsManager.green,
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
                                    ? 'جاري الإرسال... '
                                    : 'إرسال الرابط',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // هنا يتم استدعاء وظيفة استعادة كلمة المرور من الـ Cubit
                                    // context.read<AuthCubit>().forgetPassword(_emailController.text);
                                  }
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 25),

                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    color: ColorsManager.cyan,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'العودة لتسجيل الدخول',
                                    style: TextStyle(
                                      color: ColorsManager.cyan,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
}
