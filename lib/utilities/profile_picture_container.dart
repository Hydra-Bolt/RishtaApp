import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/dimensions.dart';
import 'package:supabase_auth/utilities/colors.dart';

class ProfileImageContainer extends StatelessWidget {
  const ProfileImageContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final Dimensions dimensions = Dimensions(context);

    final double containerWidth = dimensions.width(85);
    final double imageContainerMarginBottom = dimensions.height(45);
    final double imageContainerHeight = dimensions.height(55);
    final double borderRadius = dimensions.width(3.54);
    const double containerBorderWidth = 1.5;
    const Color mainThemeColor = MainColors.mainThemeColor;
    const Color containerBackground = MainColors.profilePageContainerBackground;
    const Color shadowColor = MainColors.shadowColor;

    return Container(
      width: containerWidth,
      height: imageContainerHeight,
      decoration: BoxDecoration(
        color: containerBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: mainThemeColor, width: containerBorderWidth),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/images/male.jpg',
          fit: BoxFit.cover, // Adjusted fit property
        ),
      ),
    );
  }
}
