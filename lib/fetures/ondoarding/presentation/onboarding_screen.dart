import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/fetures/auth/data/api_service/auth_api.dart';
import 'package:bluebits_app/fetures/auth/data/repositry/auth_signup_repo.dart';
import 'package:bluebits_app/fetures/auth/presentation/logic/cubit/authcubit_cubit.dart';
import 'package:bluebits_app/fetures/auth/presentation/secrens/signup_screen.dart';
import 'package:bluebits_app/fetures/ondoarding/data/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageControllerr = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: ColorsManager.lightsurface,
          child: currentPage == 3
              ? Icon(Icons.check, color: ColorsManager.iconscolor)
              : Icon(Icons.arrow_forward, color: ColorsManager.iconscolor),
          onPressed: () async {
            if (currentPage == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AuthcubitCubit(
                      authsignuprepo: AuthSignupRepo(authsignup: AuthApi()),
                    ),
                    child: SignupScreen(),
                  ),
                ),
              );
            }
            pageControllerr.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.bounceInOut,
            );
          },
        ),
        body: PageView.builder(
          controller: pageControllerr,
          onPageChanged: (index) {
            setState(() {});
            currentPage = index;
          },
          itemCount: onboardingcontent.length,
          itemBuilder: (context, index) => Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ColorsManager.backgroundgradient,
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * (40 / size.width),
                vertical: size.height * (40 / size.height),
              ),
              child: Column(
                children: [
                  Text(
                    onboardingcontent[index].title,
                    style: TextStyle(
                      fontSize: size.width * (24 / size.width),
                      color: ColorsManager.textWhite.withOpacity(1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * (25 / size.height)),
                  Text(
                    textAlign: TextAlign.center,
                    onboardingcontent[index].body,
                    style: TextStyle(
                      fontSize: size.width * (16 / size.width),
                      color: ColorsManager.textWhite.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * (35 / size.height)),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Image.asset(
                      onboardingcontent[index].image,
                      width: size.width * (375 / size.width),
                      height: size.height * (375 / size.height),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.none,
                    ),
                  ),
                  SizedBox(height: size.height * (35 / size.height)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorsManager.lightsurface,
                          ),
                          height: 10,
                          width: currentPage == index ? 20 : 10,
                        ),
                      );
                    }),
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
