// ignore_for_file: use_build_context_synchronously, override_on_non_overriding_member

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/providers/user_provider/user_auth_provider.dart';
import 'package:wash_mesh/user_screens/get_otp.dart';
import 'package:wash_mesh/user_screens/user_login_form.dart';
import 'package:wash_mesh/user_screens/user_registration_form.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

class UserHomeOTP extends StatefulWidget {
  String? phone;
  UserHomeOTP({Key? key, this.phone}) : super(key: key);

  @override
  State<UserHomeOTP> createState() => _UserHomeOTPState();
}

class _UserHomeOTPState extends State<UserHomeOTP>
    with TickerProviderStateMixin {
  int secondsRemaining = 30;
  bool enableResend = false;
  Timer? timer;
  int _counter = 0;
  AnimationController? _controller;
  int levelClock = 30;
  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller!.forward();
  }

  startAgain() async {
    final userData = Provider.of<UserAuthProvider>(context, listen: false);

    setState(() {
      levelClock = 30;
    });
    // userData.otpCode(widget.phone, context);

    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller!.forward();
  }

  Timer? countdownTimer;
  Duration myDuration = Duration(seconds: 30);
  @override

////end
  var smsCode;
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  otpVerify() async {
    if (_formKey.currentState!.validate()) {
      final FirebaseAuth auth = FirebaseAuth.instance;
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: UserRegistrationForm.verify,
        smsCode: smsCode.toString(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserLoginForm(),
        ),
        //  (route) => false,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserHomeOTP(),
        ),
        // (route) => true,
      );
    }
    // try {
    //   final FirebaseAuth auth = FirebaseAuth.instance;
    //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
    //     verificationId: UserRegistrationForm.verify,
    //     smsCode: smsCode,
    //   );
    //   // await auth.signInWithCredential(credential);
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => UserLoginForm(),
    //     ),
    //     (route) => false,
    //   );
    // } catch (e) {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //       builder: (context) => UserLoginForm(),
    //     ),
    //     (route) => true,
    //   );
    //   return e.toString();
    // }
  }

  bool isVerify = false;
  @override
  Widget build(BuildContext context) {
    //print("000000 ${userData}");

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 100, 167, 223)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromARGB(255, 63, 133, 190),
      ),
    );
    return Form(
      key: _formKey,
      child: CustomBackground(
        op: 0.1,
        ch: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
            child: Column(
              children: [
                const CustomLogo(),
                SizedBox(height: 15.h),

                // Text(
                //   '$_counter',
                // ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    ' ENTER O-T-P',
                    style: TextStyle(
                      fontSize: 25.sp,
                    ),
                  ),
                ),
                SizedBox(height: 15.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 340.w,
                      child: Pinput(
                        controller: controller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            "Please Enter Your OTP Code";
                            return null;
                          }
                        },
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
                SizedBox(
                  height: 20.h,
                ),
                Countdown(
                  onTap: () {
                    startAgain();
                    print("======-----======");
                  },
                  animation: StepTween(
                    begin: levelClock, // THIS IS A USER ENTERED NUMBER
                    end: 0,
                  ).animate(_controller!),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                //       child: GestureDetector(
                //         onTap: () {
                //           enableResend ? _resendCode : null;
                //         },
                //         child: Text(
                //           "Resend OTP",
                //           style: TextStyle(fontSize: 22),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Expanded(child: Container()),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            otpVerify();
                          }
                        },
                        child: Text(
                          "data",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xff0F75BC),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  onTextPress: otpVerify,
                  buttonText: 'VERIFY',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, this.animation, this.onTap})
      : super(key: key, listenable: animation!);
  Animation<int>? animation;
  GestureTapCallback? onTap;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    print('animation.value  ${animation!.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print(
        'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
    void resendOtp() {
      if (clockTimer.inSeconds == 0) {
        Text("");
      } else {}
    }

    return Column(
      children: [
        (clockTimer.inSeconds == 0)
            ? TextButton(
                onPressed: () {
                  //  resetTimer();
                  // resendOtp();
                  animation!.value != 60;
                  onTap!();
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: ))
                },
                child: Text(
                  "RESEND OTP",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ))
            : Text(
                clockTimer.inSeconds == 0 ? "RESENT OTP" : "$timerText",
                style: TextStyle(
                  fontSize: 110,
                  color: Theme.of(context).primaryColor,
                ),
              ),
      ],
    );
  }
}
