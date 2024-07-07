import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/text_form_fields.dart';
import 'package:supabase_auth/utilities/colors.dart';

class EditProfilePage extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  const EditProfilePage({
    Key? key,
    required this.initialName,
    required this.initialEmail,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  double annualIncome = 10000;

  @override
  Widget build(BuildContext context) {
    final List<String> genders = ['Male', 'Female', 'Other'];

    final List<String> jobSectors = [
      'Technology',
      'Healthcare',
      'Finance',
      'Education',
      'Manufacturing',
      'Retail',
      'Other',
    ];

    final List<String> personalityTypes = [
      'ISTJ',
      'ISFJ',
      'INFJ',
      'INTJ',
      'ISTP',
      'ISFP',
      'INFP',
      'INTP',
      'ESTP',
      'ESFP',
      'ENFP',
      'ENTP',
      'ESTJ',
      'ESFJ',
      'ENFJ',
      'ENTJ',
    ];

    final List<String> religions = [
      'Christianity',
      'Islam',
      'Sikhism',
      'Atheism',
      'Agnosticism',
    ];

    final List<String> citiesInPakistan = [
      'Karachi',
      'Lahore',
      'Islamabad',
      'Rawalpindi',
      'Faisalabad',
      'Multan',
      'Peshawar',
      'Quetta',
      'Sialkot',
      'Gujranwala',
      'Hyderabad',
      'Sukkur',
      'Larkana',
      'Mardan',
      'Abbottabad',
      'Bahawalpur',
      'Sargodha',
      'Sahiwal',
      'Rahim Yar Khan',
      'Sheikhupura',
      'Mirpur',
      'Jhelum',
      'Nowshera',
      'Okara',
    ];

    final List<String> maritalStatus = [
      'Single',
      'Married',
      'Divorced',
      'Widowed',
      'Any'
    ];

    final List<String> smokerOptions = [
      'Never',
      'Rarely',
      'Sometimes',
      'Often'
    ];

    final Map<String, String> education = {
      'Intermediate': 'Intermediate',
      'Some Bachelor\'s Degree': 'Bachelors',
      'Some Master\'s Degree': 'Masters',
      'Some Doctorate': 'Doctorate',
    };

    return Stack(
      children: [
        Image.asset(
          "assets/images/app_background.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 40.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLabeledTextField('Name', 'Your name'),
                  _buildDateRow(),
                  _buildMeasurementRow('Weight', 'Kgs', 'Height', 'cm'),
                  Row(
                    children: [
                      Expanded(child: _buildDropdownField('Gender', genders)),
                      SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdownField(
                              'Personality Type', personalityTypes)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdownField('City', citiesInPakistan)),
                      SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdownField('Religion', religions)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdownField(
                              'Education', education.keys.toList())),
                      SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdownField('Job Sector', jobSectors)),
                    ],
                  ),
                  _buildIncomeSlider(),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdownField('Smoker', smokerOptions)),
                      SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdownField(
                              'Marital Status', maritalStatus)),
                    ],
                  ),
                  _buildDescriptionField(),
                  SizedBox(height: 12),
                  _buildButtonRow(context),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
        // SizedBox(height: 4),
        CustomTextFormField(hint: hint),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        DropdownButtonFormField(
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            // Handle dropdown value change if needed
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '$label',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          isExpanded: true, // Ensures dropdown fills the available space
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownField('Day', _buildDayItems()),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildDropdownField('Month', _buildMonthItems()),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildDropdownField('Year', _buildYearItems()),
        ),
      ],
    );
  }

  Widget _buildIncomeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Annual Income (Rs)',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Slider(
          activeColor: MainColors.mainThemeColor,
          min: 0,
          max: 100000,
          divisions: 1000,
          value: annualIncome,
          onChanged: (value) {
            setState(() {
              annualIncome = value;
            });
          },
        ),
        Text(
          'Rs ${annualIncome.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMeasurementRow(
      String label1, String hint1, String label2, String hint2) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label1,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  // SizedBox(height: 4),
                  CustomTextFormField(hint: hint1),
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label2,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  // SizedBox(height: 4),
                  CustomTextFormField(hint: hint2),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        TextField(
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Write about yourself',
            border: OutlineInputBorder(),
          ),
        ),
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

  List<String> _buildDayItems() {
    List<String> items = [];
    for (int i = 1; i <= 31; i++) {
      items.add(i.toString());
    }
    return items;
  }

  List<String> _buildMonthItems() {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return months;
  }

  List<String> _buildYearItems() {
    List<String> items = [];
    for (int year = 1950; year <= DateTime.now().year; year++) {
      items.add(year.toString());
    }
    return items.reversed.toList();
  }
}
