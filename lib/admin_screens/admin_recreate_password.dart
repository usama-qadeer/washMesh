// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/admin_models/admin_model.dart';
import '../providers/admin_provider/admin_auth_provider.dart';
import '../widgets/custom_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_logo.dart';
import '../widgets/custom_text_field.dart';

class AdminRecreatePassword extends StatefulWidget {
  String? input;
  AdminModel? adminModel;
  AdminRecreatePassword({Key? key, this.adminModel, required this.input})
      : super(key: key);

  @override
  State<AdminRecreatePassword> createState() => _AdminRecreatePasswordState();
}

class _AdminRecreatePasswordState extends State<AdminRecreatePassword> {
  TextEditingController newPasswordC = TextEditingController();
  String newPassword = "";

  final formKey = GlobalKey<FormFieldState>();

  onPassChange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rr = await prefs.getString("loginPhone");
    final adminPassword =
        Provider.of<AdminAuthProvider>(context, listen: false);
    try {
      final result = await adminPassword.recreateAdminPassword(
        context,
        // input: AdminModel().data!.vendor!.email,
        // input: AdminModel().data!.vendor!.phone,
        input: widget.input,
        newPassword: newPasswordC.text,
      );
      // print("ffffff**********************************f");
      newPasswordC.clear();
      Fluttertoast.showToast(msg: result);
    } catch (e) {
      //  print("fffffff");

      return e.toString();
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
                'Re-Create Password',
                style: TextStyle(
                  fontSize: 30.sp,
                ),
              ),
            ),
            SizedBox(height: 100.h),
            Form(
              key: formKey,
              child: CustomTextField(
                hint: 'Enter your new Password',
                controller: newPasswordC,
                validator: (value) {
                  if (value!.isEmpty && value.length < 6) {
                    return 'Please enter your password with at least 6 characters';
                  }
                  return null;
                },
              ),
            ),
            Expanded(child: Container()),
            CustomButton(
              onTextPress: () {
                if (newPasswordC.text.length >= 6) {
                  onPassChange();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Please enter your password with at least 6 characters")));
                }
              },
              buttonText: 'Okay',
            ),
          ],
        ),
      ),
    );
  }
}
