import 'package:bluebits_app/core/helpers/cachhelper.dart';
import 'package:bluebits_app/core/theming/colors.dart';
import 'package:bluebits_app/features/auth/presentation/screens/signin_screen.dart';
import 'package:bluebits_app/features/onboarding/data/onboarding_model.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final PageController pageControllerr = PageController();
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: ValueListenableBuilder<int>(
          valueListenable: currentPage,
          builder: (context, value, child) {
            return FloatingActionButton(
              shape: CircleBorder(),
              backgroundColor: ColorsManager.white,
              child: value == 3
                  ? Icon(Icons.check, color: ColorsManager.blue)
                  : Icon(Icons.arrow_forward, color: ColorsManager.blue),
              onPressed: () async {
                if (value == 3) {
                  await CachHelper.setValue('isopen', true.toString());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SigninScreen()),
                  );
                }
                pageControllerr.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            );
          },
        ),
        body: PageView.builder(
          controller: pageControllerr,
          onPageChanged: (index) {
            currentPage.value = index;
          },
          itemCount: onboardingcontent.length,
          itemBuilder: (context, index) => Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ColorsManager.backgroundGradient,
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
                      color: ColorsManager.whiteText.withOpacity(1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: size.height * (25 / size.height)),
                  Text(
                    onboardingcontent[index].body,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * (16 / size.width),
                      color: ColorsManager.whiteText.withOpacity(0.7),
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
                  ValueListenableBuilder(
                    valueListenable: currentPage,
                    builder: (context, value, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorsManager.whiteText.withOpacity(0.3),
                              ),
                              height: 10,
                              width: value == index ? 20 : 10,
                            ),
                          );
                        }),
                      );
                    },
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
