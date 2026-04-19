import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/core/models/user/user_model.dart';
import 'package:news_app/core/services/encryption_service.dart';
import 'package:news_app/core/services/preference_manager.dart';
import 'package:news_app/core/services/secure_storage_service.dart';
import 'package:news_app/features/auth/signup_screen.dart';
import 'package:news_app/features/home/home_screen.dart';
import 'package:news_app/shared/custom_input_label_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  bool isChecked = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _formKey = GlobalKey<FormState>();

  Future<void> _loadSavedCredentials() async {
    try {
      final savedEmail = await SecureStorageService.getDecryptedPassword(
          'saved_email');
      final savedPassword = await SecureStorageService.getDecryptedPassword(
          'saved_password');

      if (savedEmail != null && savedPassword != null) {
        setState(() {
          _emailController.text = savedEmail;
          _passwordController.text = savedPassword;
          isChecked = true;
        });
      }
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
  }

  void handleLogin(BuildContext context) async {
    final email = _emailController.text.trim();
    final plainPassword = _passwordController.text.trim();

    // 🔐 تشفير كلمة المرور المدخلة للمقارنة
    final hashedInputPassword = EncryptionService.hashPassword(plainPassword);

    print('🔐 LOGIN: Plain password entered: $plainPassword');
    print('🔐 LOGIN: Hashed password (for comparison): $hashedInputPassword');

    await Hive.openBox<UserModel>('users');

    if (email.isEmpty || plainPassword.isEmpty) {
      showMessage(context, 'Please enter both email and password', Colors.red);
      return;
    }

    // حفظ "تذكرني"
    if (isChecked) {
      await SecureStorageService.storeEncryptedPassword('saved_email', email);
      await SecureStorageService.storeEncryptedPassword(
          'saved_password', plainPassword);
    } else {
      await SecureStorageService.storage.delete(key: 'saved_email');
      await SecureStorageService.storage.delete(key: 'saved_password');
    }

    final box = Hive.box<UserModel>('users');
    UserModel? user;

    // ✅ البحث باستخدام الهاش المشفر
    try {
      user = box.values.firstWhere(
            (user) =>
        user.email == email &&
            user.password == hashedInputPassword, // مقارنة الهاش
      );
      print('✅ User found with matching password hash');
    } catch (e) {
      print('❌ User not found or password mismatch');
      user = null;
    }

    if (user == null) {
      showMessage(context, 'Invalid email or password', Colors.red);
    } else {
      await Hive.openBox<NewsArticleModel>('bookmarks_${user.uid}');
      PreferencesManager().setString('userId', user.uid);
      showMessage(context, 'Logged In successful', Colors.green);
      PreferencesManager().setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenHeight = size.height;
    final screenWidth = size.width;

    final horizontalPadding = screenWidth * 0.08;
    final logoHeight = screenHeight * 0.06;
    final logoWidth = screenWidth * 0.7;

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
              vertical: screenHeight * 0.02,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.12),

                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: logoWidth.clamp(200, 350),
                      height: logoHeight,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  Text(
                    'Welcome to Newst',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(
                      fontSize: screenWidth * 0.07,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035),

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
                        SizedBox(height: screenHeight * 0.015),

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
                        SizedBox(height: screenHeight * 0.013),

                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            const Text('Remember me'),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.035),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth * 0.7, 50),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              handleLogin(context);
                            }
                          },
                          child: const Text('Sign in'),
                        ),

                        SizedBox(height: screenHeight * 0.03),

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
                                    builder: (context) => const SignupScreen(),
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