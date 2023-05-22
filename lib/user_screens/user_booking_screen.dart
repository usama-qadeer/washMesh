import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wash_mesh/user_screens/user_orders_screen.dart';

import '../widgets/custom_background.dart';
import '../widgets/custom_logo.dart';

class UserBookingScreen extends StatefulWidget {
  const UserBookingScreen({Key? key}) : super(key: key);

  @override
  State<UserBookingScreen> createState() => _UserBookingScreenState();
}

class _UserBookingScreenState extends State<UserBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 45.h, horizontal: 12.w),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomLogo(),
                SizedBox(height: 15.h),
                SvgPicture.asset('assets/svg/booking.svg'),
                SizedBox(height: 30.h),
                SizedBox(
                  width: 300.w,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserOrdersScreen(),
                        ),
                      );
                    },
                    child: const Text('All Customer Orders'),
                  ),
                ),
                // SizedBox(height: 16.h),
                // SizedBox(
                //   width: 300.w,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const MainScreen(),
                //         ),
                //       );
                //     },
                //     child: const Text('Map Screen'),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
