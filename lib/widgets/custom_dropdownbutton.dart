import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownButton extends StatelessWidget {
  final String heading;
  final Color selectColor;
  final String dropDownText;
  final Color textColor;

  const CustomDropdownButton({
    super.key,
    required this.heading,
    required this.selectColor,
    required this.dropDownText,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 50.h,
      decoration: BoxDecoration(
        color: selectColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: selectColor,
            blurRadius: 12,
          ),
        ],
      ),
      child: Center(
        child: DropdownButton(
          borderRadius: BorderRadius.circular(12.r),
          alignment: Alignment.center,
          hint: Text(
            heading,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: textColor,
          ),
          items: const [
            DropdownMenuItem(
              value: 'car-wash',
              child: Text('Car Wash'),
            ),
          ],
          onChanged: (value) {},
        ),
      ),
    );
  }
}
