// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/admin_screens/admin_registration_form.dart';
import 'package:wash_mesh/admin_screens/disable_user.dart';
import 'package:wash_mesh/models/admin_models/admin_model.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';
import 'package:wash_mesh/widgets/custom_navigation_bar_admin.dart';
import 'package:wash_mesh/widgets/custom_text_field.dart';

import '../admin_map_integration/admin_global_variables/admin_global_variables.dart';
import '../admin_map_integration/admin_notifications/admin_push_notifications.dart';
import '../providers/admin_provider/admin_auth_provider.dart';
import 'admin_forget_password.dart';

class AdminLoginForm extends StatefulWidget {
  const AdminLoginForm({Key? key}) : super(key: key);

  @override
  State<AdminLoginForm> createState() => _AdminLoginFormState();
}

class _AdminLoginFormState extends State<AdminLoginForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;

  onSubmit() async {
    setState(() {
      isLoading == true;
    });
    final adminData = Provider.of<AdminAuthProvider>(context, listen: false);
    try {
      final isValid = formKey.currentState!.validate();
      if (isValid) {
        await adminData.loginAdmin(
          context,
          input: phoneNo.text.trim(),
          password: password.text.trim(),
          fcmToken: '',
        );

        bool check = await login();

        AdminPushNotifications pushNotifications = AdminPushNotifications();
        await pushNotifications.generateToken();

        dynamic fcmToken;

        final ref = FirebaseDatabase.instance.ref();
        final snapshot = await ref
            .child('vendor')
            .child(firebaseAuth.currentUser!.uid)
            .child('fcmToken')
            .get();
        if (snapshot.exists) {
          fcmToken = snapshot.value;
          print(fcmToken);
        } else {
          print('No data available.');
        }

        final result = await adminData.loginAdmin(
          context,
          input: phoneNo.text.trim(),
          password: password.text.trim(),
          fcmToken: fcmToken,
        );

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('$result'),
        //   ),
        // );
        print("5555 $result");
        if (result["message"] == 'Service Provider Logged in Successfully!' &&
            result["status"] == "1" &&
            check == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("loginPhone", phoneNo.text);
          prefs.setString("loginPassword", password.text);
          prefs.setBool('adminLoggedIn', true);
          Fluttertoast.showToast(
              msg: 'Service Provider Logged in Successfully!');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const CustomNavigationBarAdmin(),
            ),
            (route) => false,
          );
          setState(() {});
          isLoading == false;
        } else if (result["message"] ==
                'Service Provider Logged in Successfully!' &&
            result["status"] == "2") {
          setState(() {});
          isLoading == false;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisableUser(),
              ));
        } else {
          Fluttertoast.showToast(msg: 'Login Failed, Check your credentials.');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AdminLoginForm(),
            ),
          );
        }
      }
    } catch (e) {
      return e.toString();
    }
    setState(() {
      isLoading == false;
    });
  }

  login() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString("email");
      print(email);

      final UserCredential admin =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email.toString().trim(),
        password: password.text.trim(),
      );
      print("444 ${admin.user!.uid}");
// await admin.user!.updatePassword(newPassword);
      if (admin.user != null) {
        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('vendor');
        userRef.child(firebaseAuth.currentUser!.uid).once().then((adminKey) {
          final snap = adminKey.snapshot;
          if (snap.value != null) {
            Fluttertoast.showToast(msg: 'Login Successfully');
          } else {
            Fluttertoast.showToast(msg: 'No record exist with this email.');
            setState(() {
              isLoading == true;
            });
          }
        });

        return true;
      } else {
        Fluttertoast.showToast(msg: 'Login Failed, Check your credentials.');
        setState(() {
          isLoading == false;
        });
        return false;
      }
    } catch (e) {
      print(e);
      //  Fluttertoast.showToast(msg: e.toString());
      setState(() {
        isLoading == false;
      });
      return false;
    }
  }

  checkPassword() async {
    SharedPreferences p = await SharedPreferences.getInstance();

    if (p.getString("loginPhone") != null &&
        p.getString("loginPassword") != null) {
      phoneNo.text = p.getString("loginPhone")!;
      password.text = p.getString("loginPassword")!;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    checkPassword();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 15.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CustomLogo(),
                SizedBox(height: 15.h),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 25.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Image.asset('assets/images/pngegg.png'),
                SizedBox(height: 30.h),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),
                      CustomTextField(
                        hint: 'phoneNo'.tr(),
                        keyboardType: TextInputType.phone,
                        controller: phoneNo,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'password'.tr(),
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please enter your password with at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      //   SizedBox(height: 0.h),
                    ],
                  ),
                ),
                // SizedBox(height: 0.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                AdminForgetPassword(vendor: Vendor()),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          width: 140.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                              //  color: Colors.green,
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Center(
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100.h),
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        onTextPress: onSubmit,
                        buttonText: 'LOG IN',
                      ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 05, bottom: 5),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminRegisterScreen(),
                          ));
                    },
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontFamily: "poppinsTextTheme",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
