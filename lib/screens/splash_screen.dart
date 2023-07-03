import 'package:doc_saver_app/screens/authentication.dart';
import 'package:doc_saver_app/screens/homescreen.dart';
import 'package:doc_saver_app/widgets/screen_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _navigate() async {
    // Check weather the current user is logged in or not!
    // If the value is true which means it is null so user is not logged in!
    await Future.delayed(const Duration(seconds: 1)).then((value) {
      bool value = FirebaseAuth.instance.currentUser == null;
      if (value) {
        Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
      }
    });
  }

  @override
  void initState() {
    _navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: Image.asset('assets/icon_image.png'),
        ),
      ),
    );
  }
}
