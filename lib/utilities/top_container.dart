import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:supabase_auth/components/my_drop_down.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/buttons.dart';

class TopContainer extends StatefulWidget {
  final double height;
  final double width;
  final double bottomMargin;
  final Color backgroundColor;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final Color shadowColor;
  final dynamic rishta;

  const TopContainer({
    super.key,
    required this.rishta,
    required this.height,
    required this.width,
    required this.bottomMargin,
    required this.backgroundColor,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.shadowColor,
  });

  @override
  State<TopContainer> createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  bool isLoading = false;
  List? photos;
  String? _selectedReason;
  Map<String, String> reportReasons = {
    "Inavlid Info": "inv_info",
    "Explicit Content": "exp_content",
    "Hate Speech": "hate_speech",
    "Spam": "spam",
    "Other": "other",
  };
  String? _reportDetails;
  @override
  void initState() {
    super.initState();
    // _getPhotos();
  }

  void _getPhotos() async {
    var rishtaUid = widget.rishta['uid'];

    var res =
        await supabase.from("user_photo").select('*').eq('uid', rishtaUid);
    setState(() {
      isLoading = false;
      photos = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      margin: EdgeInsets.only(bottom: widget.bottomMargin),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border:
            Border.all(color: widget.borderColor, width: widget.borderWidth),
        boxShadow: [
          BoxShadow(
            color: widget.shadowColor.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isLoading
          ? const CircularProgressIndicator()
          : ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Stack(
                children: [
                  AnotherCarousel(
                    images: photos == null
                        ? [
                            widget.rishta['gender'] == 'Male'
                                ? const AssetImage('assets/images/cutie.jpg')
                                : const AssetImage('assets/images/female.jpg'),
                            const AssetImage('assets/images/not_found.png'),
                          ]
                        : [
                            const AssetImage('assets/images/muneeb1.png'),
                            const AssetImage('assets/images/muneeb2.png'),
                            const AssetImage('assets/images/muneeb3.png')
                          ],
                    dotSize: 3,
                    indicatorBgPadding: 4,
                    autoplayDuration: const Duration(seconds: 5),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: CustomButtons.popupMenuButton(
                      onSelected: (value) {
                        if (value == 1) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 100),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey[800],
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 20),
                                        child: Scaffold(
                                          backgroundColor: Colors.transparent,
                                          body: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Report",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                CustomDropdownFormField(
                                                    label: "Reason",
                                                    value: _selectedReason,
                                                    items: reportReasons.keys
                                                        .toList(),
                                                    onChanged: (value) => {
                                                          setState(() {
                                                            _selectedReason =
                                                                reportReasons[
                                                                        value] ??
                                                                    value;
                                                          })
                                                        }),
                                                const SizedBox(height: 10),
                                                Expanded(
                                                  child: TextFormField(
                                                    maxLines: null,
                                                    decoration:
                                                        const InputDecoration(
                                                            hintText:
                                                                "Add details of the report..."),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _reportDetails = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    print(_reportDetails);
                                                    print(_selectedReason);
                                                    // your report submission logic here
                                                  },
                                                  child: const Text(
                                                      'Submit Report'),
                                                ),
                                              ]),
                                        )));
                              });
                        } else if (value == 2) {
                          print('Dont show again');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
