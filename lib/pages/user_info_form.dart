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
        title: const Text(
          "Add your basic details below",
          style: TextStyle(color: AppColors.grey),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "First Name",
                    controller: firstNameController,
                    enabled: true,
                  ),
                ),
                const SizedBox(
                    width: 16.0), // Add some space between the two text fields
                Expanded(
                  child: CustomTextFormField(
                    label: "Last Name",
                    controller: lastNameController,
                    enabled: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 16.0),
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
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    label: "Weight (kg)",
                    controller: weightController,
                    enabled: true,
                  ),
                ),
                const SizedBox(
                    width: 16.0), // Add some space between the two text fields
                Expanded(
                  child: CustomTextFormField(
                    label: "Height (cm)",
                    controller: heightController,
                    enabled: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
