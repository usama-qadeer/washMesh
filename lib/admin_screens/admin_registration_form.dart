// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wash_mesh/admin_screens/admin_send_otp.dart';
import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

import '../models/admin_models/admin_model.dart';
import '../widgets/custom_colors.dart';
import '../widgets/custom_text_field.dart';
import 'admin_login_form.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({Key? key}) : super(key: key);

  static String verify = '';

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  bool? agree = false;
  final formKey = GlobalKey<FormState>();
  File? expCert;
  File? cnicFront;
  File? cnicBack;
  dynamic base64ImageExp;
  dynamic base64ImageF;
  dynamic base64ImageB;
  dynamic selectedGender;
  List gender = [
    '1',
    '2',
  ];

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController cnicNo = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController code = TextEditingController();
  TextEditingController address = TextEditingController();

  experienceCert() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
    );

    if (imageFile == null) {
      return;
    }
    expCert = File(imageFile.path);
    final imageByte = expCert!.readAsBytesSync();
    setState(() {
      base64ImageExp = "data:image/png;base64,${base64Encode(imageByte)}";
      Navigator.of(context).pop();
    });
  }

  experienceCertCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 300,
    );

    if (imageFile == null) {
      return;
    }
    expCert = File(imageFile.path);
    final imageByte = expCert!.readAsBytesSync();
    setState(() {
      base64ImageExp = "data:image/png;base64,${base64Encode(imageByte)}";
      Navigator.of(context).pop();
    });
  }

  cnicFrontImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
    );

    if (imageFile == null) {
      return;
    }
    cnicFront = File(imageFile.path);
    final imageByte = cnicFront!.readAsBytesSync();
    setState(() {
      base64ImageF = "data:image/png;base64,${base64Encode(imageByte)}";
      Navigator.of(context).pop();
    });
  }

  cnicFrontImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 300,
    );

    if (imageFile == null) {
      return;
    }
    cnicFront = File(imageFile.path);
    final imageByte = cnicFront!.readAsBytesSync();
    setState(() {
      base64ImageF = "data:image/png;base64,${base64Encode(imageByte)}";
      Navigator.of(context).pop();
    });
  }

  cnicBackImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
    );
    if (imageFile == null) {
      return;
    }
    cnicBack = File(imageFile.path);
    final imageByte = cnicBack!.readAsBytesSync();
    setState(() {
      base64ImageB = "data:image/png;base64,${base64Encode(imageByte)}";
      Navigator.of(context).pop();
    });
  }

  cnicBackImageCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 300,
    );
    if (imageFile == null) {
      return;
    }
    cnicBack = File(imageFile.path);
    final imageByte = cnicBack!.readAsBytesSync();
    setState(() {
      base64ImageB = "data:image/png;base64,${base64Encode(imageByte)}";
      Navigator.of(context).pop();
    });
  }

  File? profileImg;
  dynamic convertedImage;

  adminProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
    );
    // if (imageFile == null) {
    //   return;
    // }
    if (imageFile != null) {
      print("image selected");
      setState(() {
        //  imageFile = imageFile;
      });
      //other code
    } else {
      setState(() {
        isLoading = false;
      });
      print("image not selected");
      //other code
    }

    profileImg = File(imageFile!.path);

    final imageByte = profileImg!.readAsBytesSync();
    setState(() {
      convertedImage = "data:image/png;base64,${base64Encode(imageByte)}";
    });
  }

  bool isLoading = false;

  onRegister() async {
    setState(() {
      isLoading = false;
    });

    final adminData = Provider.of<AdminAuthProvider>(context, listen: false);

    try {
      final isValid = formKey.currentState!.validate();

      if (isValid) {
        setState(() {
          isLoading = true;
        });
        if (profileImg != null &&
            base64ImageF != null &&
            base64ImageB != null) {
          VendorDetails vendorDetails = VendorDetails(
            gender: selectedGender,
            experience: experience.text,
            cnic: cnicNo.text,
            experienceCertImg: base64ImageExp,
            cnicFrontImg: base64ImageF,
            cnicBackImg: base64ImageB,
          );

          Vendor vendor = Vendor(
            firstName: firstName.text,
            lastName: lastName.text,
            userName: userName.text,
            phone: phoneNo.text.trim(),
            image: convertedImage,
            address: address.text,
            password: password.text.trim(),
            confirmPassword: confirmPassword.text.trim(),
            referralCode: code.text,
            vendorDetails: vendorDetails,
          );
          // Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => AdminSendOTP(),
          //     ));
          await adminData.registerAdmin(vendor, context);
        } else {
          setState(() {
            isLoading = false;
          });
          return Fluttertoast.showToast(msg: "Upload Required Image. ");
        }
      }
    } catch (e) {
      return e.toString();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
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
                  onPressed: adminProfileImage,
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
                        hint: 'userName'.tr(),
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        controller: userName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your user name';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'phoneNo'.tr(),
                        keyboardType: TextInputType.phone,
                        maxLength: 12,
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        controller: phoneNo,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 12) {
                            return 'Please enter your valid number starting from 92';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'cnicNo'.tr(),
                        keyboardType: TextInputType.number,
                        maxLength: 13,
                        controller: cnicNo,
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 13) {
                            return 'Please enter your cnic number';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'password'.tr(),
                        controller: password,
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please enter your password with at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        hint: 'confirmPassword'.tr(),
                        controller: confirmPassword,
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
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
                        hint: 'experience'.tr(),
                        keyboardType: TextInputType.number,
                        controller: experience,
                      ),
                      CustomTextField(
                        hint: 'referralCode'.tr(),
                        keyboardType: TextInputType.number,
                        controller: code,
                      ),
                      CustomTextField(
                        hint: 'address'.tr(),
                        controller: address,
                        suffixIcon: const Icon(
                          Icons.star,
                          size: 20,
                        ),
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
                            'Gender*',
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
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Choose an Option:'),
                        actionsAlignment: MainAxisAlignment.center,
                        actions: [
                          ElevatedButton(
                            onPressed: experienceCert,
                            child: const Text('Gallery'),
                          ),
                          ElevatedButton(
                            onPressed: experienceCertCamera,
                            child: const Text('Camera'),
                          ),
                        ],
                      );
                    },
                  ),
                  child: Container(
                    width: 350.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: CustomColor().mainColor,
                      borderRadius: BorderRadius.circular(14.r),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: CustomColor().shadowColor2,
                      //     blurRadius: 6,
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'experienceCert'.tr(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        const Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                  ),
                  child: expCert != null
                      ? Image.file(
                          expCert!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : const Text(
                          'No Image Taken',
                          textAlign: TextAlign.center,
                        ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            title: const Text('Choose an Option:'),
                            actions: [
                              ElevatedButton(
                                onPressed: cnicFrontImage,
                                child: const Text('Gallery'),
                              ),
                              ElevatedButton(
                                onPressed: cnicFrontImageCamera,
                                child: const Text('Camera'),
                              ),
                            ],
                          );
                        },
                      ),
                      child: Container(
                        width: 168.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: CustomColor().mainColor,
                          borderRadius: BorderRadius.circular(14.r),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: CustomColor().shadowColor2,
                          //     blurRadius: 6,
                          //   ),
                          // ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'cnicFront'.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    InkWell(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.center,
                            title: const Text('Choose an Option:'),
                            actions: [
                              ElevatedButton(
                                onPressed: cnicBackImage,
                                child: const Text('Gallery'),
                              ),
                              ElevatedButton(
                                onPressed: cnicBackImageCamera,
                                child: const Text('Camera'),
                              ),
                            ],
                          );
                        },
                      ),
                      child: Container(
                        width: 168.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: CustomColor().mainColor,
                          borderRadius: BorderRadius.circular(14.r),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: CustomColor().shadowColor2,
                          //     blurRadius: 6,
                          //   ),
                          // ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'cnicBack'.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 5.w),
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   width: 80,
                    //   height: 80,
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //     border: Border.all(
                    //       width: 1,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    //   child: expCert != null
                    //       ? Image.file(
                    //           expCert!,
                    //           fit: BoxFit.cover,
                    //           width: double.infinity,
                    //         )
                    //       : const Text(
                    //           'No Image Taken',
                    //           textAlign: TextAlign.center,
                    //         ),
                    // ),
                    const SizedBox(width: 10),
                    Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: cnicFront != null
                          ? Image.file(
                              cnicFront!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : const Text(
                              'No Image Taken',
                              textAlign: TextAlign.center,
                            ),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      width: 80,
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: cnicBack != null
                          ? Image.file(
                              cnicBack!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : const Text(
                              'No Image Taken',
                              textAlign: TextAlign.center,
                            ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 20.h),
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
                                    'assets/pdf_files/vendor.pdf',
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
                SizedBox(height: 20.h),
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomButton(
                        onTextPress: agree == true ? onRegister : null,
                        buttonText: 'Next',
                      ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AdminLoginForm(),
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
      op: 0.1,
    );
  }
}
// ElevatedButton.icon(
//   onPressed: () {},
//   label: const Text(
//     'CNIC Front',
//   ),
//   icon: const Icon(Icons.camera_alt_outlined),
// ),
