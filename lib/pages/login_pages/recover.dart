import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_button.dart';
import 'package:supabase_auth/components/my_form_field.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utils/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecoverAccount extends StatefulWidget {
  const RecoverAccount({Key? key}) : super(key: key);

  @override
  State<RecoverAccount> createState() => _RecoverAccountState();
}

class _RecoverAccountState extends State<RecoverAccount> {
  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final List<TextEditingController> _codeControllers =
      List.generate(6, (index) => TextEditingController());

  // State variables
  bool codeSent = false;
  bool verified = false;

  // Method to send verification code
  Future<void> sendVerification() async {
    try {
      setState(() {
        codeSent = true;
      });
      await supabase.auth.resetPasswordForEmail(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account Recovery code sent!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        codeSent = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send verification code: $e'),
          backgroundColor: AppColors.mainColor,
        ),
      );
    }
  }

  // Method to verify the code
  Future<void> verifyCode() async {
    String email = _emailController.text.trim();
    String enteredCode =
        _codeControllers.map((controller) => controller.text).join();

    try {
      await supabase.auth
          .verifyOTP(token: enteredCode, type: OtpType.recovery, email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification successful!'),
          backgroundColor: Colors.green,
        ),
      );
      setState(() {
        verified = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to verify code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to reset the password
  Future<void> resetPassword() async {
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
        ),
        title: const Text("Recover Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: verified ? _resetBlock() : _verificationBlock(),
      ),
    );
  }

  // Widget to build the reset password block
  Column _resetBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Image.asset('assets/images/recover.png'),
        ),
        const Text(
          "Verified Successfully.\nEnter your new password below.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 25),
        CustomTextFormField(
          label: "New Password",
          controller: _newPasswordController,
          enabled: true,
        ),
        const SizedBox(height: 10),
        CustomTextFormField(
          label: "Confirm Password",
          controller: _confirmPasswordController,
          enabled: true,
        ),
        const Spacer(),
        MyCustomButton(onTap: () => resetPassword(), text: "Reset Password"),
        const SizedBox(height: 35),
      ],
    );
  }

  // Widget to build the verification block
  Column _verificationBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Image.asset('assets/images/recover.png'),
        ),
        const Text(
          "Enter your email and we will send you a link to reset your password",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                label: "Email",
                controller: _emailController,
                enabled: true,
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () => sendVerification(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                ),
                child: Text(
                  codeSent ? "Resend Code" : "Send Code",
                  style: const TextStyle(color: Color(0xFFc7052c)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (index) => _buildCodeDigitField(index)),
        ),
        const Spacer(),
        MyCustomButton(onTap: () => verifyCode(), text: "Recover"),
        const SizedBox(height: 35),
      ],
    );
  }

  // Widget to build each code digit field
  Widget _buildCodeDigitField(int index) {
    return Container(
      width: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          counterText: "",
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: AppColors.mainColor, width: 1.0),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: AppColors.mainColor, width: 1.0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            borderSide: BorderSide(color: AppColors.mainColor, width: 1.0),
          ),
        ),
        controller: _codeControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1 && index < _codeControllers.length - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
