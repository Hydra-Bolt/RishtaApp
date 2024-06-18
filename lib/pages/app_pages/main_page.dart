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
  bool isLoading = true; // Add this line

  /// Initializes the state of the [_MainPageState] class.
  ///
  /// This method is called immediately after the widget is allocated memory.
  /// It fetches the user's data from the database and fetches the rishta
  /// data from the server.
  @override
  void initState() {
    super.initState();

    // Fetches the user's data from the database.
    _fetchUserData();

    // Fetches the rishta data from the server.
    _fetchRishta();

    // TODO: Add comments and docstrings to the code above.
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await supabase
          .from('users')
          .select()
          .eq('uid', supabase.auth.currentUser!.id)
          .single();

      setState(() {
        userData = response;
      });
      if (!mounted) return;
      if (userData!['lid'] == null) {
        Navigator.of(context).pushReplacementNamed('/lifestyle');
      } else if (userData!['pid'] == null) {
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
      final response = await supabase.from('users').select('''
          *,
          preference(*)''').eq('uid', supabase.auth.currentUser!.id).single();
      final usrPrefer = response['preference'];
      const maleFilter = "Female";
      const femaleFilter = "Male";
      final minAge = usrPrefer['min_age'];
      final maxAge = usrPrefer['max_age'];
      final religionString = usrPrefer['religion'];
      List<dynamic> religions = religionString
          .substring(1, religionString.length - 1) // Remove square brackets
          .split(', ') // Split by comma and space
          .map((religion) =>
              religion.replaceAll('"', '')) // Remove double quotes
          .toList();
      print(religions);
      var baseQuery = supabase.from('users').select('''
          *,
          lifestyle(*)
''');

      if (!mounted) return;
      if (response['gender'] == "Male") {
        baseQuery = baseQuery.eq('gender', maleFilter);
      }
      if (response['gender'] == "Female") {
        baseQuery = baseQuery.eq('gender', femaleFilter);
      }

      baseQuery = baseQuery.gte('age', minAge).lte('age', maxAge);

      baseQuery = baseQuery.inFilter('lifestyle.religion', religions);
      final rishtasFound = await baseQuery;

      setState(() {
        rishtas = rishtasFound;
        var rishtaItr = rishtas.iterator;
        rishtaItr.moveNext();
        rishta = rishtaItr.current;
        isLoading = false; // Add this line
        print(rishta);
      });
    } catch (error) {
      // Handle the error appropriately here
      if (mounted) {
        isLoading = false; // Add this line
        print('Error fetching user data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                child: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.mainColor,
                )),
              ) // Add this line
            : rishta == null
                ? Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Oh no! It seems we don’t have any rishtas for you at the moment. But don’t worry, something special might be just around the corner!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
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
                            CustomButtons.closeButton(() {}),
                            const SizedBox(width: 20),
                            CustomButtons.checkButton(() {}),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
