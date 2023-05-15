import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

import '../models/admin_models/order_detail_model.dart';

class TotalBookingScreen extends StatefulWidget {
  const TotalBookingScreen({Key? key}) : super(key: key);

  @override
  State<TotalBookingScreen> createState() => _TotalBookingScreenState();
}

class _TotalBookingScreenState extends State<TotalBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<OrderDetailModel>(
            future: AdminAuthProvider.getVendorBookings(),
            builder: (context, snapshot) {
              return !snapshot.hasData || snapshot.data!.data!.data!.isEmpty
                  ? Center(
                      heightFactor: 16.h,
                      // child: const Text(
                      //   textAlign: TextAlign.center,
                      //   'No bookings available\n Or\n wait for the process...',
                      //   style: TextStyle(
                      //     fontSize: 20,
                      //     color: Colors.redAccent,
                      //   ),
                      // ),
                      child: Shimmer.fromColors(
                          // direction: Duration(milliseconds: 200),
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              'Processing...',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          baseColor: Colors.redAccent,
                          highlightColor: Colors.grey.shade300),
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
                              vertical: 45.h, horizontal: 12.w),
                          child: Column(
                            children: [
                              const CustomLogo(),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'All Vendor Bookings',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              SizedBox(
                                height: 550.h,
                                child: ListView.builder(
                                  itemCount: snapshot.data!.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    var status = snapshot.data!.data!.data!
                                        .elementAt(index)
                                        .status;
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text("Amount :"),
                                              SizedBox(width: 5.h),
                                              Text(
                                                "${snapshot.data!.data!.data!.elementAt(index).amount}",
                                              ),
                                              SizedBox(width: 5.h),
                                              const Text("| Extra Charges :"),
                                              SizedBox(width: 5.h),
                                              Text(
                                                "${snapshot.data!.data!.data!.elementAt(index).extraCharges}",
                                              ),
                                              SizedBox(width: 5.h),
                                              const Text("| Total :"),
                                              SizedBox(width: 5.h),
                                              Text(
                                                "${snapshot.data!.data!.data!.elementAt(index).total}",
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              const Text("Description :"),
                                              SizedBox(width: 5.h),
                                              Text(
                                                "${snapshot.data!.data!.data!.elementAt(index).description}",
                                              ),
                                              SizedBox(width: 5.h),
                                              const Text("| Status :"),
                                              SizedBox(width: 5.h),
                                              const Text('Completed'),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            children: [
                                              const Text("Service At :"),
                                              SizedBox(width: 5.h),
                                              Text(
                                                snapshot.data!.data!.data!
                                                    .elementAt(index)
                                                    .serviceAt!
                                                    .substring(0, 10),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
            },
          ),
        ),
      ),
    );
  }
}
