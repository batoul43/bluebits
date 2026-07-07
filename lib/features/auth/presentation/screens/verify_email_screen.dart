import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/auth/presentation/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailScreen extends StatelessWidget {
  final String email;

  const VerifyEmailScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    // استدعاء MediaQuery مرة واحدة واستخدامه في كامل الواجهة
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          // استخدام التدرج اللوني المعتمد للتطبيق
          gradient: LinearGradient(
            colors: ColorsManager.backgroundGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          // إضافة SingleChildScrollView لمنع مشاكل الـ Overflow في الشاشات الصغيرة
          child: SingleChildScrollView(
            child: Padding(
              // حواف جانبية متجاوبة بناءً على عرض الشاشة
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.02,
              ),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.04),
                  // شعار التطبيق بحجم متجاوب
                  Image(
                    width: size.width * 0.5,
                    height: size.height * 0.1,
                    image: const AssetImage('assets/images/logo.png'),
                  ),
                  SizedBox(height: size.height * 0.05),

                  // الحاوية الشفافة (تأثير الزجاج المعتمد في التطبيق)
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: ColorsManager.white.withOpacity(0.1),
                      border: Border.all(
                        color: ColorsManager.white.withOpacity(0.2),
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
                      // هوامش داخلية متجاوبة
                      padding: EdgeInsets.all(size.width * 0.06),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mark_email_read_outlined,
                            size:
                                size.width *
                                0.2, // حجم الأيقونة يتغير حسب العرض
                            color: ColorsManager.cyan,
                          ),
                          SizedBox(height: size.height * 0.03),

                          Text(
                            'تأكيد البريد الإلكتروني',
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: ColorsManager.whiteText,
                              // حجم خط متجاوب
                              fontSize: size.width * 0.055,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.02),

                          // عرض الإيميل للمستخدم للتأكيد
                          Text(
                            'لقد أرسلنا رابط تفعيل إلى:\n$email\n\nيرجى التحقق من صندوق الوارد والنقر على الرابط لتأكيد حسابك.\nفي حال انتهت صلاحية الرابط، يمكنك العودة هنا لإعادة الإرسال.',
                            style: TextStyle(
                              color: ColorsManager.whiteText,
                              fontSize: size.width * 0.038, // حجم خط متجاوب
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: size.height * 0.04),

                          // زر الانتقال لتسجيل الدخول
                          CustomButton(
                            text: 'الانتقال لتسجيل الدخول',
                            onPressed: () {
                              // استخدام push للسماح بالعودة لاحقاً عند الحاجة لإعادة الإرسال
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SigninScreen(),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: size.height * 0.02),

                          // زر إعادة الإرسال المستند إلى الإيميل المحفوظ
                          BlocListener<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthresendVerification) {
                                // عرض الرسالة القادمة من الـ Cubit (سواء كانت نجاح أو خطأ)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: ColorsManager.blue,
                                  ),
                                );
                              }
                            },
                            child: TextButton(
                              onPressed: () {
                                context.read<AuthCubit>().resendVerification(
                                  email,
                                );
                              },
                              child: Text(
                                'إعادة إرسال الرابط الآن',
                                style: TextStyle(
                                  color: ColorsManager.cyan,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * 0.038,

                                  // حجم خط متجاوب
                                ),
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
