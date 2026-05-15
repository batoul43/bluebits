import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/auth/data/models/forget_password.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/custombutton.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key, required this.resetToken});
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final resetToken;
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
                              'أدخل كلمة المرور الجديدة',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: ColorsManager.whiteText,
                                fontSize: 22,
                              ),
                            ),
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

                          const SizedBox(height: 30),

                          CustomTextField(
                            icon: Icons.lock_outline,
                            isPassword: true,
                            controller: _confirmPasswordController,
                            labelText: 'تأكيد كلمة المرور',
                            hintText: '********',
                            validator: (val) => val != _passwordController.text
                                ? 'كلمات المرور غير متطابقة'
                                : null,
                          ),
                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is ResetPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "تم تغيير كلمة المرور بنجاح! يمكنك التسجيل الآن",
                                    ),
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SigninScreen(),
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
                                    : ' حفظ التغييرات',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().resetpassword(
                                      _passwordController.text,
                                      resetToken,
                                    );
                                  }
                                },
                              );
                            },
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
