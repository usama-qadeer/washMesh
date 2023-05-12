import 'package:flutter/material.dart';
import 'package:wash_mesh/widgets/custom_colors.dart';

class CustomBackground extends StatelessWidget {
  final Widget ch;
  final double op;

  const CustomBackground({
    super.key,
    required this.ch,
    required this.op,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: CustomColor().mainTheme,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                opacity: op,
                image: const AssetImage(
                  'assets/images/app_icon.png',
                ),
              ),
            ),
            child: ch,
          ),
        ),
      ),
    );
  }
}
