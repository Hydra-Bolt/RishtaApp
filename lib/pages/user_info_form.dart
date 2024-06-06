import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_drop_down.dart';
import 'package:supabase_auth/components/my_form_field.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
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

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: Text(
          "Add your basic details below",
          style: TextStyle(color: AppColors.grey),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "First Name",
                    controller: firstNameController,
                    enabled: true,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: CustomTextFormField(
                    label: "Last Name",
                    controller: lastNameController,
                    enabled: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),
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
                SizedBox(width: 16.0),
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
                SizedBox(width: 16.0),
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
            SizedBox(height: 24.0),
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
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "Weight (kg)",
                    controller: weightController,
                    enabled: true,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: CustomTextFormField(
                    label: "Height (cm)",
                    controller: heightController,
                    enabled: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),
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
            SizedBox(height: 24.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "Spouses",
                    controller: spousesController,
                    enabled: true,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: CustomTextFormField(
                    label: "Children",
                    controller: childrenController,
                    enabled: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                // Add your submit logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors
                    .mainColor, // Assuming AppColors.primary is defined
                padding: EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(
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
