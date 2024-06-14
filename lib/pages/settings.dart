import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: Align(
          alignment: Alignment(0, 0.65),
          child: ElevatedButton(
            onPressed: () {
              supabase.auth.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
            child: const Text('Sign Out'),
          )),
    );
  }
}
