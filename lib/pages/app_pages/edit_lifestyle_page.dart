import 'package:flutter/material.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/text_form_fields.dart';
import 'package:supabase_auth/utilities/colors.dart';

class EditLifestylePage extends StatefulWidget {
  // final String initialName;
  // final String initialEmail;
  final Map<String, dynamic> initialData;

  const EditLifestylePage({
    super.key,
    required this.initialData,
    // required this.initialName,
    // required this.initialEmail,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditLifestylePage> {
  double annualIncome = 10000;
  Map<String, dynamic>? userInfo;
  Map<String, dynamic>? lifeStyleInfo;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String? selectedGender;
  String? selectedJobSector;
  String? selectedEducationLevel;
  String? selectedReligion;
  String? selectedMaritalStatus;
  String? selectedPersonalityType;
  String? selectedSmokerOption;
  String? selectedCity;
  String? day;
  String? month;
  String? year;
  final Map<String, String> education = {
    'Intermediate': 'Intermediate',
    'Some Bachelor\'s Degree': 'Bachelors',
    'Some Master\'s Degree': 'Masters',
    'Some Doctorate': 'Doctorate'
  };

  @override
  void initState() {
    super.initState();
    _fetchUserData(widget.initialData);
  }

  void saveInfo() async {
    final String financial_strength;

    if ((annualIncome).toInt() < 100000) {
      financial_strength = 'Low';
    } else if ((annualIncome).toInt() < 500000) {
      financial_strength = 'Normal';
    } else {
      financial_strength = 'Strong';
    }
    var uid = supabase.auth.currentUser!.id;
    try {
      await supabase.from('Users').update({
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'gender': selectedGender,
        'city': selectedCity,
        'marital_status': selectedMaritalStatus,
        'weight': int.parse(weightController.text.trim()),
        'height': int.parse(heightController.text.trim()),
        'dob': '$year-$month-$day',
      }).eq('uid', uid);

      await supabase.from('Lifestyle').update({
        'job_sector': selectedJobSector,
        'education': education[selectedEducationLevel],
        'religion': selectedReligion,
        'financial_strength': financial_strength,
        'personality_type': selectedPersonalityType,
        'smoking': selectedSmokerOption,
      }).eq('uid', uid);

      Navigator.pop(context);
    } on Exception catch (e) {
      print(e);
    }
  }

  void _fetchUserData(Map<String, dynamic> initialData) {
    setState(() {
      userInfo = {
        'first_name': initialData['first_name'],
        'last_name': initialData['last_name'],
        'weight': initialData['weight'],
        'height': initialData['height'],
        'gender': initialData['gender'],
        'marital_status': initialData['marital_status'],
        'city': initialData['city'],
        'dob': initialData['dob'],
      };

      lifeStyleInfo = {
        'job_sector': initialData['job_sector'],
        'education': initialData['education'],
        'religion': initialData['religion'],
        'personality_type': initialData['personality_type'],
        'smoking': initialData['smoking'],
      };

      firstNameController.text = userInfo!['first_name'];
      lastNameController.text = userInfo!['last_name'];
      weightController.text = userInfo!['weight'].toString();
      heightController.text = userInfo!['height'].toString();
      selectedGender = userInfo!['gender'];
      selectedJobSector = lifeStyleInfo!['job_sector'];
      selectedEducationLevel = lifeStyleInfo!['education'];
      selectedReligion = lifeStyleInfo!['religion'];
      selectedMaritalStatus = userInfo!['marital_status'];
      selectedPersonalityType = lifeStyleInfo!['personality_type'];
      selectedSmokerOption = lifeStyleInfo!['smoking'];
      selectedCity = userInfo!['city'];

      List date = userInfo!['dob'].split('-');
      day = int.tryParse(date[2]).toString();
      month = int.tryParse(date[1]).toString();
      year = int.tryParse(date[0]).toString();
    });
  }

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
      'Other'
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
      'ENTJ'
    ];
    final List<String> religions = [
      'Christianity',
      'Islam',
      'Sikhism',
      'Atheism',
      'Agnosticism'
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
      'Okara'
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
      'Some Doctorate': 'Doctorate'
    };

    String? getEducationKeyByValue(String? value) {
      try {
        return education.entries
            .firstWhere((entry) => entry.value == value)
            .key;
      } catch (e) {
        return null;
      }
    }

    if (userInfo == null || lifeStyleInfo == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  const Center(
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledTextField(
                            'First Name', 'first name', firstNameController),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildLabeledTextField(
                            'Last Name', 'last name', lastNameController),
                      ),
                    ],
                  ),
                  _buildDateRow(userInfo!['dob']),
                  _buildMeasurementRow(
                    'Weight',
                    'Kgs',
                    'Height',
                    'cm',
                    weightController,
                    heightController,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdownField(
                              'Gender', genders, selectedGender,
                              (String? value) {
                        setState(() {
                          selectedGender = value;
                        });
                      })),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdownField(
                              'Personality Type',
                              personalityTypes,
                              selectedPersonalityType, (value) {
                        setState(() {
                          selectedPersonalityType = value;
                        });
                      })),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdownField(
                              'City', citiesInPakistan, selectedCity, (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      })),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                            'Religion', religions, selectedReligion, (value) {
                          setState(() {
                            selectedReligion = value;
                          });
                        }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                            'Education',
                            education.keys.toList(),
                            getEducationKeyByValue(selectedEducationLevel),
                            (value) {
                          setState(() {
                            selectedEducationLevel = value;
                          });
                        }),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField(
                            'Job Sector', jobSectors, selectedJobSector,
                            (value) {
                          setState(() {
                            selectedJobSector = value;
                          });
                        }),
                      ),
                    ],
                  ),
                  _buildIncomeSlider(),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdownField(
                              'Smoker', smokerOptions, selectedSmokerOption,
                              (value) {
                        setState(() {
                          selectedSmokerOption = value;
                        });
                      })),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdownField('Marital Status',
                            maritalStatus, selectedMaritalStatus, (value) {
                          setState(() {
                            selectedMaritalStatus = value;
                          });
                        }),
                      ),
                    ],
                  ),
                  _buildButtonRow(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        CustomTextFormField(
          hint: hint,
          controller: controller,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items,
      String? fieldValue, Function(String?)? onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField(
          value: fieldValue,
          items: items.map((item) {
            return DropdownMenuItem(
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
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDateRow(String dob) {
    return Row(
      children: [
        Expanded(
          child: _buildDropdownField('Day', _buildDayItems(), day, (value) {
            setState(() {
              day = value;
            });
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child:
              _buildDropdownField('Month', _buildMonthItems(), month, (value) {
            setState(() {
              month = value;
            });
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildDropdownField('Year', _buildYearItems(), year, (value) {
            setState(() {
              year = value;
            });
          }),
        ),
      ],
    );
  }

  Widget _buildIncomeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Annual Income',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              ': Rs ${annualIncome.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
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
      ],
    );
  }

  Widget _buildMeasurementRow(
      String label1,
      String unit1,
      String label2,
      String unit2,
      TextEditingController controller1,
      TextEditingController controller2) {
    return Row(
      children: [
        Expanded(
          child: _buildMeasurementField(label1, unit1, controller1),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildMeasurementField(label2, unit2, controller2),
        ),
      ],
    );
  }

  Widget _buildMeasurementField(
      String label, String unit, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        CustomTextFormField(
          controller: controller,
          hint: '',
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(232, 255, 179, 174)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(199, 188, 213, 161)),
            ),
            onPressed: () => saveInfo(),
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }

  List<String> _buildDayItems() {
    return List<String>.generate(31, (index) => (index + 1).toString());
  }

  List<String> _buildMonthItems() {
    return List<String>.generate(12, (index) => (index + 1).toString());
  }

  List<String> _buildYearItems() {
    return List<String>.generate(
        DateTime.now().year - 1960 + 1, (index) => (1960 + index).toString());
  }
}
