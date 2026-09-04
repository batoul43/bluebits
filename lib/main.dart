import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bluebits_app/core/constant/constant.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/shares/acadimic_tasks/data/academic_tasks_repository/academic_tasks_repository.dart';
import 'package:bluebits_app/core/shares/acadimic_tasks/data/api_service/acaddemic_tasks_api_service.dart';
import 'package:bluebits_app/core/shares/acadimic_tasks/logic/academic_task_cubit.dart';
import 'package:bluebits_app/core/theming/app_theme.dart';
import 'package:bluebits_app/core/theming/colors.dart'; // تم استدعاء ملف الألوان
import 'package:bluebits_app/features/ai/data/api_Service/ai_api_service.dart';
import 'package:bluebits_app/features/ai/data/repository/ai_repository.dart';
import 'package:bluebits_app/features/ai/presentation/logic/ai_cubit.dart';
import 'package:bluebits_app/features/auth/data/api_service/auth_api.dart';
import 'package:bluebits_app/features/auth/data/repository/auth_repo.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/reset_password.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/layout/layout_app.dart';
import 'package:bluebits_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:bluebits_app/features/profile/data/api_service/profile_api.dart';
import 'package:bluebits_app/features/profile/data/repository/profile_repo.dart';
import 'package:bluebits_app/features/profile/presentation/logic/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await CachHelper.clearAll();

  // تعديل بسيط لمنع الخطأ في تحويل النص
  isopen = bool.parse(await CachHelper.getValue('isopen') ?? 'false');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AcademicTaskCubit(
            repository: AcademicTaskRepository(AcademicTaskApiService()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              AuthCubit(authrepo: AuthRepo(authApi: AuthApi()))
                ..checkAuthStatus(),
        ),
        BlocProvider(
          create: (context) =>
              ProfileCubit(repo: ProfileRepo(profileApi: ProfileApi())),
        ),
        BlocProvider(
          create: (context) =>
              AiCubit(repository: AiRepository(AiApiService())),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _applinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks(); // استدعاء الدالة لتهيئة التقاط الروابط
  }

  void initDeepLinks() {
    _applinks = AppLinks();

    // 1. الاستماع للرابط في حال كان التطبيق يعمل في الخلفية
    _linkSubscription = _applinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });

    // 2. التقاط الرابط في حال تم فتح التطبيق وهو مغلق تماماً
    _applinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  // التعديل الأساسي هنا لالتقاط الرابط العميق المخصص (Custom Scheme)
  void _handleDeepLink(Uri uri) {
    // التحقق من النطاق الجديد myapp.com
    if ((uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host == 'myapp.com') {
      // التحقق من وجود مسار reset-password
      if (uri.pathSegments.contains('reset-password')) {
        // الانتقال لصفحة تعيين كلمة المرور وتمرير قيمة فارغة للتوكن
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => ResetPassword(resetToken: ''),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // تم ربط المفتاح للتحكم بالمسارات
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (!isopen) {
            return OnboardingScreen();
          } else if (state is Authenticated) {
            return LayoutApp();
          } else if (state is Unauthenticated || state is AuthLogoutSuccess) {
            return SigninScreen();
          } else if (state is AuthFailed) {
            // إضافة Scaffold لتجنب أخطاء المساحة وتنسيق الشاشة
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: ColorsManager.redaccent,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'فشل في المصادقة، يرجى المحاولة مرة أخرى.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ColorsManager.blueText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<AuthCubit>().checkAuthStatus();
                          },
                          // زر مصمم باحترافية باستخدام ثيم التطبيق
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsManager.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              color: ColorsManager.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            // تغليف مؤشر التحميل بـ Scaffold لضمان احترام الـ SafeArea والثيم
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.blue, // استخدام اللون الأساسي للتطبيق
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
