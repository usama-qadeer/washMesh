import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

import '../providers/user_provider/user_auth_provider.dart';
import '../register_screen.dart';
import '../services/firebase_auth_methods.dart';

class DisableUser extends StatefulWidget {
  const DisableUser({super.key});

  @override
  State<DisableUser> createState() => _DisableUserState();
}

class _DisableUserState extends State<DisableUser> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        ch: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Spacer(),
          Text(
            "Your Verification Is Under Process. WashMesh Will Notify You After Confirmation",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  onPressed: () async {
                    isLoading = true;
                    await FirebaseAuthMethods(FirebaseAuth.instance)
                        .signOut(context);

                    await Provider.of<UserAuthProvider>(context, listen: false)
                        .userLogout();

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('userToken');
                    await prefs.setBool('userLoggedIn', false);
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                      (route) => false,
                    );
                    setState(() {
                      isLoading == true;
                    });
                  },
                  child: Text("Logout")),
            ),
          ),
          // InkWell(
          //   onTap: () async {
          //     await FirebaseAuthMethods(FirebaseAuth.instance).signOut(context);

          //     await Provider.of<UserAuthProvider>(context, listen: false)
          //         .userLogout();

          //     SharedPreferences prefs = await SharedPreferences.getInstance();
          //     await prefs.remove('userToken');
          //     await prefs.setBool('userLoggedIn', false);
          //     Navigator.of(context).pushAndRemoveUntil(
          //       MaterialPageRoute(
          //         builder: (context) => const RegisterScreen(),
          //       ),
          //       (route) => false,
          //     );
          //   },
          //   child: Text(
          //     'Logout',
          //     style: TextStyle(
          //       fontSize: 20.sp,
          //       fontWeight: FontWeight.bold,
          //       color: CustomColor().mainColor,
          //     ),
          //   ),
          // ),
        ]),
        op: 0.1);
  }
}
