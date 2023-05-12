import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckBox extends StatelessWidget {
  final String catText;
  final ValueChanged<bool?>? onCheck;
  final bool isChecked;

  const CustomCheckBox(
      {super.key,
      required this.catText,
      required this.onCheck,
      required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onCheck,
        ),
        Flexible(
          child: Text(
            catText,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
