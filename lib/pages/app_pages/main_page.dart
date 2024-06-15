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
  late Dimensions dimensions;
  late double appBarHeight;
  late double leadingWidth;
  late double leadingMargin;
  late double logoWidth;
  late double logoHeight;
  late double container1Height;
  late double container1Width;
  late double container1TopMargin;
  late double container2Height;
  late double container2Width;
  late double container2BottomMargin;
  late double borderRadius;
  late double containerBorderWidth;

  late Color primaryBackgroundColor;
  late Color mainThemeColor;
  late Color mainPageContainer1Background;
  late Color mainPageContainer2Background;
  late Color shadowColor;

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
