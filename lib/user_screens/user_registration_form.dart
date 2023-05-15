// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wash_mesh/user_screens/user_login_form.dart';
import 'package:wash_mesh/user_screens/user_otp_screen.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';
import 'package:wash_mesh/widgets/custom_text_field.dart';

import '../models/user_models/user_model.dart' as u;
import '../providers/user_provider/user_auth_provider.dart';

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({Key? key}) : super(key: key);

  static String verify = '';

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  bool? agree = false;
  final formKey = GlobalKey<FormState>();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneCode = TextEditingController();
  TextEditingController viaPhone = TextEditingController();

  String? selectedGender;
  List gender = [
    '1',
    '2',
  ];

  File? profileImg;
  dynamic convertedImage;
  bool loading = false;

  profileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
    );
    if (imageFile == null) {
      return;
    }
    profileImg = File(imageFile.path);

    final imageByte = profileImg!.readAsBytesSync();
    setState(() {
      convertedImage = "data:image/png;base64,${base64Encode(imageByte)}";
    });
  }

  bool isLoading = false;

  onRegister() async {
    setState(() {
      isLoading = true;
    });
    final userData = Provider.of<UserAuthProvider>(context, listen: false);
    try {
      final isValid = formKey.currentState!.validate();

      if (isValid) {
        u.User user = u.User(
          firstName: firstName.text,
          lastName: lastName.text,
          email: email.text.trim(),
          password: password.text.trim(),
          confirmPassword: confirmPassword.text.trim(),
          address: address.text,
          image: convertedImage,
          phone: viaPhone.text.trim(),
          gender: selectedGender,
        );
        await userData.registerUser(user, context);
        // print("jjjjjjjjjjjjjj${UserModel().data!.user!.phone}");
      }
    } catch (e) {
      return e.toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  ///
  otpCode(var viaPhone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneCode.text + viaPhone.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        UserRegistrationForm.verify = verificationId;
        //  UserForgetPassword.verify = verificationId;
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

  ///

//  otpCode(var phoneNo, context) async {
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: phoneCode.text + phoneNo,
//       verificationCompleted: (PhoneAuthCredential credential) {},
//       verificationFailed: (FirebaseAuthException e) {},
//       codeSent: (String verificationId, int? resendToken) {
//         UserRegistrationForm.verify = verificationId;
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => const UserOtpScreen(),
//           ),
//         );
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }

  @override
  void initState() {
    phoneCode.text = "+92";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 15.w),
            child: Column(
              children: [
                const CustomLogo(),
                SizedBox(height: 15.h),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Registration Form',
                    style: TextStyle(
                      fontSize: 25.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: ClipOval(
                    child: profileImg != null
                        ? Image.file(
                            profileImg!,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/profile.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                TextButton(
                  onPressed: profileImage,
                  child: const Text('Upload Image'),
                ),
                SizedBox(height: 15.h),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        hint: 'firstName'.tr(),
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        controller: firstName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'lastName'.tr(),
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        controller: lastName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'email'.tr(),
                        keyboardType: TextInputType.emailAddress,
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        controller: email,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please enter your email address';
                          }
                          return null;
                        },
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 5.w),
                              Expanded(
                                flex: 5,
                                child: TextFormField(
                                  controller: viaPhone,
                                  maxLength: 12,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    suffixIcon: const Icon(
                                      Icons.star,
                                      size: 20,
                                    ),
                                    hintText: '923121234567',
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
                                    if (value!.isEmpty && value.length < 12) {
                                      return 'Please enter your valid phone number';
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
                      CustomTextField(
                        hint: 'password'.tr(),
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        controller: password,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please enter your password with at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'confirmPassword'.tr(),
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        controller: confirmPassword,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please re-enter your password';
                          } else if (password.text != confirmPassword.text) {
                            return "password doesn't match";
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'address'.tr(),
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        controller: address,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedGender,
                          hint: const Text(
                            'Gender',
                            style: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                          items: gender
                              .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e == '1' ? 'Male' : 'Female'),
                                  ))
                              .toList(),
                          borderRadius: BorderRadius.circular(32.r),
                          onChanged: (String? value) {
                            selectedGender = value!;
                          },
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.r),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.r),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.r),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  'Register with',
                  style: TextStyle(fontSize: 20.sp),
                ),
                SizedBox(height: 15.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<UserAuthProvider>(context, listen: false)
                            .signInWithGoogle(context);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const UserLoginForm(),
                          ),
                        );
                      },
                      child: Image.asset('assets/images/google-logo.png',
                          height: 40.h),
                    ),
                    SizedBox(width: 16.w),
                    InkWell(
                      onTap: () {
                        Provider.of<UserAuthProvider>(context, listen: false)
                            .signInWithFacebook(context);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const UserLoginForm(),
                          ),
                        );
                      },
                      child: Image.asset('assets/images/facebook-logo.png',
                          height: 40.h),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                // InkWell(
                //   onTap: () {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => const UserLoginForm(),
                //       ),
                //     );
                //   },
                //   child: Text(
                //     'alreadyAccount'.tr(),
                //     style: TextStyle(fontSize: 20.sp),
                //   ),
                // ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10.h, left: 20.w),
                      child: Checkbox(
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value!;
                          });
                        },
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.w, top: 10.h),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              actions: <Widget>[
                                SizedBox(
                                  height: 650.h,
                                  child: SfPdfViewer.asset(
                                    'assets/pdf_files/customer.pdf',
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          agree = true;
                                          setState(() {});
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(14),
                                          child: const Text("I agree",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'I agree to the',
                              style: TextStyle(
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              ' Terms & Conditions',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: agree == false,
                    child: Container(
                      margin: EdgeInsets.only(left: 30.w, top: 10.h),
                      child: Row(
                        children: [
                          Text(
                            'Please agree to the Terms & Conditions',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 15.h),
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        onTextPress: agree == true ? onRegister : null,
                        buttonText: 'SIGN UP',
                      ),
                SizedBox(
                  height: 15.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const UserLoginForm(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45.h,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'alreadyAccount'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "poppinsTextTheme",
                            //   backgroundColor: Colors.grey.shade300,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                    ),
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
