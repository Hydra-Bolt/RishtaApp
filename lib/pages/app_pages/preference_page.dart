import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/pages/app_pages/edit_preference_page.dart';

class PreferencesTab extends StatefulWidget {
  @override
  _PreferencesTabState createState() => _PreferencesTabState();
}

class _PreferencesTabState extends State<PreferencesTab> {
  bool isLoading = true;
  Map<String, dynamic>? preferenceInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    setState(() {
      isLoading = true;
    });
    var uid = supabase.auth.currentUser!.id;
    try {
      var response =
          await supabase.from('Preference').select().eq('uid', uid).single();
      setState(() {
        preferenceInfo = response;
        isLoading = false;
      });
    } on Exception catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: SizedBox(
            height: 35,
            width: 100,
            child: CustomButtons.editButton(
              onPressed: () {
                if (!isLoading && preferenceInfo!.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditPreferencesPage(initialData: preferenceInfo!),
                    ),
                  );
                }
              },
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLabelWithValue('Education', preferenceInfo!['education']),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                      child: _buildLabelWithValue(
                          'Marital Status', preferenceInfo!['marital_status'])),
                  SizedBox(width: 12.0),
                  Expanded(
                      child: _buildLabelWithValue('Financial Strength',
                          preferenceInfo!['financial_strength'])),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                      child: _buildLabelWithValue('Minimum Height (cm)',
                          preferenceInfo!['min_height'].toString())),
                  SizedBox(width: 10.0),
                  Expanded(
                      child: _buildLabelWithValue(
                          'Smokes', preferenceInfo!['smoking'])),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                      child: _buildLabelWithValue(
                          'Min Age', preferenceInfo!['min_age'].toString())),
                  SizedBox(width: 10.0),
                  Expanded(
                      child: _buildLabelWithValue(
                          'Max Age', preferenceInfo!['max_age'].toString())),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildLabelWithValue(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[800],
                ),
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
