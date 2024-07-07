import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/text_form_fields.dart';

class EditProfilePage extends StatelessWidget {
  final String initialName;
  final String initialEmail;

  const EditProfilePage({
    Key? key,
    required this.initialName,
    required this.initialEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLabeledTextField('Name', 'Your name'),
                  _buildDateRow(),
                  _buildMeasurementRow('Weight', 'Kgs', 'Height', 'cm'),
                  _buildLabeledTextField('Gender', 'Your gender'),
                  _buildLocationRow('Country', 'City'),
                  _buildLocationRow('Religion', 'Cast'),
                  _buildLabeledTextField('Education', 'Education'),
                  _buildLabeledTextField('Job', 'Job'),
                  _buildLabeledTextField('Annual Income', 'Income'),
                  _buildLabeledTextField('Smoker', 'Yes/No'),
                  _buildLabeledTextField('Interests', 'Your interests'),
                  _buildLabeledTextField('Hobbies', 'Your hobbies'),
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
        CustomTextFormField(hint: hint),
        SizedBox(height: 4),
      ],
    );
  }

  Widget _buildDropdownField(
      String label, List<DropdownMenuItem<String>> items) {
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
        SizedBox(height: 4),
        DropdownButtonFormField(
          items: items,
          onChanged: (value) {
            // Handle dropdown value change if needed
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: '$label',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 4),
      ],
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownField('Day', _buildDayItems()),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDropdownField('Month', _buildMonthItems()),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildDropdownField('Year', _buildYearItems()),
        ),
      ],
    );
  }

  Widget _buildMeasurementRow(
      String label1, String hint1, String label2, String hint2) {
    return Row(
      children: [
        Expanded(
          child: _buildLabeledTextField(label1, hint1),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildLabeledTextField(label2, hint2),
        ),
      ],
    );
  }

  Widget _buildLocationRow(String label1, String label2) {
    return Row(
      children: [
        Expanded(
          child: _buildLabeledTextField(label1, label1),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildLabeledTextField(label2, label2),
        ),
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

  List<DropdownMenuItem<String>> _buildDayItems() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 1; i <= 31; i++) {
      items.add(
        DropdownMenuItem(
          value: i.toString(),
          child: Text(i.toString()),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<String>> _buildMonthItems() {
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

    return months.map((month) {
      return DropdownMenuItem(
        value: month,
        child: Text(month),
      );
    }).toList();
  }

  List<DropdownMenuItem<String>> _buildYearItems() {
    List<DropdownMenuItem<String>> items = [];
    for (int year = 1950; year <= DateTime.now().year; year++) {
      items.add(
        DropdownMenuItem(
          value: year.toString(),
          child: Text(year.toString()),
        ),
      );
    }
    return items.reversed.toList();
  }
}
