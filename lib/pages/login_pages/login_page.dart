// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_button.dart';
import 'package:supabase_auth/components/my_form_field.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/dimensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Color mainColor = const Color(0xFFFA2A55);
  // final _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authSubsription;

  @override
  void initState() {
    super.initState();
    _authSubsription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
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
    return MyScaffold(
      appBar: AppBar(
        title: const Text(
          "Login Page",
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            SizedBox(
              height: 0.04 * MediaQuery.of(context).size.height,
            ),
            CustomTextFormField(
                label: "Email", controller: _emailController, enabled: true),
            const SizedBox(
              height: 10,
            ),
            CustomTextFormField(
              label: "Password",
              controller: _passwordController,
              enabled: true,
              isObscure: true,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.of(context).pushReplacementNamed("/recover"),
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: Dimensions(context).height(5)),
              child: Column(
                children: [
                  MyCustomButton(
                    onTap: () async {
                      await _login(context);
                    },
                    text: "Login",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "or",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        child: Text(
                          "Sign up?",
                          style: TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold),
                        ),
                        onTap: () => {
                          Navigator.of(context).pushReplacementNamed("/signup")
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      await supabase.auth.signInWithPassword(email: email, password: password);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Log in successful")));
      }
      Navigator.of(context).pushReplacementNamed("/");
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Error"),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }
}
