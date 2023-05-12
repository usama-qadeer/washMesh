// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wash_mesh/admin_screens/admin_login_form.dart';
import 'package:wash_mesh/user_screens/user_login_form.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      ch: Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 12.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            const CustomLogo(),
            SizedBox(height: 50.h),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'register',
                  style: TextStyle(
                    fontSize: 25.sp,
                  ),
                ).tr(),
              ),
            ),
            SizedBox(height: 50.h),
            CustomButton(
              onTextPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserLoginForm(),
                  ),
                );
              },
              buttonText: 'customer'.tr(),
            ),
            SizedBox(height: 30.h),
            CustomButton(
              onTextPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginForm(),
                  ),
                );
              },
              buttonText: 'serviceProvider'.tr(),
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
      op: 0.1,
    );
  }
}
