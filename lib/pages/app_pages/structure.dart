import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth/pages/app_pages/connections.dart';
import 'package:supabase_auth/pages/app_pages/main_page.dart';
import 'package:supabase_auth/pages/app_pages/messages.dart';
import 'package:supabase_auth/pages/app_pages/profile.dart';
import 'package:supabase_auth/pages/app_pages/settings.dart';
import 'package:supabase_auth/utilities/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int pageStateIndex = 2;
  late final List rishtas;
  Map<String, dynamic>? userData;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageStateIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset("assets/images/app_background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover),
      Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Color(0xFF323232),
          color: MainColors.navigationBackground,
          buttonBackgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 300),
          height: 45,
          items: [
            buildNavigationBackground('./assets/icons/Profile.png', 0),
            buildNavigationBackground('./assets/icons/Messages.png', 1),
            buildNavigationBackground('./assets/icons/Main2.png', 2),
            buildNavigationBackground('./assets/icons/Connections.png', 3),
            buildNavigationBackground('./assets/icons/Settings.png', 4),
          ],
          onTap: (index) {
            setState(() {
              pageStateIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
          },
          index: pageStateIndex,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              pageStateIndex = index;
            });
          },
          children: const [
            ProfilePage(),
            MessagesPage(),
            MainHomePage(),
            ConnectionsPage(),
            SettingsPage(),
          ],
        ),
      )
    ]);
  }

  Widget buildNavigationBackground(String iconPath, int index) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 10),
      // padding: const EdgeInsets.all(20),
      child: ImageIcon(
        AssetImage(iconPath),
        color:
            pageStateIndex == index ? MainColors.mainThemeColor : Colors.white,
        size: 25,
      ),
    );
  }
}
