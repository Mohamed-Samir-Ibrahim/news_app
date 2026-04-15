import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/core/models/user/user_model.dart';
import 'package:news_app/core/services/preference_manager.dart';
import 'package:news_app/features/auth/signup_screen.dart';
import 'package:news_app/features/home/home_screen.dart';
import 'package:news_app/shared/custom_input_label_form.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _formKey = GlobalKey<FormState>();

  void handleLogin(BuildContext context) async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    await Hive.openBox<UserModel>('users');

    if (email.isEmpty || password.isEmpty) {
      showMessage(context, 'Please enter both email and password');
      return;
    }

    final box = Hive.box<UserModel>('users');
    UserModel? user;

    try {
      user = box.values.firstWhere(
            (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      user = null;
    }

    if (user == null) {
      showMessage(context, 'Invalid email or password');
    } else {
      await Hive.openBox<NewsArticleModel>('bookmarks_${user.uid}');
      PreferencesManager().setString('userId', user.uid);
      showMessage(context, 'Login successful');
      PreferencesManager().setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context); // More efficient
    final screenHeight = size.height;
    final screenWidth = size.width;

    // Responsive values
    final horizontalPadding = screenWidth * 0.08; // ~8% of width
    final logoHeight = screenHeight * 0.06; // 6% of height
    final logoWidth = screenWidth * 0.7; // 70% of width (max reasonable)

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/auth_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: screenHeight * 0.02, // small vertical padding
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic top spacing
                  SizedBox(height: screenHeight * 0.12), // was 140

                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: logoWidth.clamp(200, 350),
                      // prevent too small or too big
                      height: logoHeight,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04), // was 30

                  Text(
                    'Welcome to Newst',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      fontSize: screenWidth * 0.07, // responsive text size
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035), // was 28

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomInputLabelForm(
                          controller: _emailController,
                          hintText: 'user@gmail.com',
                          label: 'Email',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field is required';
                            } else if (!emailRegExp.hasMatch(value)) {
                              return 'please enter a valid email';
                            }
                            return null;
                          },
                          isPassword: false,
                        ),
                        SizedBox(height: screenHeight * 0.015), // was 12

                        CustomInputLabelForm(
                          hintText: 'enter your password',
                          label: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'this field is required';
                            } else if (value.length < 6) {
                              return 'please enter at least 6 characters';
                            }
                            return null;
                          },
                          controller: _passwordController,
                          isPassword: true,
                        ),
                        SizedBox(height: screenHeight * 0.035), // was 20

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                screenWidth * 0.7, 50), // wide button
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              handleLogin(context);
                            }
                          },
                          child: const Text('Sign in'),
                        ),

                        SizedBox(height: screenHeight * 0.03), // was 20

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),
                      ],
                    ),
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