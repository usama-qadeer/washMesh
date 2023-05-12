// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/providers/user_provider/user_auth_provider.dart';
import 'package:wash_mesh/register_screen.dart';
import 'package:wash_mesh/user_screens/user_app_language.dart';
import 'package:wash_mesh/user_screens/user_change_password.dart';
import 'package:wash_mesh/user_screens/user_profile.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

import '../services/firebase_auth_methods.dart';
import '../widgets/custom_colors.dart';
import '../widgets/custom_logo.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 12.w),
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
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const UserProfile(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 60.h,
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
                          size: 30.sp,
                          color: Colors.white,
                        ),
                        Text(
                          'editProfile'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 25.sp,
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
                      builder: (context) => const UserAppLanguage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 60.h,
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
                          size: 30.sp,
                          color: Colors.white,
                        ),
                        Text(
                          'language'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 25.sp,
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
                      builder: (context) => const UserChangePassword(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 60.h,
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
                          size: 30.sp,
                          color: Colors.white,
                        ),
                        Text(
                          'changePassword'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 25.sp,
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
                  height: 60.h,
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
                          size: 30.sp,
                          color: Colors.white,
                        ),
                        Text(
                          'about'.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 22.sp,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 25.sp,
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
                  await FirebaseAuthMethods(FirebaseAuth.instance)
                      .signOut(context);

                  await Provider.of<UserAuthProvider>(context, listen: false)
                      .userLogout();

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('userToken');
                  prefs.setBool('userLoggedIn', false);

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
