import 'package:flutter/material.dart';
import 'package:supabase_auth/utils/colors.dart';

class PreferenceForm extends StatefulWidget {
  const PreferenceForm({super.key});

  @override
  State<PreferenceForm> createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("assets/images/app_background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover),
        Scaffold(
          appBar: AppBar(
            title: Text(
              "Add your basic details below",
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text("Preference Forms"),
            ),
          ),
        )
      ],
    );
  }
}
