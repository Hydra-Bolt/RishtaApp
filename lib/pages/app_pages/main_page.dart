import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/bottom_container.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/utilities/colors.dart';
import 'package:supabase_auth/utilities/dimensions.dart';
import 'package:supabase_auth/utilities/top_container.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainPageState();
}

class _MainPageState extends State<MainHomePage> {
  late final Dimensions dimensions;
  late final double appBarHeight;
  late final double leadingWidth;
  late final double leadingMargin;
  late final double logoWidth;
  late final double logoHeight;
  late final double container1Height;
  late final double container1Width;
  late final double container1TopMargin;
  late final double container2Height;
  late final double container2Width;
  late final double container2BottomMargin;
  late final double borderRadius;
  late final double containerBorderWidth;

  late final Color primaryBackgroundColor;
  late final Color mainThemeColor;
  late final Color mainPageContainer1Background;
  late final Color mainPageContainer2Background;
  late final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    dimensions = Dimensions(context);
    appBarHeight = dimensions.height(15.78);
    leadingWidth = dimensions.screenWidth();
    leadingMargin = dimensions.height(4.184);
    logoWidth = dimensions.width(39.82);
    logoHeight = dimensions.height(14.64);
    container1Height = dimensions.height(15.69);
    container1Width = dimensions.width(84.07);
    container1TopMargin = dimensions.height(45);
    container2Height = dimensions.height(49.16);
    container2Width = dimensions.width(84.07);
    container2BottomMargin = dimensions.height(31.38);
    borderRadius = dimensions.width(3.54);
    containerBorderWidth = 1.5;

    primaryBackgroundColor = MainColors.primaryBackground;
    mainThemeColor = MainColors.mainThemeColor;
    mainPageContainer1Background = MainColors.mainPageContainer1Background;
    mainPageContainer2Background = MainColors.mainPageContainer2Background;
    shadowColor = MainColors.shadowColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: appBarHeight,
        backgroundColor: Colors.transparent,
        leadingWidth: leadingWidth,
        leading: Container(
          margin: EdgeInsets.only(bottom: leadingMargin),
          alignment: Alignment.center,
          child: Image.asset(
            './assets/icons/Title3.png',
            width: logoWidth,
            height: logoHeight,
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            // Bottom Container
            BottomContainer(
              height: container1Height,
              width: container1Width,
              topMargin: container1TopMargin,
              backgroundColor: mainPageContainer1Background,
              borderRadius: borderRadius,
              borderColor: mainThemeColor,
              borderWidth: containerBorderWidth,
            ),
            // Top Container
            TopContainer(
              height: container2Height,
              width: container2Width,
              bottomMargin: container2BottomMargin,
              backgroundColor: mainPageContainer2Background,
              borderRadius: borderRadius,
              borderColor: mainThemeColor,
              borderWidth: containerBorderWidth,
              shadowColor: shadowColor,
            ),
            // Buttons
            Positioned(
              bottom: 120,
              width: container1Width,
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  CustomButtons.closeButton(),
                  const SizedBox(width: 20),
                  CustomButtons.checkButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
