import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth/components/my_form_field.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class LifeStyleForm extends StatefulWidget {
  const LifeStyleForm({super.key});
  @override
  State<LifeStyleForm> createState() => _LifeStyleFormState();
}

class _LifeStyleFormState extends State<LifeStyleForm> {
  // Controllers for other form fields
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _castController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final PageController _pageController = PageController(initialPage: 1);
  // State for dropdown values
  String? _selectedJobSector;
  String? _selectedPersonalityType;
  bool _smoking = false;
  double annualIncome = 10000;

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

  final List<String> hobbies = [
    "Reading",
    "Traveling",
    "Cooking",
    "Gaming",
    "Hiking",
    "Painting",
    "Photography",
    "Gardening"
  ];

  final Set<String> selectedHobbies = Set<String>();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    // _hobbiesController.dispose();
    // _interestsController.dispose();
    _religionController.dispose();
    _castController.dispose();
    _educationController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  void _submitPersonal() {
    print("Form submitted");

    // Implement form submission logic
    // For example, you can save the data to the database here
  }

  void _launchURL() async {
    const url = 'https://www.16personalities.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _toggleHobby(String hobby) {
    setState(() {
      if (selectedHobbies.contains(hobby)) {
        selectedHobbies.remove(hobby);
      } else {
        if (selectedHobbies.length < 5) {
          selectedHobbies.add(hobby);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('You can select up to 5 hobbies only.')),
          );
        }
      }
    });
  }

  void _hobbiesSubmit() {
    if (selectedHobbies.length < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least 1 hobby.')),
      );
    } else {
      // Handle the submission of selected hobbies
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Selected Hobbies: ${selectedHobbies.join(", ")}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text(
          "Lifestyle Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _personalLifeStyle(),
          _hobbies(),
        ],
      ),
    );
  }

  Padding _hobbies() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            "Hobbies make you more interesting.",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              children: hobbies.map((hobby) {
                bool isSelected = selectedHobbies.contains(hobby);
                return Card(
                  elevation: isSelected ? 15.0 : 2.0,
                  // margin: EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => _toggleHobby(hobby),
                    splashColor: AppColors.mainColor.withOpacity(0.5),
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/${hobby.toLowerCase()}.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  hobby,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8.0),
                                Icon(
                                  isSelected
                                      ? Icons.remove_circle
                                      : Icons.add_circle,
                                  color: isSelected ? Colors.red : Colors.green,
                                  size: 32.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: GestureDetector(
              onTap: _hobbiesSubmit,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  color: AppColors.mainColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Interests",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(
                        width: 10), // Add some space between text and icon
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView _personalLifeStyle() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Job Sector',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              value: _selectedJobSector,
              items: jobSectors.map((sector) {
                return DropdownMenuItem<String>(
                  value: sector,
                  child: Text(sector),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedJobSector = value;
                });
              },
            ),
            // const SizedBox(height: 10),
            // CustomTextFormField(
            //   label: "Hobbies",
            //   controller: _hobbiesController,
            //   enabled: true,
            // ),
            // const SizedBox(height: 10),
            // CustomTextFormField(
            //   label: "Interests",
            //   controller: _interestsController,
            //   enabled: true,
            // ),
            const SizedBox(height: 10),
            const SizedBox(height: 10),
            CustomTextFormField(
              label: "Religion",
              controller: _religionController,
              enabled: true,
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              label: "Cast",
              controller: _castController,
              enabled: true,
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              label: "Education",
              controller: _educationController,
              enabled: true,
            ),
            const SizedBox(height: 20),
            Text(
              'Annual Income: ${annualIncome.toStringAsFixed(0)}Rs+', // Display the slider value as text
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            Slider(
              activeColor: AppColors.mainColor,
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
            SwitchListTile(
              title: const Text(
                "Smoking",
                style: TextStyle(color: Colors.black),
              ),
              value: _smoking,
              onChanged: (bool value) {
                setState(() {
                  _smoking = value;
                });
              },
              activeColor: AppColors.mainColor,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Personality Type',
                labelStyle: TextStyle(fontSize: 14, color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              value: _selectedPersonalityType,
              items: personalityTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPersonalityType = value;
                });
              },
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: "Don't know your personality type? ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "Click here",
                    style: const TextStyle(
                      color: AppColors.mainColor,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = _launchURL,
                  ),
                  const TextSpan(
                    text: ' to find out.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: GestureDetector(
                onTap: _submitPersonal,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    color: AppColors.mainColor,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Hobbies",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                          width: 10), // Add some space between text and icon
                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
