// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/admin_screens/admin_forget_password.dart';
import 'package:wash_mesh/admin_screens/admin_recreate_password.dart';
import 'package:wash_mesh/models/admin_models/admin_model.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

class AdminOtpScreen extends StatefulWidget {
  String? input;
  AdminModel? adminModel;
  AdminOtpScreen({Key? key, this.adminModel, required this.input})
      : super(key: key);
  @override
  State<AdminOtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<AdminOtpScreen> {
  var smsCode = '';
  bool isLoading = false;
  bool resend = true;
  otpVerify() async {
    isLoading == true;
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: AdminForgetPassword.verify,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AdminRecreatePassword(
            input: widget.input,
            adminModel: AdminModel(),
          ),
        ),
      );
      setState(() {
        isLoading == true;
      });
    } catch (e) {
      return Fluttertoast.showToast(msg: e.toString());
    }
    isLoading == false;
  }

  resendOTP() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var adminPhone = preferences.getString("adminPhone");
    // print("jjjjj ${adminPhone}");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+${adminPhone}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: e.toString());
      },
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    print("aaaaaa${adminPhone}");
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return CustomBackground(
      op: 0.1,
      ch: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
          child: Column(
            children: [
              const CustomLogo(),
              SizedBox(height: 15.h),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'O.T.P',
                  style: TextStyle(
                    fontSize: 25.sp,
                  ),
                ),
              ),

              SizedBox(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 340.w,
                    child: Pinput(
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      length: 6,
                      showCursor: true,
                      onChanged: (value) {
                        smsCode = value;
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 25.h),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                // Future.delayed(Duration)
                Visibility(
                  visible: resend,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        resend = false;
                      });
                      resendOTP();
                      // print(adminPhone);
                      //   print("ggggg${AdminModel().data!.vendor!.phone}");
                    },
                    child: Text("Resend OTP"),
                  ),
                ),
              ]),
              // Text(
              //   'Resend Within 45s',
              //   style: TextStyle(
              //     fontSize: 17.sp,
              //   ),
              // ),
              Expanded(child: Container()),
              CustomButton(
                onTextPress: otpVerify,
                buttonText: 'VERIFY',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
