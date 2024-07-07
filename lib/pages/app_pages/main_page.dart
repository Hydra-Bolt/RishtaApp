import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/bottom_container.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/utilities/colors.dart';
import 'package:supabase_auth/utilities/dimensions.dart';
import 'package:supabase_auth/utilities/top_container.dart';
import 'package:supabase_auth/utils/colors.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainPageState();
}

class _MainPageState extends State<MainHomePage>
    with AutomaticKeepAliveClientMixin<MainHomePage> {
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
  late double container1BotttomMargin;
  late double container2BottomMargin;
  late double borderRadius;
  late double containerBorderWidth;

  late Color primaryBackgroundColor;
  late Color mainThemeColor;
  late Color mainPageContainer1Background;
  late Color mainPageContainer2Background;
  late Color shadowColor;

  List rishtas = [];
  dynamic rishta;
  Map<String, dynamic>? userData;
  bool isLoading = true;
  Iterator<dynamic>? rishtaItr; // Add this line

  /// Initializes the state of the [_MainPageState] class.
  ///
  /// This method is called immediately after the widget is allocated memory.
  /// It fetches the user's data from the database and fetches the rishta
  /// data from the server.
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    print("CURRENT UID: ${supabase.auth.currentUser!.id}");
    super.initState();

    // Fetches the user's data from the database.
    _fetchUserData();

    // Fetches the rishta data from the server.
    _fetchRishta();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await supabase
          .from('Users')
          .select()
          .eq('uid', supabase.auth.currentUser!.id)
          .single();
      setState(() {
        userData = response;
      });
      if (!mounted) return;

      final bool filledLifeStyleForm = await supabase
          .from('Lifestyle')
          .select()
          .eq('uid', supabase.auth.currentUser!.id)
          .single()
          .then((value) => true)
          .onError((error, stackTrace) => false);

      final bool filledPreferenceForm = await supabase
          .from('Preference')
          .select()
          .eq('uid', supabase.auth.currentUser!.id)
          .single()
          .then((value) => true)
          .onError((error, stackTrace) => false);

      if (filledLifeStyleForm == false) {
        Navigator.of(context).pushReplacementNamed('/lifestyle');
      } else if (filledPreferenceForm == false) {
        Navigator.of(context).pushReplacementNamed('/preference');
      }
    } catch (error) {
      // Handle the error appropriately here
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/userform');
        print('Error fetching user data: $error');
      }
    }
  }

  Future<void> _fetchRishta() async {
    try {
      final uid = supabase.auth.currentUser!.id;
      final List<dynamic> response =
          await supabase.rpc('fetch_rishta', params: {'in_uid': uid});
      print(response);
      final rishtasFound = response;
      setState(() {
        rishtas = rishtasFound;
        rishtaItr = rishtas.iterator;
        rishtaItr!.moveNext();
        rishta = rishtaItr!.current;
        isLoading = false; // Add this line
      });
    } catch (error) {
      // Handle the error appropriately here
      if (mounted) {
        isLoading = false; // Add this line
        print('Error fetching user data: $error');
      }
    }
  }

  void handleMatch(String status) async {
    await supabase.from("Matches").insert({
      'request_by': supabase.auth.currentUser!.id,
      'request_to': rishta['uid'],
      'status': status
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    dimensions = Dimensions(context);
    appBarHeight = dimensions.height(8.78);
    leadingWidth = dimensions.screenWidth();
    leadingMargin = dimensions.height(4.184);
    logoWidth = dimensions.width(25.82);
    logoHeight = dimensions.height(24.64);
    container1Height = dimensions.height(19.69);
    container1Width = dimensions.width(84.07);
    container1TopMargin = dimensions.height(47);
    container2Height = dimensions.height(66.16);
    container2Width = dimensions.width(84.07);
    container2BottomMargin = dimensions.height(36.38);
    container1BotttomMargin = dimensions.height(9.38);
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
      body: Container(
        alignment: Alignment.topCenter,
        child: isLoading
            ? Transform.scale(
                scale: 1.3,
                child: const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                )),
              )
            : rishta == null
                ? Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          './assets/images/search.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Oh no! It seems we don`t have any rishtas for you at the moment.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'But don`t worry, something special might be just around the corner!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      // Bottom Container
                      BottomContainer(
                        rishta: rishta,
                        height: container1Height,
                        width: container1Width,
                        topMargin: container1TopMargin,
                        bottomMargin: container1BotttomMargin,
                        backgroundColor: mainPageContainer1Background,
                        borderRadius: borderRadius,
                        borderColor: mainThemeColor,
                        borderWidth: containerBorderWidth,
                      ),
                      // Top Container
                      TopContainer(
                        rishta: rishta,
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
                        bottom: dimensions.height(9.5),
                        width: container1Width,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: [
                            CustomButtons.closeButton(() {
                              // _rejected()

                              handleMatch("No request made");
                              if (rishtaItr!.moveNext()) {
                                setState(() {
                                  rishta = rishtaItr!.current;
                                });
                              }
                            }),
                            const SizedBox(width: 20),
                            CustomButtons.checkButton(() async {
                              // _accepted()

                              handleMatch("Waiting for response");
                              if (rishtaItr!.moveNext()) {
                                setState(() {
                                  rishta = rishtaItr!.current;
                                });
                              }
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
