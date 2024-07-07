import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/pages/app_pages/edit_preference_page.dart';

class PreferencesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: SizedBox(
            height: 35,
            width: 100,
            child: CustomButtons.editButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPreferencesPage(),
                  ),
                );
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
              Row(
                children: [
                  Expanded(
                      child: _buildLabelWithValue('Education', 'Bachelors')),
                  SizedBox(width: 12),
                  Expanded(child: _buildLabelWithValue('Religion', 'Islam')),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                      child: _buildLabelWithValue('Marital Status', 'Single')),
                  SizedBox(width: 12.0),
                  Expanded(
                      child:
                          _buildLabelWithValue('Financial Strength', 'Normal')),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(
                      child: _buildLabelWithValue('MinHeight (cm)', '170')),
                  SizedBox(width: 12.0),
                  Expanded(child: _buildLabelWithValue('Smokes', 'Never')),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Expanded(child: _buildLabelWithValue('Min Age', '25')),
                  SizedBox(width: 12.0),
                  Expanded(child: _buildLabelWithValue('Max Age', '30')),
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
