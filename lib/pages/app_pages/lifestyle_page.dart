import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/profile_info_container.dart';
import 'package:supabase_auth/utilities/profile_picture_container.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/pages/app_pages/edit_lifestyle_page.dart';

class LifestyleTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String name = 'John Doe';
    final String email = 'john.doe@example.com';

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                  builder: (context) => EditLifestylePage(
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
