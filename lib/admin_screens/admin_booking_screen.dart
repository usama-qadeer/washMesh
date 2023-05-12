import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wash_mesh/admin_screens/admin_orders_screen.dart';
import 'package:wash_mesh/admin_screens/admin_responded_screen.dart';

import '../widgets/custom_background.dart';
import '../widgets/custom_logo.dart';
import 'admin_accepted_order_screen.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({Key? key}) : super(key: key);

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  final List items = [
    'All',
    'Pending',
    'Accept',
    'On Going',
    'In Progress',
    'Hold',
    'Cancelled',
    'Rejected',
    'Failed',
    'Completed',
  ];

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
                SvgPicture.asset(
                  'assets/svg/booking.svg',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 30.h),
                SizedBox(
                  width: 300.w,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminOrdersScreen(),
                        ),
                      );
                    },
                    child: const Text('All Orders'),
                  ),
                ),
                SizedBox(
                  width: 300.w,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminRespondedScreen(),
                        ),
                      );
                    },
                    child: const Text('Respond Orders'),
                  ),
                ),
                SizedBox(
                  width: 300.w,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdminAcceptedOrderScreen(),
                        ),
                      );
                    },
                    child: const Text('Accepted Order'),
                  ),
                ),
                // SizedBox(
                //   width: 300.w,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const AdminTotalChargesDialog(),
                //         ),
                //       );
                //     },
                //     child: const Text('Amount'),
                //   ),
                // ),
                // SizedBox(
                //   width: 300.w,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const AdminSingleOrderDetail(),
                //         ),
                //       );
                //     },
                //     child: const Text('In Progress Order'),
                //   ),
                // ),
                // SizedBox(
                //   width: 300.w,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const AdminSingleOrderDetail(),
                //         ),
                //       );
                //     },
                //     child: const Text('Hold Status Order'),
                //   ),
                // ),
                // SizedBox(
                //   width: 300.w,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const AdminSingleOrderDetail(),
                //         ),
                //       );
                //     },
                //     child: const Text('Cancelled Status Order'),
                //   ),
                // ),
                // SizedBox(
                //   width: 300.w,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const AdminSingleOrderDetail(),
                //         ),
                //       );
                //     },
                //     child: const Text('Rejected Status Order'),
                //   ),
                // ),
                // SizedBox(
                //   width: 300.w,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const AdminSingleOrderDetail(),
                //         ),
                //       );
                //     },
                //     child: const Text('Failed Status Order'),
                //   ),
                // ),
                // SizedBox(
                //   width: 300.w,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const AdminSingleOrderDetail(),
                //         ),
                //       );
                //     },
                //     child: const Text('Completed Status Order'),
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
