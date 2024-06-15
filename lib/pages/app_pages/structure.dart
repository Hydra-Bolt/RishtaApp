import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
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
  Map<String, dynamic>? userData;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _pageController = PageController(initialPage: pageStateIndex);
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('uid', supabase.auth.currentUser!.id)
          .single();

      setState(() {
        userData = response;
      });
      if (!mounted) return;
      if (userData!['lid'] == null) {
        Navigator.of(context).pushReplacementNamed('/lifestyle');
      } else if (userData!['pid'] == null) {
        Navigator.of(context).pushReplacementNamed('/preference');
      }
    } catch (error) {
      // Handle the error appropriately here
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/userform');
        print('Error fetching user data: $error');
      }
    }
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
          backgroundColor: MainColors.primaryBackground,
          color: MainColors.navigationBackground,
          buttonBackgroundColor: MainColors.primaryBackground,
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
