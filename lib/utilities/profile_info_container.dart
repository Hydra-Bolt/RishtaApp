import 'package:flutter/material.dart';
import 'package:supabase_auth/utilities/dimensions.dart';
import 'package:supabase_auth/utilities/colors.dart';
import 'package:supabase_auth/utilities/profile_page_richtext.dart';

class ProfileInfoContainer extends StatelessWidget {
  final Map<String, dynamic> profileInfo;
  const ProfileInfoContainer({super.key, required this.profileInfo});

  @override
  Widget build(BuildContext context) {
    final Dimensions dimensions = Dimensions(context);

    // final double topMargin = dimensions.height(40);
    final double containerWidth = dimensions.width(85);
    final double containerHeight = dimensions.height(110);
    final double borderRadius = dimensions.width(3.54);
    const Color shadowColor = MainColors.shadowColor;

    return Container(
      // margin: EdgeInsets.only(top: topMargin),
      width: containerWidth,
      height: containerHeight,
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      decoration: BoxDecoration(
        color: shadowColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ProfileRichText(profileData: profileInfo),
    );
  }
}
