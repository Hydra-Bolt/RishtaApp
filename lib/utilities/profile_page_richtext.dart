import 'package:flutter/material.dart';
import 'package:supabase_auth/utils/string_extension.dart';

class ProfileRichText extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const ProfileRichText({
    super.key,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildLabelWithValue(
                    'Name',
                    "${profileData['first_name'].toString().toCapitalized()} ${profileData['last_name'].toString().toCapitalized()}",
                  ),
                ),
                const SizedBox(width: 24.0),
                Expanded(
                  child: _buildLabelWithValue(
                      'Marital Status', profileData['marital_status']),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: _buildLabelWithValue(
                      'Weight', profileData['weight'].toString()),
                ),
                const SizedBox(height: 24.0),
                Expanded(
                  child: _buildLabelWithValue(
                      'Height', profileData['height'].toString()),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                    child:
                        _buildLabelWithValue('Gender', profileData['gender'])),
                const SizedBox(height: 24.0),
                Expanded(
                    child: _buildLabelWithValue(
                        'Smoking', profileData['smoking'])),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                    child: _buildLabelWithValue('City', profileData['city'])),
                const SizedBox(height: 24.0),
                Expanded(
                    child: _buildLabelWithValue(
                        'Date of Birth', profileData['dob'])),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                    child: _buildLabelWithValue(
                        'Job Sector', profileData['job_sector'])),
                const SizedBox(height: 24.0),
                Expanded(
                    child: _buildLabelWithValue(
                        'Education', profileData['education'])),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                    child: _buildLabelWithValue(
                        'Religion', profileData['religion'])),
                const SizedBox(height: 24.0),
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
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[800],
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
