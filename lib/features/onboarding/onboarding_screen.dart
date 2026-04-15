import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset('assets/images/onboarding1.png',height: MediaQuery.of(context).size.height * 0.347,width: double.infinity,),
            SizedBox(height: MediaQuery.of(context).size.height * 0.024,),
            Text(
              'Trending News',
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaler.scale(24),
                fontWeight: FontWeight.bold,
                color: Color(0xff4E4B66),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.012,),
            Text(
              'Stay in the loop with the biggest breaking stories in a stunning visual slider. Just swipe to explore what’s trending right now!',
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaler.scale(16),
                fontWeight: FontWeight.w400,
                color: Color(0xff6E7191),
              ),
              textAlign: TextAlign.center,
            ),
          ],
          );
        },
      ),
    );
  }
}
