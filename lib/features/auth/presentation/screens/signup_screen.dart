import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/auth/data/models/userdata.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/custombutton.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/customtextfield.dart';
import 'package:bluebits_app/features/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final RegExp _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s\u0600-\u06FF]+$');
  final RegExp _digitsRegex = RegExp(r'^[0-9]+$');
  //String yearValue = '';
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
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Container(
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
                      padding: const EdgeInsets.all(20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              'إنشاء حساب جديد',
                              style: TextStyle(
                                color: ColorsManager.textWhite,
                                fontSize: 28,
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
                            SizedBox(height: 20),

                            CustomTextField(
                              icon: Icons.badge_outlined,
                              isPassword: false,
                              controller: _idController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                }
                                if (!_digitsRegex.hasMatch(value)) {
                                  return "يجب إدخال أرقام فقط";
                                }

                                return null;
                              },
                              labelText: 'الرقم الجامعي',
                              hintText: '123456',
                            ),
                            SizedBox(height: 20),
                            _buildDropdownField(
                              'اختر السنة',
                              Icons.school_outlined,
                            ),
                            SizedBox(height: 90),
                            BlocConsumer<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is AuthSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('تم إنشاء الحساب بنجاح'),
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
                                      ? 'جاري الإرسال...'
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
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (context) => AlertDialog(
                                      //     backgroundColor: ColorsManager
                                      //         .darkSecondary, // لون خلفية العناصر الداكنة
                                      //     shape: RoundedRectangleBorder(
                                      //       borderRadius: BorderRadius.circular(
                                      //         20,
                                      //       ),
                                      //       side: const BorderSide(
                                      //         color: ColorsManager.darkAccentCyan,
                                      //         width: 0.5,
                                      //       ),
                                      //     ),
                                      //     title: Text(
                                      //       'تم التحقق بنجاح',
                                      //       style: TextStyle(
                                      //         color: ColorsManager.textWhite,
                                      //         fontSize: 20,
                                      //         fontWeight: FontWeight.bold,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // );
                                    }
                                  },
                                );
                              },
                            ),
                            //   Spacer(),
                            Row(
                              children: [
                                Text(' لديك حساب؟'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SigninScreen(),
                                      ),
                                    );
                                  },
                                  child: Text('سجل دخولك'),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Widget _buildDropdownField(String label, IconData icon) {
    return DropdownButtonFormField<String>(
      // أيقونة السهم المنسدل (جهة اليسار في التصميم العربي)
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: ColorsManager.darkAccentCyan,
      ),
      // تنسيق الحقل الخارجي (الخط السفلي والأيقونة الأمامية)
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: ColorsManager.textGrey,
          fontSize: 14,
        ),

        prefixIcon: Icon(icon, color: ColorsManager.darkAccentCyan),
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        // الحدود السفلية في حالة السكون
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
        ),
        // الحدود السفلية عند التفاعل
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.darkAccentCyan,
            width: 1.5,
          ),
        ),
        fillColor: Colors.transparent,
      ),
      // شكل القائمة المنسدلة نفسها
      dropdownColor: ColorsManager.darkSecondary, // لون خلفية القائمة
      style: TextStyle(color: Colors.white, fontSize: 14),
      isExpanded: true,
      validator: (value) => null,
      // العناصر
      items: ["الأولى", "الثانية", "الثالثة", "الرابعة", "الخامسة"]
          .map(
            (value) => DropdownMenuItem(
              value: value,
              child: Text(value, style: const TextStyle(color: Colors.white)),
            ),
          )
          .toList(),
      onChanged: (newValue) {
        // yearValue = newValue!;
        // أضف منطق تغيير القيمة هنا
      },
    );
  }
}
