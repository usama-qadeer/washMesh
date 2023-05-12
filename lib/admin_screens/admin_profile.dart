// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/admin_screens/admin_settings.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_navigation_bar_admin.dart';
import 'package:wash_mesh/widgets/custom_text_field.dart';

import '../providers/admin_provider/admin_auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_logo.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final formKey = GlobalKey<FormState>();
  File? profileImg;
  dynamic convertedImage;
  dynamic getImage;
  bool loading = false;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController address = TextEditingController();

  getAdminProfile() async {
    setState(() {
      loading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    final url =
        Uri.parse('https://washmesh.stackbuffers.com/api/user/vendor/profile');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      var firstN = json['data']['Vendor']['first_name'];
      var lastN = json['data']['Vendor']['last_name'];
      var add = json['data']['Vendor']['address'];
      var img = json['data']['Vendor']['image'];

      setState(() {
        firstName.text = firstN;
        lastName.text = lastN;
        address.text = add;
        loading = false;
        getImage = img;
      });
    }
  }

  onUpdateAdmin() async {
    final adminData = Provider.of<AdminAuthProvider>(context, listen: false);
    try {
      final isValid = formKey.currentState!.validate();
      if (isValid) {
        final result = await adminData.updateAdminData(
          firstName: firstName.text,
          lastName: lastName.text,
          address: address.text,
        );
        firstName.clear();
        lastName.clear();
        address.clear();

        onUpdateImage();

        Fluttertoast.showToast(msg: result);

        if (result != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const CustomNavigationBarAdmin(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const AdminSettings(),
            ),
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  onUpdateImage() async {
    final adminData = Provider.of<AdminAuthProvider>(context, listen: false);
    try {
      final result = await adminData.updateAdminImage(
        image: convertedImage,
      );

      Fluttertoast.showToast(msg: result);

      if (result != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CustomNavigationBarAdmin(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const AdminSettings(),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

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

  @override
  void initState() {
    super.initState();
    getAdminProfile();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
            child: Column(
              children: [
                const CustomLogo(),
                SizedBox(height: 15.h),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 30.sp,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox(
                            height: 100.h,
                            width: 100.w,
                            child: ClipOval(
                              child: profileImg != null
                                  ? Image.file(
                                      profileImg!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      '$getImage',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                    TextButton(
                      onPressed: profileImage,
                      child: const Text('Upload Image'),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        hint: 'First Name',
                        controller: firstName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField(
                        hint: 'Last Name',
                        controller: lastName,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                      CustomTextField(
                        hint: 'Address',
                        controller: address,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                CustomButton(
                  onTextPress: onUpdateAdmin,
                  buttonText: 'Save Changes',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
