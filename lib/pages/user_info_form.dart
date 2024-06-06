import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_auth/components/my_drop_down.dart';
import 'package:supabase_auth/components/my_form_field.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utils/colors.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController spousesController = TextEditingController();
  final TextEditingController childrenController = TextEditingController();

  String? selectedCity;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? selectedGender;

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

  final List<String> days =
      List<String>.generate(31, (index) => (index + 1).toString());
  final List<String> months =
      List<String>.generate(12, (index) => (index + 1).toString());
  final List<String> years = List<String>.generate(
      100, (index) => (DateTime.now().year - index).toString());

  final List<String> genders = ['Male', 'Female', 'Other'];

  Future<void> _submit() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final int? weight = int.tryParse(weightController.text);
    final int? height = int.tryParse(heightController.text);
    final int? spouses = int.tryParse(spousesController.text);
    final int? children = int.tryParse(childrenController.text);

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        weight == null ||
        height == null ||
        selectedDay == null ||
        selectedMonth == null ||
        selectedYear == null ||
        selectedGender == null ||
        selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    final String dob = '$selectedYear-$selectedMonth-$selectedDay';

    try {
      final response = await supabase.from('users').insert({
        'uid': supabase.auth.currentUser!.id,
        'name': firstName + lastName,
        'weight': weight,
        'height': height,
        'dob': dob,
        'gender': selectedGender,
        'city': selectedCity,
        'spouse': spouses ?? 0,
        'kids': children ?? 0,
      });

      if (response.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data saved successfully!')));
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.error!.message}')));
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } on PostgrestException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text(
          "Add your basic details below",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "First Name",
                    controller: firstNameController,
                    enabled: true,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: CustomTextFormField(
                    label: "Last Name",
                    controller: lastNameController,
                    enabled: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: CustomDropdownFormField(
                    label: "Day",
                    value: selectedDay,
                    items: days,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDay = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: CustomDropdownFormField(
                    label: "Month",
                    value: selectedMonth,
                    items: months,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedMonth = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: CustomDropdownFormField(
                    label: "Year",
                    value: selectedYear,
                    items: years,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedYear = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            CustomDropdownFormField(
              label: "Gender",
              value: selectedGender,
              items: genders,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "Weight (kg)",
                    controller: weightController,
                    enabled: true,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: CustomTextFormField(
                    label: "Height (cm)",
                    controller: heightController,
                    enabled: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            CustomDropdownFormField(
              label: "City",
              value: selectedCity,
              items: citiesInPakistan,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCity = newValue;
                });
              },
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "Spouses",
                    controller: spousesController,
                    enabled: true,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: CustomTextFormField(
                    label: "Children",
                    controller: childrenController,
                    enabled: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors
                    .mainColor, // Assuming AppColors.primary is defined
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
