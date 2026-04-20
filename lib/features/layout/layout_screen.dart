import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_app/features/layout/bookmark/bookmark_screen.dart';
import 'package:news_app/features/layout/home/home_screen.dart';
import 'package:news_app/features/layout/profile/profile_screen.dart';
import 'package:news_app/features/layout/search/search_screen.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late PageController controller;
  int currentScreen = 0;
  bool isSelected = true;
  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    BookMarkScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: screens,

        onPageChanged: (index) {
          setState(() {
            currentScreen = index;
          });
        },
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.red, // Selected label color
              );
            }
            return TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54, // Unselected label color
            );
          }),
        ),
        child: NavigationBar(
          indicatorColor: Colors.white,
          selectedIndex: currentScreen,
          backgroundColor: Colors.white,
          onDestinationSelected: (value) {
            setState(() {
              currentScreen = value;
            });
            controller.jumpToPage(currentScreen);
          },
          destinations: [
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icon/home_icon.svg',
                colorFilter:
                    currentScreen == 0
                        ? ColorFilter.mode(Colors.red, BlendMode.srcIn)
                        : ColorFilter.mode(Colors.black54, BlendMode.srcIn),
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icon/search_icon.svg',
                colorFilter:
                    currentScreen == 1
                        ? ColorFilter.mode(Colors.red, BlendMode.srcIn)
                        : ColorFilter.mode(Colors.black54, BlendMode.srcIn),
              ),
              label: 'Search',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icon/bookmark_icon.svg',
                colorFilter:
                    currentScreen == 2
                        ? ColorFilter.mode(Colors.red, BlendMode.srcIn)
                        : ColorFilter.mode(Colors.black54, BlendMode.srcIn),
              ),
              label: 'Bookmark',
            ),
            NavigationDestination(
              icon: SvgPicture.asset(
                'assets/icon/profile_icon.svg',
                colorFilter:
                    currentScreen == 3
                        ? ColorFilter.mode(Colors.red, BlendMode.srcIn)
                        : ColorFilter.mode(Colors.black54, BlendMode.srcIn),
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
