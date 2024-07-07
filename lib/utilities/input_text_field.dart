import 'package:flutter/material.dart';

typedef MyCustomValidatorCallback = String? Function(String? arg);

class MyTextFormInputField extends StatelessWidget {
  const MyTextFormInputField({
    Key? key,
    required this.textHint,
    required this.keyboardType,
    required this.obscureText,
    required this.validatorCallback,
    this.controller,
    this.imagePath,
    this.prefixIcon = false,
    this.isEnabled = true,
    this.bgColor = Colors.grey,
  }) : super(key: key);

  final TextInputType keyboardType;
  final String textHint;
  final bool obscureText;
  final bool prefixIcon;
  final String? imagePath;
  final bool isEnabled;
  final Color bgColor;
  final MyCustomValidatorCallback validatorCallback;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    controller?.addListener(() {
      if (controller!.text.isNotEmpty &&
          controller!.selection.extentOffset > 0) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textAlign: TextAlign.left,
      style: const TextStyle(color: Colors.black),
      minLines: 1,
      maxLines: 10,
      textInputAction: TextInputAction.newline,
      scrollController: _scrollController,
      decoration: InputDecoration(
        filled: true,
        hintText: textHint,
        fillColor: bgColor,
        prefixIcon: prefixIcon && imagePath != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Image.asset(
                  imagePath!,
                  repeat: ImageRepeat.noRepeat,
                  height: 24,
                  width: 24,
                ),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      validator: validatorCallback,
    );
  }
}
