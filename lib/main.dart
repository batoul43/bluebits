import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:bluebits_app/core/constant/constant.dart';
import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/theming/app_theme.dart';
import 'package:bluebits_app/features/auth/data/api_service/auth_api.dart';
import 'package:bluebits_app/features/auth/data/repository/auth_repo.dart';
import 'package:bluebits_app/features/auth/presentation/logic/cubit/auth_cubit.dart';
import 'package:bluebits_app/features/auth/presentation/screens/reset_password.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/layout/layout_app.dart';
import 'package:bluebits_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await CachHelper.clearAll();
  isopen = bool.parse(await CachHelper.getValue('isopen') ?? false.toString());

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthCubit(authrepo: AuthRepo(authApi: AuthApi()))
                ..checkAuthStatus(),
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
  }

  void initDeepLinks() {
    _applinks = AppLinks();
    _linkSubscription = _applinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
    _applinks.getInitialLink().then((uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.contains('reset-password')) {
      final token = uri.pathSegments.last;
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ResetPassword(resetToken: token),
        ),
      );
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
            return LayoutApp();
          } else if (state is Unauthenticated) {
            return SigninScreen();
          } else if (state is AuthFailed) {
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () {
                    context.read<AuthCubit>().checkAuthStatus();
                  },
                  child: Text('Authentication failed. Please try again.'),
                ),
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
