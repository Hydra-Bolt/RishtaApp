import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/dimensions.dart';
import 'package:supabase_auth/utilities/colors.dart';
import 'package:supabase_auth/utilities/buttons.dart';

class ExtendedRishtaPage extends StatefulWidget {
  const ExtendedRishtaPage({super.key});

  @override
  _ExtendedRishtaPage createState() => _ExtendedRishtaPage();
}

class _ExtendedRishtaPage extends State<ExtendedRishtaPage> {
  late Color primaryBackgroundColor;
  late Color mainThemeColor;
  late Color mainPageContainer1Background;
  late Color mainPageContainer2Background;
  late Color shadowColor;

  @override
  Widget build(BuildContext context) {
    primaryBackgroundColor = MainColors.primaryBackground;
    mainThemeColor = MainColors.mainThemeColor;
    mainPageContainer1Background = MainColors.mainPageContainer1Background;
    mainPageContainer2Background = MainColors.mainPageContainer2Background;
    shadowColor = MainColors.shadowColor;
    final Dimensions dimensions = Dimensions(context);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: CustomButtons.heartButton(),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: dimensions.height(55)),
                width: dimensions.screenWidth(),
                height: dimensions.height(80),
                decoration: BoxDecoration(
                  color: mainPageContainer1Background,
                  borderRadius: BorderRadius.circular(dimensions.width(3.54)),
                  border: Border.all(color: mainThemeColor, width: 1.5),
                ),
              ),
              Container(
                width: dimensions.screenWidth(),
                height: dimensions.height(60),
                decoration: BoxDecoration(
                  color: mainPageContainer2Background,
                  borderRadius: BorderRadius.circular(dimensions.width(3.54)),
                  border: Border.all(color: mainThemeColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: 30,
                  left: 20,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const CircleAvatar(
                      radius: 28,
                      backgroundImage:
                          AssetImage('./assets/icons/backIcon.png'),
                      backgroundColor: Colors.transparent,
                      // foregroundColor: Colors.black,
                      // backgroundColor: Colors.transparent,
                    ),
                  )),
              // child: CircleAvatar(
              //   radius: 18,
              //   backgroundColor: Colors.transparent,
              //   foregroundColor: Colors.transparent,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     style: ElevatedButton.styleFrom(
              //       padding: EdgeInsets.zero,
              //       foregroundColor: Colors.white,
              //       backgroundColor: Colors.transparent,
              //     ),
              //     child: const Icon(Icons.backspace_rounded, size: 30),
              //   ),
              // )),

              Positioned(
                bottom: dimensions.height(2),
                width: dimensions.screenWidth(),
                child:
                    ButtonBar(alignment: MainAxisAlignment.center, children: [
                  CustomButtons.closeButton(() {}),
                  const SizedBox(width: 20),
                  CustomButtons.checkButton(() {})
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
