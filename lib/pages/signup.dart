// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  final passwordController = TextEditingController();
  final otpController = TextEditingController();
  bool codeEnabled = false;
  bool requestedCode = false;
  Color mainColor = const Color(0xFFFA2A55);

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  void _validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final isValidEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
    final isValidPassword = password.length > 6;

    setState(() {
      codeEnabled = isValidEmail && isValidPassword;
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
            style: TextStyle(color: Colors.grey)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            CustomTextFormField(
                label: "Email", controller: emailController, enabled: true),
            const SizedBox(
              height: 15,
            ),
            CustomTextFormField(
              label: "Password",
              controller: passwordController,
              enabled: true,
              isObscure: true,
            ),
            const SizedBox(
              height: 15,
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
                  width: 5,
                ),
                GestureDetector(
                  onTap: codeEnabled
                      ? () async {
                          try {
                            final email = emailController.text.trim();
                            final password = passwordController.text.trim();
                            await supabase.auth
                                .signUp(email: email, password: password);
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
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          } on Exception {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Error"),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                        }
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  "Enter email address and password first!"),
                              backgroundColor: mainColor,
                            ),
                          ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
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
            SizedBox(
              height: 0.33 * MediaQuery.of(context).size.height,
            ),
            GestureDetector(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: Colors.white12),
                child: Text(
                  "SignUp",
                  style: TextStyle(color: mainColor),
                ),
              ),
              onTap: () async {
                await _verifyOTP(context);
              },
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
            )
          ],
        ),
      ),
    );
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
