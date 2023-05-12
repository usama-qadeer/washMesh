import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/washmesh-main.png',
      fit: BoxFit.cover,
    );
  }
}
