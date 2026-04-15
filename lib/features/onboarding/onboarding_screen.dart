import 'package:flutter/material.dart';
import 'package:news_app/core/models/onboarding_model.dart';
import 'package:news_app/core/services/preference_manager.dart';
import 'package:news_app/features/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      image: 'assets/images/onboarding1.png',
      title: 'Update for new features',
      description:
      "You deserve the best experience possible. That's why we've added new features and services to our app. Update now and see for yourself.",
    ),
    OnboardingModel(
      image: 'assets/images/onboarding2.png',
      title: 'Pick What You Love',
      description:
      "No more endless scrolling! Tap into your favorite topics like Tech, Politics, or Sports and get personalized news in seconds.",
    ),
    OnboardingModel(
      image: 'assets/images/onboarding3.png',
      title: 'Save It. Read It Later. Stay Smart.',
      description:
      "Found something interesting? Tap the bookmark and come back to it anytime. Never lose a great read again!",
    ),
  ];
  int _currentIndex = 0;

  void _finisOnBoarding() {
    PreferencesManager().setBool('onBoarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return LoginScreen();
        },
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          (_currentIndex < onboardingData.length - 1)
              ? TextButton(
            onPressed: () {
              _finisOnBoarding();
            },
            child: Text(
              'skip',
              style: TextStyle(fontSize: MediaQuery.of(context).textScaler.scale(22), letterSpacing: 3),
            ),
          )
              : Text(''),
        ],
      ),
      body: PageView.builder(
        itemCount: 3,
        controller: _controller,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Image.asset(onboardingData[index].image,height: MediaQuery.of(context).size.height * 0.347,width: double.infinity,),
            SizedBox(height: MediaQuery.of(context).size.height * 0.024,),
            Text(
              onboardingData[index].title,
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaler.scale(24),
                fontWeight: FontWeight.bold,
                color: Color(0xff4E4B66),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.012,),
            Text(
              onboardingData[index].description,
              style: TextStyle(
                fontSize: MediaQuery.of(context).textScaler.scale(16),
                fontWeight: FontWeight.w400,
                color: Color(0xff6E7191),
              ),
              textAlign: TextAlign.center,
            ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.016,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardingData.length,
                      (dotIndex) => GestureDetector(
                    onTap: () {
                      _controller.animateToPage(
                        dotIndex, // e.g., 2
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.008),
                      width: MediaQuery.of(context).size.width * 0.024,
                      height: MediaQuery.of(context).size.height * 0.024,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: (_currentIndex == dotIndex
                            ? Color(0xFFC53030)
                            : Color(0xFFD3D3D3)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.024,),
              ElevatedButton(
                onPressed: () {
                  if (_currentIndex < onboardingData.length - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _finisOnBoarding();
                  }
                },
                child: Text(
                  (_currentIndex < onboardingData.length - 1
                      ? 'Next'
                      : 'Get Started'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.024,),
          ],
          );
        },
      ),
    );
  }
}
