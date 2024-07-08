import 'package:flutter/material.dart';
import 'package:supabase_auth/utils/string_extension.dart';

class ProfileRichText extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const ProfileRichText({
    Key? key,
    required this.profileData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildLabelWithValue(
                    'Name',
                    profileData['first_name'].toString().toCapitalized() +
                        " " +
                        profileData['last_name'].toString().toCapitalized(),
                  ),
                ),
                Expanded(
                  child: _buildLabelWithValue(
                      'Marital Status', profileData['marital_status']),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: _buildLabelWithValue(
                      'Weight', profileData['weight'].toString()),
                ),
                SizedBox(height: 24.0),
                Expanded(
                  child: _buildLabelWithValue(
                      'Height', profileData['height'].toString()),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                    child:
                        _buildLabelWithValue('Gender', profileData['gender'])),
                SizedBox(height: 24.0),
                Expanded(
                    child: _buildLabelWithValue(
                        'Smoking', profileData['smoking'])),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                    child: _buildLabelWithValue('City', profileData['city'])),
                SizedBox(height: 24.0),
                Expanded(
                    child: _buildLabelWithValue(
                        'Date of Birth', profileData['dob'])),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                    child: _buildLabelWithValue(
                        'Job Sector', profileData['job_sector'])),
                SizedBox(height: 24.0),
                Expanded(
                    child: _buildLabelWithValue(
                        'Education', profileData['education'])),
              ],
            ),
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                    child: _buildLabelWithValue(
                        'Religion', profileData['religion'])),
                SizedBox(height: 24.0),
                Expanded(
                  child: _buildLabelWithValue(
                      'Personality Type', profileData['personality_type']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelWithValue(String label, String value) {
    return Column(
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
    );
  }
}
