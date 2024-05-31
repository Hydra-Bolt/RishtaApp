import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final bool isObscure;

  const CustomTextFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.enabled,
    this.isObscure = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  Color mainColor = const Color(0xFFFA2A55);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(color: mainColor, fontSize: 12.0),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(color: mainColor, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
      ),
      controller: widget.controller,
      style: TextStyle(color: Colors.black87, fontSize: 12.0),
      cursorColor: mainColor,
      cursorWidth: 1.2,
      enabled: widget.enabled,
      obscureText: widget.isObscure,
    );
  }
}
