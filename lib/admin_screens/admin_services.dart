// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wash_mesh/admin_screens/admin_send_otp.dart';
import 'package:wash_mesh/models/admin_models/vendor_applied.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_button.dart';
import 'package:wash_mesh/widgets/custom_colors.dart';

import '../providers/user_provider/user_auth_provider.dart';
import '../widgets/custom_logo.dart';
import 'admin_home_otp.dart';
import 'admin_registration_form.dart';

class AdminServices extends StatefulWidget {
  final String? token;
  final dynamic phone;

  AdminServices({super.key, this.token, this.phone});

  @override
  State<AdminServices> createState() => _AdminServicesState();
}

class _AdminServicesState extends State<AdminServices> {
  final List<String> _selectedWashItems = [];
  final List<int>? _selectedwashcat = [];
  final List<String> _selectedMeshItems = [];
  final List<int> _selectedmeshcat = [];
  nameid dt = nameid();

  void _washItemChange(String itemValue, bool isSelected, nameid i) {
    if (isSelected) {
      _selectedWashItems.add(itemValue);
      int place = i.lstname.indexOf(itemValue);
      _selectedwashcat?.add(i.lstcatid.elementAt(place));
    } else {
      int place = _selectedWashItems.indexOf(itemValue);
      _selectedWashItems.remove(itemValue);
      _selectedwashcat?.removeAt(place);
    }
  }

  void _meshItemChange(String itemValue, bool isSelected, nameid i) {
    if (isSelected) {
      _selectedMeshItems.add(itemValue);
      int place = i.lstname.indexOf(itemValue);
      _selectedmeshcat.add(i.lstcatid.elementAt(place));
    } else {
      int place = _selectedMeshItems.indexOf(itemValue);
      _selectedMeshItems.remove(itemValue);
      _selectedmeshcat.removeAt(place);
    }
  }

  _showMeshCategory(nameid ijk) async {
    await showDialog<nameid>(
      context: context,
      builder: (BuildContext context) {
        // int? selectedRadio = 0;
        return AlertDialog(
          title: const Text('Select Category'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                  children: List.generate(ijk.lstname.length, (index) {
                return CheckboxListTile(
                    value: _selectedWashItems.contains(ijk.lstname[index]),
                    title: Text(ijk.lstname[index]),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (v) {
                      _washItemChange(ijk.lstname[index], v!, ijk);

                      setState(() {});
                    });
              })),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Provider.of<UserAuthProvider>(context, listen: false)
                    .applyWashService(
                  wash: _selectedwashcat!,
                  token: widget.token!,
                  context: context,
                );
                setState(() {});
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  otpCode(var phoneNo, context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+$phoneNo',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        AdminRegisterScreen.verify = verificationId;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AdminHomeOTP(),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  _meshcat(nameid ijk) async {
    await showDialog<nameid>(
      context: context,
      builder: (BuildContext context) {
        // int? selectedRadio = 0;
        return AlertDialog(
          title: const Text('Select Category'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                  children: List.generate(ijk.lstname.length, (index) {
                return CheckboxListTile(
                    value: _selectedMeshItems.contains(ijk.lstname[index]),
                    title: Text(ijk.lstname[index]),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (v) {
                      _meshItemChange(ijk.lstname[index], v!, ijk);

                      setState(() {});
                    });
              })),
            );
          }),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await Provider.of<UserAuthProvider>(context, listen: false)
                    .applyMeshService(
                  mesh: _selectedmeshcat,
                  token: widget.token!,
                  context: context,
                );
                setState(() {});
                //await otpCode(widget.phone, context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<VendorApplied> showVendorApplied() async {
    final url = Uri.parse(
        'https://washmesh.stackbuffers.com/api/user/vendor/category/applied');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      return VendorApplied?.fromJson(jsonDecode(response.body));
    } else {
      return VendorApplied();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<VendorApplied>(
              future: showVendorApplied(),
              builder: (context, snapshot) {
                return snapshot.hasError
                    ? const Padding(
                        padding: EdgeInsets.only(top: 300),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Something Went Wrong, \nPlease ask admin for further assistance Thank you.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      )
                    : snapshot.connectionState == ConnectionState.waiting
                        ? const Padding(
                            padding: EdgeInsets.only(top: 320),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 35.h, horizontal: 15.w),
                            child: Column(
                              children: [
                                const CustomLogo(),
                                SizedBox(height: 15.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Register your Service(s)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/wash_one.svg',
                                      width: 130.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 5,
                                      children: snapshot.data!.data == null
                                          ? []
                                          : snapshot.data!.data!.wash!
                                              .map(
                                                (e) => Chip(
                                                  backgroundColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColor().mainColor,
                                                    fontSize: 16,
                                                  ),
                                                  label: Text(e.category!.name
                                                      .toString()),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    SizedBox(height: 10.h),
                                    CustomButton(
                                      onTextPress: () async {
                                        nameid catidaname = nameid();
                                        await UserAuthProvider.getWashNames()
                                            .then(
                                                (value) => catidaname = value);
                                        return _showMeshCategory(catidaname);
                                      },
                                      buttonText: 'Select Wash Service',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/mesh_one.svg',
                                      width: 130.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.start,
                                      spacing: 5,
                                      children: snapshot.data!.data == null
                                          ? []
                                          : snapshot.data!.data!.mesh!
                                              .map(
                                                (e) => Chip(
                                                  backgroundColor: Colors.white,
                                                  labelStyle: TextStyle(
                                                    color:
                                                        CustomColor().mainColor,
                                                    fontSize: 16,
                                                  ),
                                                  label: Text(e.category!.name
                                                      .toString()),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    SizedBox(height: 10.h),
                                    CustomButton(
                                      onTextPress: () async {
                                        nameid catidaname = nameid();
                                        await UserAuthProvider.getMeshNames()
                                            .then(
                                                (value) => catidaname = value);
                                        return _meshcat(catidaname);
                                      },
                                      buttonText: 'Select Mesh Service',
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 200.h,
                                ),
                                CustomButton(
                                    onTextPress: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AdminSendOTP(),
                                          ));
                                    },
                                    buttonText: "Verify OTP")
                              ],
                            ),
                          );
              }),
        ),
      ),
    );
  }
}
// ignore_for_file: use_build_context_synchronously

