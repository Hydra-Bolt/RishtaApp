import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:supabase_auth/components/my_button.dart';
import 'package:supabase_auth/components/my_drop_down.dart';
import 'package:supabase_auth/main.dart';
import 'package:supabase_auth/utilities/buttons.dart';
import 'package:supabase_auth/utilities/colors.dart';

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
  String? _selectedReason;
  List<String> reportReasons = [
    "Invalid Info",
    "Explicit Content",
    "Hate Speech",
    "Spam",
    "Other"
  ];
  String? _reportDetails;

  @override
  void initState() {
    super.initState();
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
                    images: const [
                      AssetImage('assets/images/muneeb1.png'),
                      AssetImage('assets/images/muneeb2.png'),
                      AssetImage('assets/images/muneeb3.png')
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
                          _reportDialogue(context);
                        } else if (value == 2) {
                          _blockDialogue(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<dynamic> _blockDialogue(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.grey[800],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Block",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Are you sure you want to block ${widget.rishta['name']}?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CustomButtons.closeButton(
                        () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 10),
                      CustomButtons.checkButton(
                        () {
                          supabase.from('blocked').insert({
                            'blocker': supabase.auth.currentUser!.id,
                            'blocked': widget.rishta['uid'],
                          }).then((value) => Navigator.of(context).pop());
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> _reportDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.grey[800],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  items: reportReasons,
                  onChanged: (value) => {
                    setState(() {
                      _selectedReason = value;
                    })
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  minLines: 4,
                  maxLines: null,
                  cursorColor: MainColors.mainThemeColor,
                  decoration: InputDecoration(
                    hintText: "Add details of the report...",
                    hintStyle: const TextStyle(color: Colors.white30),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _reportDetails = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: MyCustomButton(
                    onTap: () {
                      _reportUser(context);
                    },
                    text: "Submit Report",
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void _reportUser(BuildContext dialogContext) async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        const SnackBar(content: Text('Please select a reason for the report')),
      );
      return;
    }
    var uid = supabase.auth.currentUser!.id;
    print(widget.rishta);
    try {
      await supabase.from('reports').insert({
        'report_by': uid,
        'reported_user': widget.rishta['uid'],
        'reason': _selectedReason,
        'detail': _reportDetails
      });
    } on Exception catch (e) {
      print(e);
    }

    Navigator.of(dialogContext).pop();
  }
}
