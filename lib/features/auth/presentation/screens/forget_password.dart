import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/custombutton.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/customtextfield.dart';
import 'package:bluebits_app/features/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: ColorsManager.backgroundgradient),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * (10 / size.width),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    width: size.width * (250 / size.width),
                    height: size.height * (100 / size.height),
                    image: AssetImage('assets/images/logo.png'),
                  ),
                  Container(
                    width: size.width - size.width * (10 / size.width),
                    height: size.height - size.height * (100 / size.height),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: ColorsManager.lightSecondary.withOpacity(0.2),
                      border: Border.all(color: ColorsManager.lightSecondary),
                      boxShadow: [
                        BoxShadow(
                          blurStyle: BlurStyle.outer,
                          spreadRadius: 100,
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(0, 10),
                          blurRadius: 100,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'نسيت كلمة المرور؟',
                                style: TextStyle(
                                  color: ColorsManager.textWhite,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            Text(
                              'أدخل بريدك الإلكتروني وسنرسل لك رمزاً لتغيير كلمة المرور الخاصة بك',
                              style: TextStyle(
                                color: ColorsManager.textWhite,
                                fontSize: 14,
                              ),
                            ),

                            SizedBox(height: 60),
                            CustomTextField(
                              icon: Icons.email_outlined,
                              isPassword: false,
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "البريد الإلكتروني مطلوب";
                                }
                                if (!_emailRegex.hasMatch(value)) {
                                  return "صيغة البريد الإلكتروني غير صحيحة";
                                }
                                return null;
                              },
                              labelText: 'البريد الإلكتروني',
                              hintText: 'example@univ.com',
                            ),
                            SizedBox(height: 70),

                            BlocConsumer<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is AuthForgetPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                      backgroundColor:
                                          ColorsManager.darkAccentCyan,
                                    ),
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Home(),
                                    ),
                                  );
                                } else if (state is AuthFailed) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return CustomButton(
                                  text: state is AuthLoading
                                      ? 'جاري الإرسال ... '
                                      : 'إرسال رمز التحقق',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().forgetpassword(
                                        _emailController.text,
                                      );
                                    }
                                  },
                                );
                              },
                            ),

                            SizedBox(height: 18),
                            Row(
                              children: [
                                Text(' تذكرت كلمة المرور؟ '),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SigninScreen(),
                                      ),
                                    );
                                  },
                                  child: Text('سجل الدخول'),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget buttonSigninWithoutEmail(String image) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 60,
        height: 50,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: ColorsManager.darkSecondary.withOpacity(0.2)),
          ],
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorsManager.darkAccentCyan.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            image,
            fit: BoxFit.cover,
            clipBehavior: Clip.hardEdge,
            height: 30,
          ),
        ),
      ),
    );
  }
}
