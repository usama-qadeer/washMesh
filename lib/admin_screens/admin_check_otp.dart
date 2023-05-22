import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/admin_screens/admin_send_otp.dart';
import 'package:wash_mesh/admin_screens/admin_services.dart';
import 'package:wash_mesh/models/admin_models/admin_model.dart';
import 'package:wash_mesh/models/user_models/user_model.dart';
import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_colors.dart';

// ignore: must_be_immutable
class AdminOTPVerify extends StatefulWidget {
  AdminModel? adminData;
  String? phone;
  String? token;
  AdminOTPVerify(
      {Key? key, required this.phone, this.token, required this.adminData})
      : super(key: key);

  @override
  State<AdminOTPVerify> createState() => _AdminOTPVerifyState();
}

class _AdminOTPVerifyState extends State<AdminOTPVerify>
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

  bool isLoading = false;
  @override
  void initState() {
    AdminModel;
    // print("gggggggg${AdminModel().data!.vendor!.phone}");
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
    final adminData = Provider.of<AdminAuthProvider>(context, listen: false);

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

  UserModel model = UserModel();
  String smsCode = "";
  bool resend = true;

  // resendOTP() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   var adminPhone = preferences.getString("adminPhone");
  //   print("14141414$adminPhone");
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: adminPhone,
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {
  //       Fluttertoast.showToast(msg: e.toString());
  //     },
  //     codeSent: (String verificationId, int? resendToken) {},
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  //   print("aaaaaa${adminPhone}");
  // }

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

    // ignore: unused_local_variable
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    // ignore: unused_local_variable
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    FirebaseAuth auth = FirebaseAuth.instance;
//     Future delay() async{
// await new Future.delayed(new Duration(milliseconds: 1500), ()
// {
//    Navigator.of(context).pushNamed("/home");

// });
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
                      //height: 150.h,
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
                                  builder: (context) => AdminServices(
                                    token: widget.token,
                                    phone: widget.phone,
                                  ),
                                ));
                            setState(() {
                              isLoading = true;
                            });
                          } catch (e) {
                            Fluttertoast.showToast(msg: e.toString());
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: Text(e.toString())));
                            // return e.toString();
                            // print("Wrong OTP");
                          }
                        },
                        child: Text("Verify Phone Number")),
                  ),
                  // Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  //   // Future.delayed(Duration)
                  //   //Future.delayed(Duration(seconds: 30)),
                  //   Visibility(
                  //     visible: resend,
                  //     child: ElevatedButton(
                  //       onPressed: () async {
                  //         setState(() {
                  //           resend = false;
                  //         });
                  //         resendOTP();
                  //         // print(adminPhone);
                  //         //   print("ggggg${AdminModel().data!.vendor!.phone}");
                  //       },
                  //       child: Text("Resend OTP"),
                  //     ),
                  //   ),
                  // ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Countdown(
                        onTap: () {
                          startAgain();
                          //   print("======-----======");
                        },
                        animation: StepTween(
                          begin: levelClock, // THIS IS A USER ENTERED NUMBER
                          end: 0,
                        ).animate(_controller!),
                      ),
                    ],
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
                  ),
                ],
              ),
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
  resendOTP() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var adminPhone = preferences.getString("adminPhone");
    // print("14141414$adminPhone");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: adminPhone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: e.toString());
      },
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    // print("aaaaaa${adminPhone}");
  }

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    // print('animation.value  ${animation!.value} ');
    // print('inMinutes ${clockTimer.inMinutes.toString()}');
    // print('inSeconds ${clockTimer.inSeconds.toString()}');
    // print(
    //     'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
    void againSendOtp() {
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
                  resendOTP();
                  animation!.value != 60;
                  onTap!();
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: ))
                },
                child: Text(
                  "RESEND OTP",
                  style: TextStyle(
                    fontSize: 20,
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
