import 'package:flutter/material.dart';

class CustomColor {
  final mainColor = const Color(0xff0F75BC);
  final shadowColor = const Color(0xff5239EA);
  final shadowColor2 = const Color(0xff0038FF);
  final mainTheme = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white,
      Colors.greenAccent.shade200,
    ],
  );
}
