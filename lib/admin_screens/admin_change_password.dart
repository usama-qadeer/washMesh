// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

import '../providers/admin_provider/admin_auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_logo.dart';
import '../widgets/custom_text_field.dart';

class AdminChangePassword extends StatefulWidget {
  const AdminChangePassword({Key? key}) : super(key: key);

  @override
  State<AdminChangePassword> createState() => _AdminChangePasswordState();
}

class _AdminChangePasswordState extends State<AdminChangePassword> {
  TextEditingController newPassword = TextEditingController();
  final formKey = GlobalKey<FormFieldState>();

  onPassChange() async {
    final adminPassword =
        Provider.of<AdminAuthProvider>(context, listen: false);
    try {
      final result = await adminPassword.updateAdminPassword(
        newPassword: newPassword.text,
      );
      newPassword.clear();
      // Password Upadate Successfully!
      Fluttertoast.showToast(msg: result);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: Padding(
        padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
        child: Column(
          children: [
            const CustomLogo(),
            SizedBox(height: 15.h),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ),
            SizedBox(height: 120.h),
            Form(
              key: formKey,
              child: CustomTextField(
                hint: 'newPassword'.tr(),
                controller: newPassword,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Please enter your password with at least 5 characters';
                  }
                  return null;
                },
              ),
            ),
            Expanded(child: Container()),
            CustomButton(
              onTextPress: onPassChange,
              buttonText: 'Confirm',
            ),
          ],
        ),
      ),
    );
  }
}
