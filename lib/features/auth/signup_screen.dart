import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/core/models/news_article_model.dart';
import 'package:news_app/core/models/user/user_model.dart';
import 'package:news_app/core/services/encryption_service.dart';
import 'package:news_app/core/services/preference_manager.dart';
import 'package:news_app/core/services/secure_storage_service.dart';
import 'package:news_app/features/auth/login_screen.dart';
import 'package:news_app/shared/custom_input_label_form.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final savedEmail = await SecureStorageService.getDecryptedPassword(
          'saved_email');
      final savedPassword = await SecureStorageService.getDecryptedPassword(
          'saved_password');

      if (savedEmail != null && savedPassword != null) {
        setState(() {
          _emailController.text = savedEmail.trim();
          _passwordController.text = savedPassword.trim();
          _confirmPasswordController.text = savedPassword.trim();
        });
      }
    } catch (e) {
      print('Error loading saved credentials: $e');
    }
  }

  // ✅ تعديل: تخزين كلمة المرور بشكل مشفر (Hashed)
  Future<String?> addUser(String email, String plainPassword) async {
    final box = Hive.box<UserModel>('users');

    // Check if email already exists
    final emailExists = box.values.any((user) =>
    user.email.trim() == email.trim());
    if (emailExists) {
      return 'Email already exists';
    }

    final uid = DateTime.now().millisecondsSinceEpoch.toString();

    // 🔐 تشفير كلمة المرور قبل التخزين
    final hashedPassword = EncryptionService.hashPassword(plainPassword);

    print('🔐 REGISTER: Plain password: $plainPassword');
    print('🔐 REGISTER: Hashed password (stored): $hashedPassword');

    // تخزين الهاش وليس النص العادي
    final newUser = UserModel(
      uid: uid,
      email: email,
      password: hashedPassword, // 🔐 مشفر
    );

    await box.put(uid, newUser);
    PreferencesManager().setString('userId', uid);
    await Hive.openBox<NewsArticleModel>('bookmarks_$uid');

    return null; // null means success
  }

  void handleSignup(BuildContext context) async {
    // ✅ التحقق من تطابق كلمة المرور مع تأكيدها
    final email = _emailController.text.trim();
    final plainPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // ✅ التحقق الإضافي من التطابق
    if (plainPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ التحقق من طول كلمة المرور
    if (plainPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ✅ التحقق من صحة البريد الإلكتروني
    if (!emailRegExp.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final error = await addUser(email, plainPassword);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Success - Navigate back to Login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Please sign in.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenHeight = size.height;
    final screenWidth = size.width;

    // Responsive values (same as LoginScreen for consistency)
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
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                          validator: (String? value) {
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
                          validator: (String? value) {
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
                        SizedBox(height: screenHeight * 0.015),

                        CustomInputLabelForm(
                          hintText: 'confirm your password',
                          label: 'Confirm Password',
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'this field is required';
                            } else if (value.length < 6) {
                              return 'please enter at least 6 characters';
                            } else if (value != _passwordController.text) {
                              return "the passwords don't match";
                            }
                            return null;
                          },
                          controller: _confirmPasswordController,
                          isPassword: true,
                        ),

                        SizedBox(height: screenHeight * 0.035),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(screenWidth * 0.7, 50),
                          ),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              handleSignup(context);
                            }
                          },
                          child: const Text('Sign Up'),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text('Sign In'),
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