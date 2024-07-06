// custom_buttons.dart
import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/colors.dart';

class CustomButtons {
  static Widget closeButton(
    void Function()? onPressed,
  ) {
    return SizedBox(
      width: 110,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Icon(Icons.close, size: 30),
      ),
    );
  }

  static Widget checkButton(void Function()? onPressed) {
    return SizedBox(
      width: 110,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: MainColors.mainThemeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Icon(Icons.check, size: 30),
      ),
    );
  }

  static Widget heartButton() {
    return FloatingActionButton(
        onPressed: () {},
        backgroundColor: MainColors.mainPageContainer2Background,
        elevation: 5,
        shape: const CircleBorder(),
        child: const ImageIcon(
          AssetImage('assets/icons/HeartIcon.png'),
          size: 40,
          color: Color(0xFFFC8EAC),
        ));
  }

  static Widget popupMenuButton({Function(int)? onSelected}) {
    return PopupMenuButton<int>(
      onSelected: onSelected ?? (int value) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Report this rishta'),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('Don`t Recommend this rishta again'),
        ),
      ],
    );
  }
}
