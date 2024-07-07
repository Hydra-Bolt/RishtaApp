import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/pages/app_pages/rishta_clicked_page.dart';
import 'package:supabase_auth/utilities/main_page_info_container.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/utilities/colors.dart';
import 'package:supabase_auth/utilities/dimensions.dart';
import 'package:supabase_auth/utilities/main_page_picture_container.dart';
import 'package:supabase_auth/utils/colors.dart';
import 'package:supabase_auth/utils/string_extension.dart';

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
          .from("Users")
          .select()
          .eq('uid', supabase.auth.currentUser!.id)
          .eq('username', supabase.auth.currentUser!.userMetadata!['username']);

      setState(() {
        userData = response[0];
      });
      if (!mounted) return;

      final bool filledLifeStyleForm = await supabase
          .from('Lifestyle')
          .select()
          .eq('uid', supabase.auth.currentUser!.id)
          .single()
          .then((value) => true)
          .onError((error, stackTrace) => false);

      final filledPreferenceForm = await supabase
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

      // Fetch already added rishtas
      final alreadyAddedRishtas = await supabase
          .from('Matches')
          .select()
          .or('request_by.eq.$uid,request_to.eq.$uid');
      print('Already Added $alreadyAddedRishtas');

      List<String> addedUids = [];

      for (var match in alreadyAddedRishtas) {
        if (match['request_by'] != uid) {
          addedUids.add(match['request_by']);
        }
        if (match['request_to'] != uid) {
          addedUids.add(match['request_to']);
        }
      }

      print('Filtered UIDs: $addedUids');

      // Fetch rishtas that match the user's criteria
      final List<dynamic>? response = await supabase
          .rpc('get_user_matches_on_religion', params: {'in_uid': uid});

      print(response);

      List<Map<String, dynamic>> rishtasFound = [];

      if (response != null && response.isNotEmpty) {
        rishtasFound = response.where((res) {
          return !addedUids.contains(res['uid']);
        }).map((res) {
          // Calculate age
          final DateTime today = DateTime.now();
          final DateTime dob = DateTime.parse(res['dob']);
          int userAge = today.year - dob.year;
          if (today.month < dob.month ||
              (today.month == dob.month && today.day < dob.day)) {
            userAge--;
          }

          // Create a map with 'name', 'age', 'uid', and 'gender'
          return {
            'name':
                '${res['first_name'].toString().toCapitalized()} ${res['last_name'].toString().toCapitalized()}',
            'age': userAge,
            'uid': res['uid'],
            'gender': res['gender']
          };
        }).toList();
      }

      // Print the filtered result
      print('Rishtas Found: $rishtasFound');

      setState(() {
        rishtas = rishtasFound;
        if (rishtas.isNotEmpty) {
          rishtaItr = rishtas.iterator;
          rishtaItr!.moveNext();
          rishta = rishtaItr!.current;
        }
        isLoading = false;
      });
    } catch (error) {
      // Handle the error appropriately here
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        print('Error fetching user data problem in fetching rishta: $error');
      }
    }
  }

  void handleMatch(String status) async {
    await supabase.from("Matches").insert({
      'request_by': supabase.auth.currentUser!.id,
      'request_to': rishta['uid'],
      'response': status
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double height = MediaQuery.of(context).size.height;
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
    container2BottomMargin = dimensions.height(38.3);
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
              ) // Add this line
            : rishta == null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.topCenter,
                    child: const Text(
                      'Oh no! It seems we don`t have any rishtas for you at the moment. But don`t worry, something special might be just around the corner!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      // // Bottom Container
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
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ExtendedRishtaPage()));
                        },
                        child: TopContainer(
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

                              // handleMatch("Rejected");
                              if (rishtaItr!.moveNext()) {
                                setState(() {
                                  rishta = rishtaItr!.current;
                                });
                              } else {
                                setState(() {
                                  rishta = null;
                                });
                              }
                            }),
                            const SizedBox(width: 20),
                            CustomButtons.checkButton(() async {
                              // _accepted()

                              handleMatch("Pending");

                              await Future.delayed(
                                  const Duration(milliseconds: 2000));

                              if (rishtaItr!.moveNext() == true) {
                                setState(() {
                                  rishta = rishtaItr!.current;
                                });
                              } else {
                                setState(() {
                                  rishta = null;
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
