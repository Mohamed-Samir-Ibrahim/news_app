import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_app/core/models/user/user_model.dart';
import 'package:news_app/core/services/preference_manager.dart';
import 'package:news_app/core/services/service_locator.dart';
import 'package:news_app/features/bookmark/bookmark_controller.dart';
import 'package:news_app/features/layout/home/controller/home_controller.dart';
import 'package:news_app/features/splash/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/models/news_article_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  try {
    // 1. Initialize Preferences first
    await PreferencesManager().init();

    // 2. Initialize Hive (this triggers path_provider → JNI)
    //await Hive.initFlutter();
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);
    // 3. Register your Hive Adapters (must be before opening boxes)
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(NewsArticleModelAdapter());

    // 4. Open the main users box
    await Hive.openBox<UserModel>('users');

    // Optional debug print
    final box = Hive.box<UserModel>('users');
    print('✅ Hive initialized successfully');
    print('📊 Total users in box: ${box.length}');
    for (var user in box.values) {
      print('User: ${user.email} | UID: ${user.uid}');
    }
  } catch (e, stack) {
    print('❌ Error during Hive initialization: $e');
    print(stack);
    // You can show a dialog or fallback here in production
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>
        HomeController()
          ..init()),
        ChangeNotifierProvider(create: (context) =>
        BookmarkController()
          ..init()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) =>
        HomeController()
          ..init()),
        ChangeNotifierProvider(create: (context) =>
        BookmarkController()
          ..init()),
      ],
      child: MaterialApp(
        title: 'Newst',
        theme: ThemeData(scaffoldBackgroundColor: Color(0xfff3f3f3)),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
