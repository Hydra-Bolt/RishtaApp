import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const CustomTextFormField(
      {super.key,
      required this.label,
      required this.controller,
      required this.enabled});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  Color mainColor = const Color(0xFFFA2A55);
  // Hardcoded main color
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white10,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: mainColor),
          ),
        ),
        controller: widget.controller,
        style: TextStyle(color: Colors.grey),
        cursorColor: mainColor,
        cursorWidth: 1,
        enabled: widget.enabled);
  }
}
