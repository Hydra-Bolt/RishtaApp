import 'package:flutter/material.dart';
import 'package:supabase_auth/pages/app_pages/edit_lifestyle_page.dart';
import 'package:supabase_auth/utilities/profile_info_container.dart';
import 'package:supabase_auth/utilities/profile_picture_container.dart';
import 'package:supabase_auth/utilities/buttons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example initial data, replace with your actual data source
    final String name = 'John Doe';
    final String email = 'john.doe@example.com';

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: SizedBox(
          height: 35,
          width: 100,
          child: CustomButtons.editButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(
                    initialName: name,
                    initialEmail: email,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              ProfileInfoContainer(),
              ProfileImageContainer(),
            ],
          ),
        ),
      ),
    );
  }
}
