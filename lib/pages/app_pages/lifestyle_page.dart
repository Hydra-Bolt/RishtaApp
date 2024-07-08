import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/profile_info_container.dart';
import 'package:supabase_auth/utilities/profile_picture_container.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/pages/app_pages/edit_lifestyle_page.dart';

class LifestyleTab extends StatefulWidget {
  @override
  _LifestyleTabState createState() => _LifestyleTabState();
}

class _LifestyleTabState extends State<LifestyleTab> {
  Map<String, dynamic> combinedInfo = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the widget initializes
  }

  Future<void> _fetchUserData() async {
    var uid = supabase.auth.currentUser!.id;
    setState(() {
      isLoading = true; // Set isLoading to true before fetching data
    });
    try {
      var response1 =
          await supabase.from('Users').select().eq('uid', uid).single();
      var response2 =
          await supabase.from('Lifestyle').select().eq('uid', uid).single();
      Map<String, dynamic> combinedData = {
        'first_name': response1['first_name'],
        'last_name': response1['last_name'],
        'weight': response1['weight'],
        'height': response1['height'],
        'gender': response1['gender'],
        'marital_status': response1['marital_status'],
        'city': response1['city'],
        'dob': response1['dob'],
        'job_sector': response2['job_sector'],
        'education': response2['education'],
        'religion': response2['religion'],
        'personality_type': response2['personality_type'],
        'smoking': response2['smoking']
      };

      setState(() {
        isLoading = false; // Set isLoading to false after data is fetched
        combinedInfo = combinedData;
      });
      print(combinedData);
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: SizedBox(
          height: 35,
          width: 100,
          child: CustomButtons.editButton(
            'lifestyle',
            onPressed: () {
              if (combinedInfo.isNotEmpty && !isLoading) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditLifestylePage(initialData: combinedInfo),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : combinedInfo.isNotEmpty
              ? SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const ProfileImageContainer(),
                        ProfileInfoContainer(profileInfo: combinedInfo),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text('No Data Available'),
                ),
    );
  }
}
