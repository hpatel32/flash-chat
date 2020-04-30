import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'common_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Animation colorAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    colorAnimation = ColorTween(begin: Colors.lightBlue, end: Colors.white)
        .animate(animationController);
    animationController.forward();
//    animationController.addStatusListener((listener) {
//      if (listener == AnimationStatus.completed)
//        animationController.reverse(from: 1.0);
//      if (listener == AnimationStatus.dismissed) animationController.forward();
//    });
    animationController.addListener(() {
      setState(() {});
    });
  }

  void loginCallback() {
    Navigator.pushNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnimation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 100,
                  ),
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            CommonButton(
              col: Colors.lightBlueAccent,
              myFunc: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              buttonText: 'Log In',
            ),
            CommonButton(
              col: Colors.blueAccent,
              myFunc: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              buttonText: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
