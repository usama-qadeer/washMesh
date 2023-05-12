import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wash_mesh/user_screens/user_otp_screen.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

class UserForgetPassword extends StatefulWidget {
  const UserForgetPassword({Key? key}) : super(key: key);
  static String verify = '';

  @override
  State<UserForgetPassword> createState() => _UserForgetPasswordState();
}

class _UserForgetPasswordState extends State<UserForgetPassword> {
  final formKey = GlobalKey<FormFieldState>();
  TextEditingController viaPhone = TextEditingController();
  TextEditingController phoneCode = TextEditingController();

  Future otpCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneCode.text + viaPhone.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        UserForgetPassword.verify = verificationId;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                UserOtpScreen(input: phoneCode.text + viaPhone.text),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    super.initState();
    phoneCode.text = '+92';
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CustomLogo(),
                SizedBox(height: 15.h),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Forget Password',
                    style: TextStyle(
                      fontSize: 25.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Image.asset('assets/images/pngegg.png'),
                // SizedBox(height: 30.h),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextFormField(
                              controller: phoneCode,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                          ),
                          SizedBox(width: 05.w),
                          Expanded(
                            flex: 5,
                            child: TextFormField(
                              controller: viaPhone,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '3331234567',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300.h,
                ),
                // Expanded(
                //   child: Container(
                //       //   height: 200.h,
                //       // color: Colors.red,
                //       ),
                // ),
                SingleChildScrollView(
                  child: CustomButton(
                    onTextPress: otpCode,
                    buttonText: 'OK',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
