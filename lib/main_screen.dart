import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:notifybear/screens/bear_shop.dart';
import 'package:notifybear/screens/home_screen.dart';
import 'package:notifybear/screens/profile/profile_page.dart';
import 'package:notifybear/screens/saved_notifications.dart';
import 'package:notifybear/screens/search_screen.dart';
import 'package:notifybear/shared/my_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final pageController = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          HomeScreen(),
          SearchScreen(),
          BearShop(),
          SavedNotifications(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          height: 60,
          elevation: 4,
          shadowColor: Colors.black,
          surfaceTintColor: MyColors.backgroundColor,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.white);
            } else {
              return const IconThemeData(color: Colors.grey);
            }
          }),
        ),
        child: NavigationBar(
            backgroundColor: MyColors.backgroundColor,
            selectedIndex: selectedIndex,
            onDestinationSelected: (i) => setState(() {
                  if ((i - selectedIndex).abs() != 1) {
                    pageController.jumpToPage(i);
                  } else {
                    pageController.animateToPage(i,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeIn);
                  }
                  selectedIndex = i;
                }),
            destinations: const [
              NavigationDestination(
                icon: Icon(
                  FluentIcons.home_48_filled,
                  size: 28,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(
                  FluentIcons.search_12_regular,
                  size: 28,
                ),
                label: 'Search',
              ),
              NavigationDestination(
                icon: ImageIcon(
                  AssetImage('assets/Bear.png'),
                  size: 30,
                ),
                label: 'BearShop',
              ),
              NavigationDestination(
                icon: Icon(
                  FluentIcons.bookmark_20_filled,
                  size: 28,
                ),
                label: 'SavedNotifications',
              ),
              NavigationDestination(
                icon: ImageIcon(AssetImage('assets/profile.png'), size: 30),
                label: 'ProfilePage',
              ),
            ]),
      ),
    );
  }
}
