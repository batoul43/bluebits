import 'package:bluebits_app/core/constant/constant.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/theming/app_theme.dart';
import 'package:bluebits_app/features/auth/data/api_service/auth_api.dart';
import 'package:bluebits_app/features/auth/data/repository/auth_repo.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/home/presentation/home_screen.dart';
import 'package:bluebits_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await CachHelper.clearAll();
  isopen = bool.parse(await CachHelper.getValue('isopen') ?? false.toString());

  runApp(
    BlocProvider(
      create: (context) =>
          AuthCubit(authrepo: AuthRepo(authApi: AuthApi()))..checkAuthStatus(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('ar'),
      supportedLocales: [Locale('ar')],
      localizationsDelegates: [
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
            return HomeScreen();
          } else if (state is Unauthenticated) {
            return SigninScreen();
          } else if (state is AuthFailed) {
            return Scaffold(
              body: Center(
                child: Text('Authentication failed. Please try again.'),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
