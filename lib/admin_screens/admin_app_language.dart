import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_navigation_bar_admin.dart';

import '../widgets/custom_logo.dart';

class AdminAppLanguage extends StatefulWidget {
  const AdminAppLanguage({Key? key}) : super(key: key);

  @override
  State<AdminAppLanguage> createState() => _AdminAppLanguageState();
}

class _AdminAppLanguageState extends State<AdminAppLanguage> {
  // bool? isEnglish = false;
  // bool? isUrdu = false;

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      ch: Padding(
        padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
        child: Column(
          children: [
            const CustomLogo(),
            SizedBox(height: 20.h),
            Container(
              alignment: Alignment.center,
              child: Text(
                'language'.tr(),
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ),
            SizedBox(height: 50.h),
            InkWell(
              onTap: () {
                setState(() {
                  context.setLocale(const Locale('en', 'US'));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomNavigationBarAdmin(),
                    ),
                    (route) => false,
                  );
                  Fluttertoast.showToast(msg: 'Language set to english');
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Checkbox(
                  //   value: isEnglish,
                  //   onChanged: (bool? value) {
                  //     setState(() {
                  //       isEnglish = value;
                  //     });
                  //   },
                  // ),
                  // SizedBox(width: 10.w),
                  Text(
                    'Select English',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                width: 270.w,
                child: Divider(height: 10.h, thickness: 2),
              ),
            ),
            SizedBox(height: 15.h),
            InkWell(
              onTap: () {
                setState(() {
                  context.setLocale(const Locale('ur', 'PAK'));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomNavigationBarAdmin(),
                    ),
                    (route) => false,
                  );
                  Fluttertoast.showToast(msg: 'زبان اردو پر سیٹ کر دی گئی۔');
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Checkbox(
                  //   value: isUrdu,
                  //   onChanged: (bool? value) {
                  //     setState(() {
                  //       isUrdu = value;
                  //     });
                  //   },
                  // ),
                  // SizedBox(width: 26.w),
                  Text(
                    'Select Urdu',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      op: 0.1,
    );
  }
}
