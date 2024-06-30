import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_button.dart';
import 'package:supabase_auth/components/my_choicechips.dart';
import 'package:supabase_auth/components/my_drop_down.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utils/colors.dart';

class PreferenceForm extends StatefulWidget {
  const PreferenceForm({super.key});

  @override
  State<PreferenceForm> createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {
  List<String> _selectedReligions = [];
  String? _selectedEduLevel;
  String? _martialStatus;
  String? _smoking;
  double _minHeight = 150;
  RangeValues _ageRange = const RangeValues(18, 40);

  List<String> religions = [
    'Christianity',
    'Islam',
    'Sikhism',
    'Atheism',
    'Agnosticism',
  ];
  List<String> eduLevels = [
    'At least Intermediate',
    'At least Bachelor\'s Degree',
    'At least Master\'s Degree',
    'At least Doctorate Degree',
  ];
  List<String> martialStatuses = [
    'Divorced',
    'Married',
    'Single',
    'Widowed',
    'Any'
  ];

  List<String> smoking = [
    "Never",
    "Rarely",
    "Sometimes",
    "Often",
    'Doesn\'t matter'
  ];

  Future<void> _submit() async {
    if (_selectedReligions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one religion')),
      );
      return;
    }

    if (_selectedEduLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an education level')),
      );
      return;
    }

    if (_martialStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a marital status')),
      );
      return;
    }

    if (_smoking == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a smoking preference')),
      );
      return;
    }

    // Create a map of the data to be submitted
    final formData = {
      'religion': _selectedReligions,
      'education': _selectedEduLevel,
      'marital_status': _martialStatus,
      'smoking': _smoking,
      'min_height': _minHeight,
      'min_age': (_ageRange.start).toInt(),
      'max_age': _ageRange.end.toInt(),
    };

    final List<Map<String, dynamic>> response =
        await supabase.from("preference").insert(formData).select();

    print(response);
    final id = (response[0]['pid']);
    final res = await supabase
        .from("users")
        .update({"pid": id}).eq("uid", supabase.auth.currentUser!.id);

    // // Example: Send the data to an API endpoint
    // final url = Uri.parse('https://your-api-endpoint.com/preferences');
    // final response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode(formData),
    // );

    // // Handle the response
    if (res == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences submitted successfully!')),
      );
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: const Text('Failed to submit preferences')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text(
          "Preference Details",
          style: TextStyle(color: AppColors.grey),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Text("What are your prefered religions?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            MultiSelectChipWidget(
              items: religions,
              selectedItems: _selectedReligions,
              onSelectionChanged: (p0) {
                setState(() {
                  _selectedReligions = p0;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Partner's Education Level",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomDropdownFormField(
              label: "Education Level",
              value: _selectedEduLevel,
              items: eduLevels,
              onChanged: (value) {
                setState(() {
                  _selectedEduLevel = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Partner's Marital Status",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomDropdownFormField(
              label: "Marital Status",
              value: _martialStatus,
              items: martialStatuses,
              onChanged: (value) {
                setState(() {
                  _martialStatus = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Partner's Smoking",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            CustomDropdownFormField(
              label: "Smoking",
              value: _smoking,
              items: smoking,
              onChanged: (value) {
                setState(() {
                  _smoking = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Minimum Height",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              activeColor: AppColors.mainColor,
              value: _minHeight,
              min: 150,
              max: 250,
              divisions: 100,
              label: _minHeight.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _minHeight = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Preferred Age Range",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            RangeSlider(
              activeColor: AppColors.mainColor,
              values: _ageRange,
              min: 18,
              max: 80,
              divisions: 62,
              labels: RangeLabels(
                _ageRange.start.round().toString(),
                _ageRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _ageRange = values;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
                child: MyCustomButton(onTap: () => _submit(), text: "Submit")),
          ],
        ),
      ),
    );
  }
}
