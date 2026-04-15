import 'package:flutter/material.dart';
import 'package:news_app/features/onboarding/onboarding_screen.dart';
import 'package:news_app/features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newst',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff3f3f3),
      ),
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),);
  }
}