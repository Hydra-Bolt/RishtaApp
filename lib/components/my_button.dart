import 'package:flutter/material.dart';
import 'package:supabase_auth/utils/colors.dart';

class MyCustomButton extends StatelessWidget {
  final Future<void> Function() onTap;
  final String text;
  const MyCustomButton({required this.onTap, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: AppColors
                .mainColor), // Assuming AppColors.mainColor is the primary color
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () async {
        await onTap();
      },
    );
  }
}
