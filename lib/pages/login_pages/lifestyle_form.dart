import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_auth/components/my_drop_down.dart';
import 'package:supabase_auth/components/my_form_field.dart';
import 'package:supabase_auth/components/my_scaffold.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class LifeStyleForm extends StatefulWidget {
  const LifeStyleForm({super.key});
  @override
  State<LifeStyleForm> createState() => _LifeStyleFormState();
}

class _LifeStyleFormState extends State<LifeStyleForm> {
  // Controllers for other form fields
  final TextEditingController _castController = TextEditingController();
  final PageController _pageController = PageController(initialPage: 0);
  final List<String> _selectedInterests = [];

  // State for dropdown values
  String? _selectedJobSector;
  String? _selectedReligion;
  String? _selectedEduLevel;
  String? _selectedPersonalityType;
  String _smoking = 'Never';
  double annualIncome = 10000;
  bool isLastPage = false;
  final List<String> jobSectors = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Manufacturing',
    'Retail',
    'Other',
  ];
  final List<String> interests = [
    "Sports",
    "Music",
    "Fitness",
    "Crafts",
    "Movies",
    "Games",
    "Reading",
    "Traveling",
    "Cooking",
    "Technology",
    "Science",
    "Photography",
    "Writing",
    "Art",
    "Programming",
    "Design",
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

  List<String> religions = [
    'Christianity',
    'Islam',
    'Sikhism',
    'Atheism',
    'Agnosticism',
  ];

  Map<String, String> eduLevelsMap = {
    'Intermediate': 'Intermediate',
    'Some Bachelor\'s Degree': 'Bachelor',
    'Some Master\'s Degree': 'Master',
    'Some Doctorate': 'Doctorate',
  };

  final Set<String> _selectedHobbies = Set<String>();

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _castController.dispose();
    super.dispose();
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
      if (_selectedHobbies.contains(hobby)) {
        _selectedHobbies.remove(hobby);
      } else {
        if (_selectedHobbies.length < 5) {
          _selectedHobbies.add(hobby);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('You can select up to 5 hobbies only.')),
          );
        }
      }
    });
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _submitPersonal() {
    // Handle the submission of personal details
    if (_selectedEduLevel == null ||
        _castController.text.isEmpty ||
        _selectedReligion == null ||
        _selectedJobSector == null ||
        _selectedPersonalityType == null) {
      throw Exception('Please fill in all the required fields.');
    }
  }

  void _submitHobbies() {
    if (_selectedHobbies.length < 1) {
      throw Exception('Please select at least one hobby.');
    }
  }

  void _submitInterests() {
    if (_selectedInterests.length < 1) {
      throw Exception('Please select at least one interest.');
    }
  }

  void _submit() async {
    // Handle the submission of personal details
    try {
      _submitPersonal();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      _pageController.jumpToPage(0);
      return;
    }

    // Handle the submission of selected hobbies
    try {
      _submitHobbies();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      _pageController.jumpToPage(1);
      return;
    }

    // Handle the submission of selected interests
    try {
      _submitInterests();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      _pageController.jumpToPage(2);
      return;
    }
    final List<Map<String, dynamic>> response =
        await supabase.from("lifestyle").insert({
      "job_sector": _selectedJobSector,
      "personality_type": _selectedPersonalityType,
      "annual_income": (annualIncome).toInt(),
      "hobbies": _selectedHobbies.toString(),
      "interests": _selectedInterests.toString(),
      "smoking": _smoking,
      "education": _selectedEduLevel,
      "cast": _castController.text,
      "religion": _selectedReligion
    }).select();

    final id = (response[0]['lid']);
    await supabase
        .from("users")
        .update({"lid": id}).eq("uid", supabase.auth.currentUser!.id);
    // Navigate to the next page
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Done!")));

    Navigator.of(context).pushReplacementNamed('/preference');
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text(
          "Tell us a little about yourself",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) => {
              setState(() {
                isLastPage = value == 2;
              })
            },
            controller: _pageController,
            children: [_personalLifeStyle(), _hobbies(), _interests()],
          ),
          Align(
            alignment: const Alignment(0, 1.12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.mainColor.withOpacity(0.8),
              ),
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
                right: MediaQuery.of(context).size.width * 0.1,
                top: 19,
                bottom: MediaQuery.of(context).size.height * 0.1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        _pageController.previousPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                      },
                      child: Icon(Icons.arrow_back_rounded)),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const WormEffect(
                      activeDotColor: AppColors.mainColor,
                      dotWidth: 10,
                      dotHeight: 10,
                    ),
                  ),
                  isLastPage
                      ? GestureDetector(
                          onTap: () {
                            _submit();
                          },
                          child: Icon(Icons.check))
                      : GestureDetector(
                          onTap: () {
                            _pageController.nextPage(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                          },
                          child: Icon(Icons.arrow_forward_rounded)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _interests() {
    return Column(
      children: [
        const Text(
          "Any Interests?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              childAspectRatio: 1.7,
              children: interests.map((interest) {
                bool isSelected = _selectedInterests.contains(interest);
                return Card(
                  elevation: isSelected ? 15.0 : 2.0,
                  child: InkWell(
                    onTap: () => _toggleInterest(interest),
                    splashColor: AppColors.mainColor.withOpacity(0.5),
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage(
                              // 'assets/images/${interest.toLowerCase()}.jpg'),
                              'assets/images/app_background.png'),
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
                                  interest,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8.0),
                                Icon(
                                  isSelected
                                      ? Icons.remove_circle
                                      : Icons.add_circle,
                                  color: isSelected ? Colors.red : Colors.green,
                                  size: 22.0,
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
        ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.1),
      ],
    );
  }

  Padding _hobbies() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const Text(
            "What are your Hobbies?",
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1.6,
              children: hobbies.map((hobby) {
                bool isSelected = _selectedHobbies.contains(hobby);
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),

                  elevation: isSelected ? 15.0 : 2.0,
                  // margin: EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () => _toggleHobby(hobby),
                    splashColor: AppColors.mainColor.withOpacity(0.5),
                    child: Ink(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/hobbies/${hobby.toLowerCase()}.jpg'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12.0),
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
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8.0),
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
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  SingleChildScrollView _personalLifeStyle() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomDropdownFormField(
              label: "Job Sector",
              value: _selectedJobSector,
              items: jobSectors,
              onChanged: (value) {
                setState(() {
                  _selectedJobSector = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: CustomDropdownFormField(
                        label: "Religion",
                        value: _selectedReligion,
                        items: religions,
                        onChanged: (value) {
                          setState(() {
                            _selectedReligion = value;
                          });
                        })),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    label: "Cast",
                    controller: _castController,
                    enabled: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomDropdownFormField(
                label: "Highest Qualification",
                value: _selectedEduLevel,
                items: eduLevelsMap.keys.toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEduLevel = eduLevelsMap[value] ?? value;
                  });
                }),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Do you smoke?",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRadioButton('Never'),
                      _buildRadioButton('Rarely'),
                      _buildRadioButton('Sometimes'),
                      _buildRadioButton('Often'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomDropdownFormField(
                label: 'Personality Type',
                value: _selectedPersonalityType,
                items: personalityTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedPersonalityType = value;
                  });
                }),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: "Don't know your personality type? ",
                style: const TextStyle(color: Colors.black, fontSize: 12),
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
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(String value) {
    return Transform.scale(
      alignment: Alignment.centerLeft,
      scale: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: _smoking,
            onChanged: (String? newValue) {
              setState(() {
                _smoking = newValue!;
              });
            },
            activeColor: AppColors.mainColor, // Use the custom color
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 10.0,
              color: _smoking == value ? AppColors.mainColor : Colors.black,
              fontWeight:
                  _smoking == value ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
