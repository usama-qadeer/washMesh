// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/admin_map_integration/admin_global_variables/admin_global_variables.dart';
import 'package:wash_mesh/admin_screens/admin_profile.dart';
import 'package:wash_mesh/services/firebase_auth_methods.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

import '../providers/admin_provider/admin_auth_provider.dart';
import '../register_screen.dart';
import '../widgets/custom_colors.dart';
import '../widgets/custom_logo.dart';
import 'admin_app_language.dart';
import 'admin_change_password.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
          child: Column(
            children: [
              const CustomLogo(),
              SizedBox(height: 15.h),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 30.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/settings.svg',
                    width: 90.w,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminProfile(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: CustomColor().mainColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.perm_contact_cal_outlined,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                        Text(
                          'editProfile'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminAppLanguage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: CustomColor().mainColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.language_outlined,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                        Text(
                          'language'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AdminChangePassword(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: CustomColor().mainColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.lock,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                        Text(
                          'changePassword'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              InkWell(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 55.h,
                  decoration: BoxDecoration(
                    color: CustomColor().mainColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.error_outline_outlined,
                          size: 25.sp,
                          color: Colors.white,
                        ),
                        Text(
                          'about'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70.h),
              InkWell(
                onTap: () async {
                  Geofire.removeLocation(
                      FirebaseAuth.instance.currentUser!.uid);
                  isDriverActive = false;

                  await FirebaseAuthMethods(FirebaseAuth.instance)
                      .signOut(context);

                  await Provider.of<AdminAuthProvider>(context, listen: false)
                      .adminLogout();

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('token');
                  prefs.setBool('adminLoggedIn', false);

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColor().mainColor,
                  ),
                ),
              ),
              const Text(
                'V 5.0.0',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
