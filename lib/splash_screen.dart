// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/register_screen.dart';
import 'package:wash_mesh/user_map_integration/user_global_variables/user_global_variables.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';
import 'package:wash_mesh/widgets/custom_navigation_bar.dart';
import 'package:wash_mesh/widgets/custom_navigation_bar_admin.dart';

import 'admin_map_integration/admin_global_variables/admin_global_variables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void timer() {
    Timer(
      const Duration(seconds: 3),
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userToken = prefs.getString('userToken');
        adminToken = prefs.getString('token');

        if (prefs.getBool('userLoggedIn') == true &&
            FirebaseAuth.instance.currentUser != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomNavigationBar(),
            ),
            (route) => false,
          );
        } else if (prefs.getBool('adminLoggedIn') == true) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const CustomNavigationBarAdmin(),
            ),
            (route) => false,
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    timer();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.0,
      ch: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomLogo(),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
