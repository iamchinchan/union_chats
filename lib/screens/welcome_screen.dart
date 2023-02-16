import 'dart:io';
import '../constants.dart';
import '../components/round_button.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:need_resume/need_resume.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const id = 'welcome_screen';
  @override
  ResumableState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ResumableState<WelcomeScreen>
    with TickerProviderStateMixin {
  // @override
  // TODO: implement mounted
  // bool get mounted => super.mounted;
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  late AnimationController controller;
  late Animation logoAnimation;
  late Animation bgAnimation;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onResume() async {
    // according to me it is called before  build
    // if was supposed to run due to animation or anything

    controller.dispose();
    createWelcomeAnimationController();
    // sleep(Duration(seconds: 3));
    // await Future.delayed(const Duration(milliseconds: 0));
    createBgAnimation();
    // print('Data from ${LoginScreen.id}: ${resume.data}');

    super.onResume();
  }

  @override
  void onPause() {
    print('welcome screen paused');
    super.onPause();
  }

  void createWelcomeAnimationController() {
    print('welcome screen starting animation');
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
      lowerBound: 0.20,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  void createLogoAnimation() {
    logoAnimation =
        CurvedAnimation(parent: controller, curve: Curves.decelerate);
  }

  void createBgAnimation() {
    bgAnimation =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(controller);
  }

  @override
  void initState() {
    print('welcome screen object created');
    createWelcomeAnimationController();
    createLogoAnimation();
    createBgAnimation();
    super.initState();
  }

  @override
  void deactivate() {
    print('deactivated welcome page');
    super.deactivate();
  }

  @override
  void dispose() {
    controller.dispose();
    print('disposed last controller and disposing welcome page completely.');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgAnimation.value,
      // backgroundColor: Colors.white,
      // pink.withOpacity(controller.value / 101)
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'appLogo',
                  child: Container(
                    // height: 60.0,
                    height: logoAnimation.value * 80.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  child: Text(
                    'Secret Chat',
                    // '${controller.value.toInt()}%',
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            RoundButton(
              onPressed: () {
                //Go to login screen.
                pushNamed(context, LoginScreen.id);
              },
              color: primaryButtonColor,
              label: 'Log In',
            ),
            RoundButton(
                onPressed: () {
                  //Go to registration screen.
                  pushNamed(
                    context,
                    RegistrationScreen.id,
                  );
                },
                color: secondaryButtonColor,
                label: 'Register')
          ],
        ),
      ),
    );
  }
}

// reference for switch syntax:
// switch (resume.source) {
//   case RegistrationScreen.id:
//     print('Data from ${RegistrationScreen.id}: ${resume.data}');
//     break;
// }
