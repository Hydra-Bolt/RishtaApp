import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/text_form_fields.dart';

class EditPreferencesPage extends StatefulWidget {
  @override
  _EditPreferencesPageState createState() => _EditPreferencesPageState();
}

class _EditPreferencesPageState extends State<EditPreferencesPage> {
  String? selectedEducationLevel;
  String? selectedReligion;
  String? selectedMaritalStatus;
  String? selectedFinancialStrength;
  String? selectedSmokerOption;

  final List<String> educationLevels = [
    'Intermediate',
    'Some Bachelor\'s Degree',
    'Some Master\'s Degree',
    'Some Doctorate',
  ];

  final List<String> maritalStatusOptions = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Any',
  ];

  final List<String> financialStrengthOptions = [
    'Low',
    'Normal',
    'Strong',
  ];

  final List<String> smokerOptions = [
    'Never',
    'Rarely',
    'Sometimes',
    'Often',
    'Any',
  ];

  final List<String> religions = [
    'Christianity',
    'Islam',
    'Sikhism',
    'Atheism',
    'Agnosticism',
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets/images/app_background.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                        'Education', educationLevels, selectedEducationLevel,
                        (String? value) {
                      setState(() {
                        selectedEducationLevel = value;
                      });
                    }),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: _buildDropdownField(
                        'Religion', religions, selectedReligion,
                        (String? value) {
                      setState(() {
                        selectedReligion = value;
                      });
                    }),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                        'Marital Status',
                        maritalStatusOptions,
                        selectedMaritalStatus, (String? value) {
                      setState(() {
                        selectedMaritalStatus = value;
                      });
                    }),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: _buildDropdownField(
                        'Financial Strength',
                        financialStrengthOptions,
                        selectedFinancialStrength, (String? value) {
                      setState(() {
                        selectedFinancialStrength = value;
                      });
                    }),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: _buildLabeledTextField('MinHeight', 'cm'),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: _buildDropdownField(
                        'Smoker', smokerOptions, selectedSmokerOption,
                        (String? value) {
                      setState(() {
                        selectedSmokerOption = value;
                      });
                    }),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: _buildLabeledTextField('Min Age', '25'),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: _buildLabeledTextField('Max Age', '30'),
                  ),
                ],
              ),
              _buildButtonRow(context),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget _buildLabeledTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        CustomTextFormField(hint: hint),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String? value,
      void Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '$label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          isExpanded: true,
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.grey,
          ),
          child: Text('Cancel'),
        ),
        SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFA2A55),
              foregroundColor: Colors.white),
          child: Text('Save'),
        ),
      ],
    );
  }
}
