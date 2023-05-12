import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wash_mesh/models/user_models/user_model.dart';
import 'package:wash_mesh/user_screens/check_otp.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

import '../widgets/custom_colors.dart';

class SendOTP extends StatefulWidget {
  UserModel? userModel;
  SendOTP({Key? key, required this.userModel}) : super(key: key);

  static String verify = "";
  @override
  State<SendOTP> createState() => _SendOTPState();
}

class _SendOTPState extends State<SendOTP> {
  TextEditingController countryController = TextEditingController();
  var phone = "";
// countryController = "+92";
  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+92";
    // UserModel();
    // print("sssssssssssssssssss${UserModel().data!.user!.phone}");
    // userModelValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print("kkkkkkkkkkkkkkk${widget}");
    return CustomBackground(
      op: 0.1,
      ch: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
          child: SingleChildScrollView(
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    //  child: CustomLogo(),
                    ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Verify Your Phone Number With OTP",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 35,
                        child: TextField(
                          controller: countryController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      //  Text(
                      //    "|",
                      //    style: TextStyle(fontSize: 33, color: Colors.grey),
                      // ),
                      SizedBox(
                        width: 0,
                      ),
                      Expanded(
                        child: TextField(
                          onChanged: (val) {
                            phone = val;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "3121234567",
                            //  UserModel().data!.user!.phone ?? "3121234567",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: CustomColor().mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: countryController.text + phone,
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          SendOTP.verify = verificationId;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyVerify(),
                              ));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                      // Navigator.pushNamed(context, 'verify');
                    },
                    child: Text("Send the code"),
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
