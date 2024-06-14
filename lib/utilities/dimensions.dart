import 'package:flutter/material.dart';

class Dimensions {
  final BuildContext context;
  final double _screenWidth;
  final double _screenHeight;

  Dimensions(this.context)
      : _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

  double width(double percent) {
    return _screenWidth * percent / 100;
  }
  double height(double percent) {
    return _screenHeight * percent / 100;
  }
  double screenWidth() {
    return _screenWidth;
  }
  double screenHeight() {
    return _screenHeight;
  }
}
