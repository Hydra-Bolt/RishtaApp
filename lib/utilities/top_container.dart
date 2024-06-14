import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:supabase_auth/utilities/buttons.dart';

class TopContainer extends StatelessWidget {
  final double height;
  final double width;
  final double bottomMargin;
  final Color backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final Color shadowColor;

  const TopContainer({
    super.key,
    required this.height,
    required this.width,
    required this.bottomMargin,
    required this.backgroundColor,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(bottom: bottomMargin),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            AnotherCarousel(
              images: const [
                AssetImage('assets/images/muneeb1.png'),
                AssetImage('assets/images/muneeb2.png'),
                AssetImage('assets/images/muneeb3.png')
              ],
              dotSize: 3,
              indicatorBgPadding: 4,
              autoplayDuration: const Duration(seconds: 5),
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: CustomButtons.popupMenuButton(),
            ),
          ],
        ),
      ),
    );
  }
}
