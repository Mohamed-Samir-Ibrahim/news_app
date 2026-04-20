import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/core/services/preference_manager.dart';
import 'package:news_app/features/auth/login_screen.dart';
import 'package:news_app/features/layout/layout_screen.dart';
import 'package:news_app/features/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (_) =>
                  PreferencesManager().getBool('onBoarding') == true
                      ? PreferencesManager().getBool('isLoggedIn') == true
                          ? HomeScreen()
                          : LoginScreen()
                      : OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'assets/images/splash_image.png',
        fit: BoxFit.fill,
        width: double.infinity,
      ),
    );
  }
}
