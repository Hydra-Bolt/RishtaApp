import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/profile_info_container.dart';
import 'package:supabase_auth/utilities/profile_picture_container.dart';
import 'package:supabase_auth/utilities/buttons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: SizedBox(
              height: 35,
              width: 100,
              child: CustomButtons.editButton(onPressed: () {}),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Stack(alignment: Alignment.center, children: [
            ProfileInfoContainer(),
            ProfileImageContainer(),
          ]),
        ));
  }
}
