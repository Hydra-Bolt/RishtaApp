import 'package:flutter/material.dart';
import 'package:supabase_auth/pages/app_pages/edit_lifestyle_page.dart';
import 'package:supabase_auth/pages/app_pages/preference_page.dart';
import 'package:supabase_auth/utilities/profile_info_container.dart';
import 'package:supabase_auth/utilities/profile_picture_container.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/utilities/colors.dart';
import 'package:supabase_auth/pages/app_pages/lifestyle_page.dart'; // Import the LifestyleTab widget

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    // Example initial data, replace with your actual data source
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      
      backgroundColor: Colors.transparent,
      body: DefaultTabController(
        length: 2, // Number of tabs
        child: Column(
          children: [
            TabBar(
              labelColor: MainColors.mainThemeColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: MainColors.mainThemeColor,
              overlayColor: MaterialStatePropertyAll(Colors.white10),
              tabs: [
                Tab(text: 'Lifestyle'),
                Tab(text: 'Preferences'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // First Tab: Lifestyle
                  LifestyleTab(), // Use the LifestyleTab widget here

                  // Second Tab: Preferences
                  PreferencesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
