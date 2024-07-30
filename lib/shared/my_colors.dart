import 'package:flutter/material.dart';

class MyColors {
  // Background gradient
  static const List<Color> backgroundGradient = [
    Color.fromRGBO(10, 17, 40, 1),
    Color.fromRGBO(0, 0, 0, 1),
  ];

  // Gradient for text
  static const List<Color> textGradient = [
    Color.fromRGBO(0, 123, 255, 1),
    Color.fromRGBO(255, 182, 193, 1),
  ];

  // Method to get background gradient
  static LinearGradient getBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: backgroundGradient,
    );
  }

  // Method to get text gradient
  static LinearGradient getTextGradient() {
    return LinearGradient(
      colors: textGradient,
    );
  }

  static const Color primaryColor = Color.fromRGBO(0, 123, 255, 1);
  static const Color secondaryColor = Color.fromRGBO(255, 182, 193, 1);
  static const Color backgroundColor = Color.fromRGBO(1, 1, 3, 1);
}
