// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // final _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authSubsription;

  @override
  void initState() {
    super.initState();
    _authSubsription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      print(session);
      if (session != null) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
      ;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authSubsription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(label: Text("Email")),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(label: Text("Password")),
              obscureText: true,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    await supabase.auth
                        .signInWithPassword(email: email, password: password);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Log in successful")));
                    }
                    Navigator.of(context).pushReplacementNamed("/");
                  } on AuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ));
                  } on Exception catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text("Error"),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ));
                  }
                },
                child: const Text("Login")),
            GestureDetector(
              child: Text("or Sign up"),
              onTap: () =>
                  {Navigator.of(context).pushReplacementNamed("/signup")},
            )
          ],
        ),
      ),
    );
  }
}
