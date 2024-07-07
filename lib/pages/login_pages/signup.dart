// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_button.dart';
import 'package:supabase_auth/components/my_form_field.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool codeEnabled = false;
  bool requestedCode = false;
  Color mainColor = const Color(0xFFFA2A55);

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateForm);
    usernameController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = emailController.text.trim();
    final username = usernameController.text.trim();

    final password = passwordController.text.trim();
    final isValidEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final isValidPassword = password.length > 6;
    final isValidUsername = username.length > 4;

    setState(() {
      codeEnabled = isValidEmail && isValidPassword && isValidUsername;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text("Let's get you set up!",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            CustomTextFormField(
                label: "Email", controller: emailController, enabled: true),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
                label: "Username",
                controller: usernameController,
                enabled: true),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              label: "Password",
              controller: passwordController,
              enabled: true,
              isObscure: true,
            ),
            const SizedBox(
              height: 8,
            ),
            CustomTextFormField(
              label: "Confirm Passoword",
              controller: confirmPasswordController,
              enabled: true,
              isObscure: true,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                      label: "Verification Code",
                      controller: otpController,
                      enabled: requestedCode),
                ),
                const SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: codeEnabled
                      ? () async {
                          await _sendVerificationCode(context);
                        }
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  "Enter email, username and password first!"),
                              backgroundColor: mainColor,
                            ),
                          ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    decoration: BoxDecoration(
                      color: codeEnabled ? Colors.white12 : Colors.white10,
                      border: Border.all(color: Colors.white, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(3)),
                    ),
                    child: Text(
                      "Send Code",
                      style: TextStyle(
                          color: codeEnabled
                              ? mainColor
                              : const Color(0xFFc7052c)),
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            MyCustomButton(
              onTap: () async {
                await _verifyOTP(context);
              },
              text: "Sign Up",
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Or",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  width: 3,
                ),
                GestureDetector(
                  child: Text(
                    "Login?",
                    style: TextStyle(
                        color: mainColor, fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    Navigator.of(context).pushReplacementNamed("/login");
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendVerificationCode(BuildContext context) async {
    try {
      final email = emailController.text.trim();
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();
      final confirm = confirmPasswordController.text.trim();
      if (password != confirm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
          ),
        );
        return;
      }
      await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("OTP sent, check your inbox"),
          ),
        );
        setState(() {
          requestedCode = true;
        });
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Error"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _verifyOTP(BuildContext context) async {
    try {
      final email = emailController.text.trim();
      final otp = otpController.text.trim();
      await supabase.auth
          .verifyOTP(token: otp, type: OtpType.signup, email: email);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Verified!")));
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

  CustomTextFormField _myFormField(
      String label, TextEditingController controller, bool enabled) {
    return CustomTextFormField(
        label: label, controller: controller, enabled: enabled);
  }
}
