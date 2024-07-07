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

  String? selectedCity;
  String? selectedDay;
  String? selectedMonth;
  String? selectedYear;
  String? selectedGender;
  String? selectedMaritalStatus = 'Any';

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
  final List<String> maritalStatus = [
    'Single',
    'Married',
    'Divorced',
    'Widowed',
    'Any'
  ];

  Future<void> _submit() async {
    final String firstName = firstNameController.text.trim();
    final String lastName = lastNameController.text.trim();
    final int? weight = int.tryParse(weightController.text);
    final int? height = int.tryParse(heightController.text);

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        weight == null ||
        height == null ||
        selectedDay == null ||
        selectedMonth == null ||
        selectedYear == null ||
        selectedGender == null ||
        selectedCity == null ||
        selectedMaritalStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
      return;
    }

    final String dob = '$selectedYear-$selectedMonth-$selectedDay';
    Object values = {
      'uid': supabase.auth.currentUser!.id,
      'username': supabase.auth.currentUser!.userMetadata!['username'],
      'first_name': firstName,
      'last_name': lastName,
      'weight': weight,
      'height': height,
      'dob': dob,
      'gender': selectedGender,
      'city': selectedCity,
      'marital_status': selectedMaritalStatus,
    };
    // {uid: sauhduh324jknkjwe23, username: esrjsekjk, first_name: Moiz, last_name: Khan, weight: 47, height: 121, dob: 2015-4-7, age: 9, gender: Male, city: Sialkot, maritalStatus: Single}
    try {
      await supabase.from('Users').insert(values);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Data Saved Successfully!')));
      Navigator.of(context).pushReplacementNamed('/home');
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } on PostgrestException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  // No need of Age here.
  // void calculateAge() {
  //   if (selectedDay != null && selectedMonth != null && selectedYear != null) {
  //     final int day = int.parse(selectedDay!);
  //     final int month = int.parse(selectedMonth!);
  //     final int year = int.parse(selectedYear!);

  //     final DateTime dob = DateTime(year, month, day);
  //     final DateTime today = DateTime.now();

  //     int age = today.year - dob.year;
  //     if (today.month < dob.month ||
  //         (today.month == dob.month && today.day < dob.day)) {
  //       age--;
  //     }

  //     setState(() {
  //       calculatedAge = age;
  //     });
  //   }
  // }

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
                        // calculateAge();
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
                        // calculateAge();
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
                        // calculateAge();
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
            CustomDropdownFormField(
              label: "Marital Status",
              value: selectedMaritalStatus,
              items: maritalStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMaritalStatus = newValue;
                });
              },
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors
                    .mainColor, // Assuming AppColors.mainColor is defined
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
