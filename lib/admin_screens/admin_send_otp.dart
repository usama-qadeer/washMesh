import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wash_mesh/admin_screens/admin_check_otp.dart';
import 'package:wash_mesh/models/admin_models/admin_model.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

import '../widgets/custom_colors.dart';

class AdminSendOTP extends StatefulWidget {
  // late var userModelValue;
  String? phone;
  //AdminModel() model = AdminModel()

  AdminSendOTP(
      {Key? key,
      // this.userModelValue,
      this.phone})
      : super(key: key);

  static String verify = "";
  @override
  State<AdminSendOTP> createState() => _AdminSendOTPState();
}

class _AdminSendOTPState extends State<AdminSendOTP> {
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
    //print("kkkkkkkkkkkkkkk${widget.userModelValue}");
    return CustomBackground(
      op: 0.1,
      ch: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
            child: SingleChildScrollView(
              child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //     CustomLogo(),
                  SizedBox(
                    height: 200.h,
                  ),
                  Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          width: 33,
                          child: TextField(
                            controller: countryController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        // Text(
                        //   "|",
                        //   style: TextStyle(fontSize: 33, color: Colors.grey),
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
                          ),
                        ))
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
                            AdminSendOTP.verify = verificationId;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminOTPVerify(
                                    phone: widget.phone,
                                  ),
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
      ),
    );
  }
}
