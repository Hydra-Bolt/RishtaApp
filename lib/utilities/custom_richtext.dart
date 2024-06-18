import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final dynamic rishta;
  const CustomRichText({
    super.key,
    required this.rishta,
  });

  @override
  Widget build(BuildContext context) {
    print(rishta);
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: RichText(
        text: TextSpan(
          children: [
            _customTextSpan(rishta['name'] + ', '),
            _customTextSpan('${rishta['age']}'),
          ],
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  TextSpan _customTextSpan(String? text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
