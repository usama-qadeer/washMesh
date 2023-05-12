import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/models/user_models/user_model.dart';
import 'package:wash_mesh/user_map_integration/user_global_variables/user_global_variables.dart';
import 'package:wash_mesh/user_screens/user_login_form.dart';
import 'package:wash_mesh/widgets/custom_text_field.dart';

import '../providers/user_provider/user_auth_provider.dart';
import '../widgets/custom_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_logo.dart';

class UserRecreatePassword extends StatefulWidget {
  String? input;
  UserModel? userModel;
  UserRecreatePassword({Key? key, this.userModel, required this.input})
      : super(key: key);

  @override
  State<UserRecreatePassword> createState() => _UserRecreatePasswordState();
}

class _UserRecreatePasswordState extends State<UserRecreatePassword> {
  TextEditingController newPasswordC = TextEditingController();
  final formKey = GlobalKey<FormFieldState>();
  String newPassword = "";
  onPassChange() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rr = await prefs.getString("userEmail");
    // print(rr);
    // print(newPasswordC.text);

    final adminPassword = Provider.of<UserAuthProvider>(context, listen: false);
    try {
      final result = await adminPassword.recreateUserPassword(
        context,
        input: widget.input,
        // input: userModel!.email,
        newPassword: newPasswordC.text,
      );
      newPasswordC.clear();
      // print("kkkkkk");
      // print(widget.input);
      // ignore: use_build_context_synchronously
      Fluttertoast.showToast(msg: result);
    } catch (e) {
      print("ddddd");
      print(e.toString());
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // final userData = Provider.of<UserAuthProvider>(context, listen: false);
    //   print(userData);
    return CustomBackground(
      op: 0.1,
      ch: Padding(
        padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 33.h),
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
                    if (value!.isEmpty || value.length < 6) {
                      return 'Please enter your password with at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              // Expanded(child: Container()),
              SizedBox(height: 200.h),
              InkWell(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserLoginForm(),
                          ))
                      .then((value) => ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                              content: Text("Password Reset Successfully"))));
                },
                child: CustomButton(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
