import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:supabase_auth/utilities/buttons.dart';

class TopContainer extends StatefulWidget {
  final double height;
  final double width;
  final double bottomMargin;
  final Color backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final Color shadowColor;
  final dynamic rishta;

  const TopContainer({
    super.key,
    required this.rishta,
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
  State<TopContainer> createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: EdgeInsets.only(bottom: widget.bottomMargin),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border:
            Border.all(color: widget.borderColor, width: widget.borderWidth),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
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
