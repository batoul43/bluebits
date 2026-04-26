import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/fetures/auth/presentation/secrens/signup_screen.dart';
import 'package:bluebits_app/fetures/auth/presentation/widgets/custombutton.dart';
import 'package:bluebits_app/fetures/auth/presentation/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
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
                  width: size.width - (10 / size.width),
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
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                color: ColorsManager.textWhite,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            icon: Icons.person_outline,
                            isPassword: false,
                            controller: _nameController,
                            labelText: 'الاسم الكامل',
                            hintText: 'محمد',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "الاسم مطلوب";
                              }
                              if (value.length < 4) {
                                return "الاسم يجب أن يكون 4 حروف فأكثر";
                              }
                              if (!_nameRegex.hasMatch(value)) {
                                return "الاسم يجب أن يحتوي على حروف فقط";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
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
                          SizedBox(height: 20),
                          CustomTextField(
                            icon: Icons.lock_outline,
                            isPassword: true,
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "كلمة المرور مطلوبة";
                              }
                              if (value.length < 8) {
                                return "يجب أن تكون 8 محارف على الأقل";
                              }
                              return null;
                            },
                            labelText: 'كلمة المرور',
                            hintText: '********',
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {},
                            child: Text('نسيت كلمة المرور؟'),
                          ),
                          SizedBox(height: 70),
                          CustomButton(
                            text: ' تسجيل الدخول',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('تم التحقق بنجاح'),
                                  ),
                                );
                              }
                            },
                          ),

                          //   Spacer(),
                          SizedBox(height: 50),
                          Center(
                            child: Text(
                              'أو سجل الدخول عبر :',
                              style: TextStyle(
                                fontSize: 18,
                                color: ColorsManager.textWhite,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buttonSigninWithoutEmail(
                                'assets/images/google.svg',
                              ),
                              buttonSigninWithoutEmail(
                                'assets/images/facebook.svg',
                              ),
                              buttonSigninWithoutEmail(
                                'assets/images/apple.svg',
                              ),
                              buttonSigninWithoutEmail(
                                'assets/images/linkedin.svg',
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            children: [
                              Text(' ليس لديك حساب؟ '),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupScreen(),
                                    ),
                                  );
                                },
                                child: Text('إنشاء حساب'),
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
