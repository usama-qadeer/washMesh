// // ignore_for_file: use_build_context_synchronously

// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wash_mesh/user_screens/user_forget_password.dart';
// import 'package:wash_mesh/user_screens/user_home_screen.dart';
// import 'package:wash_mesh/user_screens/user_registration_form.dart';
// import 'package:wash_mesh/user_screens/user_social_profile.dart';
// import 'package:wash_mesh/widgets/custom_background.dart';
// import 'package:wash_mesh/widgets/custom_button.dart';
// import 'package:wash_mesh/widgets/custom_logo.dart';
// import 'package:wash_mesh/widgets/custom_text_field.dart';

// import '../providers/user_provider/user_auth_provider.dart';
// import '../user_map_integration/assistants/user_assistant_methods.dart';
// import '../user_map_integration/user_global_variables/user_global_variables.dart';
// import '../user_map_integration/user_notifications/user_push_notifications.dart';
// import '../widgets/custom_navigation_bar.dart';

// class UserLoginForm extends StatefulWidget {
//   const UserLoginForm({Key? key}) : super(key: key);

//   @override
//   State<UserLoginForm> createState() => _UserLoginFormState();
// }

// class _UserLoginFormState extends State<UserLoginForm> {
//   final formKey = GlobalKey<FormState>();
//   TextEditingController emailPhone = TextEditingController();
//   TextEditingController password = TextEditingController();
//   bool isLoading = false;

//   onSubmit() async {
//     setState(() {
//       isLoading = true;
//     });
//     final userData = Provider.of<UserAuthProvider>(context, listen: false);
//     try {
//       final isValid = formKey.currentState!.validate();
//       if (isValid) {
//         await login();

//         UserPushNotifications pushNotifications = UserPushNotifications();
//         await pushNotifications.generateToken();

//         dynamic fcmToken;

//         final ref = FirebaseDatabase.instance.ref();
//         final snapshot = await ref
//             .child('users')
//             .child(firebaseAuth.currentUser!.uid)
//             .child('fcmToken')
//             .get();
//         if (snapshot.exists) {
//           fcmToken = snapshot.value;
//           print(fcmToken);
//         } else {
//           print('No data available.');
//         }

//         final result = await userData.loginUser(
//           input: emailPhone.text.trim(),
//           password: password.text.trim(),
//           fcmToken: fcmToken,
//         );

//         if (result == 'Login Successfully') {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           prefs.setString("userEmail", emailPhone.text);
//           prefs.setString("userPassword", password.text);

//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//               builder: (context) => const CustomNavigationBar(),
//             ),
//             (route) => false,
//           );
//         } else {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => const UserLoginForm(),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       rethrow;
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   login() async {
//     try {
//       final UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
//         email: emailPhone.text.trim(),
//         password: password.text.trim(),
//       );

//       if (user.user != null) {
//         UserAssistantMethods.readCurrentOnlineUserInfo();

//         DatabaseReference userRef =
//             FirebaseDatabase.instance.ref().child('users');
//         userRef.child(firebaseAuth.currentUser!.uid).once().then((userKey) {
//           final snap = userKey.snapshot;
//           if (snap.value != null) {
//             Fluttertoast.showToast(msg: 'Login Successfully');
//           } else {
//             Fluttertoast.showToast(msg: 'No record exist with this email.');
//           }
//         });
//       } else {
//         Fluttertoast.showToast(msg: 'Login Failed, Check your credentials.');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }

//   checkPassword() async {
//     SharedPreferences p = await SharedPreferences.getInstance();

//     if (p.getString("userEmail") != null &&
//         p.getString("userPassword") != null) {
//       emailPhone.text = p.getString("userEmail")!;
//       password.text = p.getString("userPassword")!;
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     checkPassword();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomBackground(
//       op: 0.1,
//       ch: Center(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 15.w),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 const CustomLogo(),
//                 SizedBox(height: 15.h),
//                 Container(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'Log In',
//                     style: TextStyle(
//                       fontSize: 25.sp,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Image.asset('assets/images/pngegg.png'),
//                 SizedBox(height: 30.h),
//                 Form(
//                   key: formKey,
//                   child: Column(
//                     children: [
//                       SizedBox(height: 8.h),
//                       CustomTextField(
//                         hint: 'emailPhone'.tr(),
//                         controller: emailPhone,
//                         keyboardType: TextInputType.emailAddress,
//                         validator: (value) {
//                           if (value!.isEmpty || !value.contains('@')) {
//                             return 'Please enter your email address';
//                           }
//                           return null;
//                         },
//                       ),
//                       CustomTextField(
//                         hint: 'password'.tr(),
//                         controller: password,
//                         validator: (value) {
//                           if (value!.isEmpty || value.length < 6) {
//                             return 'Please enter your password with at least 6 characters';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 8.h),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 5.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => const UserRegistrationForm(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Signup Now',
//                         style: TextStyle(
//                           fontSize: 15.sp,
//                         ),
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => const UserForgetPassword(),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Forget Password',
//                         style: TextStyle(
//                           fontSize: 15.sp,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 20.h),
//                 Text(
//                   'Continue with',
//                   style: TextStyle(
//                     fontSize: 20.sp,
//                   ),
//                 ),
//                 SizedBox(height: 20.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () async {
//                         await Provider.of<UserAuthProvider>(context,
//                                 listen: false)
//                             .signInWithGoogle(context);

//                         // await Provider.of<UserAuthProvider>(context,
//                         //         listen: false)
//                         //     .loginSocialUser(context);
//                       },
//                       child: Image.asset('assets/images/google-logo.png',
//                           height: 40.h),
//                     ),
//                     SizedBox(width: 16.w),
//                     InkWell(
//                       onTap: () async {
//                         await Provider.of<UserAuthProvider>(context,
//                                 listen: false)
//                             .signInWithFacebook(context);

//                         // await Provider.of<UserAuthProvider>(context,
//                         //         listen: false)
//                         //     .loginSocialFacebook();
//                         if (firstName != null) {
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                               builder: (context) => const CustomNavigationBar(),
//                             ),
//                           );
//                         } else {
//                           Navigator.of(context).pushReplacement(
//                             MaterialPageRoute(
//                               builder: (context) => const UserSocialProfile(),
//                             ),
//                           );
//                         }
//                       },
//                       child: Image.asset('assets/images/facebook-logo.png',
//                           height: 40.h),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 60.h),
//                 isLoading == true
//                     ? const Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : CustomButton(
//                         onTextPress: onSubmit,
//                         buttonText: 'LOG IN',
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/models/user_models/user_model.dart';
import 'package:wash_mesh/user_screens/user_forget_password.dart';
import 'package:wash_mesh/user_screens/user_home_screen.dart';
import 'package:wash_mesh/user_screens/user_registration_form.dart';
import 'package:wash_mesh/user_screens/user_social_profile.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';
import 'package:wash_mesh/widgets/custom_text_field.dart';

import '../providers/user_provider/user_auth_provider.dart';
import '../user_map_integration/assistants/user_assistant_methods.dart';
import '../user_map_integration/user_global_variables/user_global_variables.dart';
import '../user_map_integration/user_notifications/user_push_notifications.dart';
import '../widgets/custom_navigation_bar.dart';

String email = "";

class UserLoginForm extends StatefulWidget {
  const UserLoginForm({Key? key}) : super(key: key);

  @override
  State<UserLoginForm> createState() => _UserLoginFormState();
}

class _UserLoginFormState extends State<UserLoginForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController? emailPhone = TextEditingController();
  TextEditingController? password = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  //bool formState = false;

  onSubmit() async {
    setState(() {
      isLoading = true;
    });
    final userData = Provider.of<UserAuthProvider>(context, listen: false);
    try {
      final isValid = formKey.currentState!.validate();
      if (isValid) {
        await login();

        UserPushNotifications pushNotifications = UserPushNotifications();
        await pushNotifications.generateToken();

        dynamic fcmToken;

        final ref = FirebaseDatabase.instance.ref();
        final snapshot = await ref
            .child('users')
            .child(firebaseAuth.currentUser!.uid)
            .child('fcmToken')
            .get();
        if (snapshot.exists) {
          fcmToken = snapshot.value;
          print(fcmToken);
        } else {
          print('No data available.');
        }

        final result = await userData.loginUser(
          input: emailPhone!.text.trim(),
          password: password!.text.trim(),
          fcmToken: fcmToken,
        );

        if (result == 'Login Successfully') {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userEmail", emailPhone!.text);
          prefs.setString("userPassword", password!.text);
          print(emailPhone!.text);
          print(password!.text);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const CustomNavigationBar(),
            ),
            (route) => false,
          );
          setState(() {
            isLoading = false;
          });
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserLoginForm(),
            ),
          );
        }
      }
    } catch (e) {
      print("ggggggggg${e}");
      return e.toString();
    }
    setState(() {
      isLoading = false;
      print("lllllll${isLoading}");
    });
  }

  login() async {
    try {
      final UserCredential user = await firebaseAuth.signInWithEmailAndPassword(
        email: emailPhone!.text.trim(),
        password: password!.text.trim(),
      );

      if (user.user != null) {
        UserAssistantMethods.readCurrentOnlineUserInfo();

        DatabaseReference userRef =
            FirebaseDatabase.instance.ref().child('users');
        userRef.child(firebaseAuth.currentUser!.uid).once().then((userKey) {
          final snap = userKey.snapshot;
          if (snap.value != null) {
            Fluttertoast.showToast(msg: 'Login Successfully');
          } else {
            Fluttertoast.showToast(msg: 'No record exist with this email.');
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        Fluttertoast.showToast(msg: 'Login Failed, Check your credentials.');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      //  Fluttertoast.showToast(msg: e.toString());
      setState(() {
        isLoading = false;
      });
    }
    isLoading = false;
  }

  checkPassword() async {
    SharedPreferences p = await SharedPreferences.getInstance();

    if (p.getString("userEmail") != null &&
        p.getString("userPassword") != null) {
      emailPhone!.text = p.getString("userEmail")!;
      password!.text = p.getString("userPassword")!;
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
    return Form(
      key: _formKey,
      child: CustomBackground(
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
                          hint: 'emailPhone'.tr(),
                          controller: emailPhone!,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Please enter your email address';
                            }
                            return null;
                          },
                        ),
                        CustomTextField(
                          hint: 'password'.tr(),
                          controller: password!,
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Please enter your password with at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        //  SizedBox(height: 8.h),
                      ],
                    ),
                  ),
                  //  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             const UserRegistrationForm(),
                      //       ),
                      //     );
                      //   },
                      //   child: Text(
                      //     'Signup Now',
                      //     style: TextStyle(
                      //       fontSize: 15.sp,
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UserForgetPassword(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Text(
                            'Forget Password?',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Continue with',
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          await Provider.of<UserAuthProvider>(context,
                                  listen: false)
                              .signInWithGoogle(context);

                          // await Provider.of<UserAuthProvider>(context,
                          //         listen: false)
                          //     .loginSocialUser(context);
                        },
                        child: Image.asset('assets/images/google-logo.png',
                            height: 40.h),
                      ),
                      SizedBox(width: 16.w),
                      InkWell(
                        onTap: () async {
                          await Provider.of<UserAuthProvider>(context,
                                  listen: false)
                              .loginFb();

                          // await Provider.of<UserAuthProvider>(context,
                          //         listen: false)
                          //     .loginSocialFacebook();
                          if (firstName != null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CustomNavigationBar(),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const UserSocialProfile(),
                              ),
                            );
                          }
                        },
                        child: Image.asset('assets/images/facebook-logo.png',
                            height: 40.h),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  isLoading == true
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          onTextPress: onSubmit,
                          buttonText: 'LOG IN',
                        ),
                  SizedBox(
                    height: 20.h,
                  ),
                  // CustomButton(onTextPress: () {}, buttonText: "Sig"),
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
                              builder: (context) => UserRegistrationForm(),
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
      ),
    );
  }
}
