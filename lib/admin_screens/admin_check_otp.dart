import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:wash_mesh/admin_screens/admin_login_form.dart';
import 'package:wash_mesh/admin_screens/admin_send_otp.dart';
import 'package:wash_mesh/models/user_models/user_model.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_colors.dart';

class AdminOTPVerify extends StatefulWidget {
  const AdminOTPVerify({Key? key}) : super(key: key);

  @override
  State<AdminOTPVerify> createState() => _AdminOTPVerifyState();
}

class _AdminOTPVerifyState extends State<AdminOTPVerify> {
  UserModel model = UserModel();
  String smsCode = "";
  @override
  Widget build(BuildContext context) {
    ///  print("jjjjjjjjjjjjjj${UserModel().data!.user!.phone}");
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    FirebaseAuth auth = FirebaseAuth.instance;
    return CustomBackground(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(
      //       Icons.arrow_back_ios_rounded,
      //       color: Colors.black,
      //     ),
      //   ),
      //   elevation: 0,
      // ),
      op: 0.1,
      ch: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
            child: SingleChildScrollView(
              child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // CustomLogo(),
                  // SizedBox(
                  //   height: 25,
                  // ),
                  // Text(
                  //   "Phone Verification",
                  //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  // ),

                  SizedBox(
                    height: 150.h,
                  ),
                  Text(
                    "Enter O.T.P",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Pinput(
                    length: 6,
                    // defaultPinTheme: defaultPinTheme,
                    // focusedPinTheme: focusedPinTheme,
                    // submittedPinTheme: submittedPinTheme,

                    showCursor: true,
                    onCompleted: (pin) => print(pin),
                    onChanged: (value) {
                      smsCode = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColor().mainColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          try {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: AdminSendOTP.verify,
                                    smsCode: smsCode);

                            await auth.signInWithCredential(credential);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminLoginForm(),
                                ));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                            // return e.toString();
                            // print("Wrong OTP");
                          }
                        },
                        child: Text("Verify Phone Number")),
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              'phone',
                              (route) => false,
                            );
                          },
                          child: Text(
                            "",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
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
