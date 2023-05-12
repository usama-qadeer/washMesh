import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wash_mesh/admin_screens/admin_single_order_detail.dart';
import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

import '../models/admin_models/order_detail_model.dart';

class AdminAcceptedOrderScreen extends StatefulWidget {
  const AdminAcceptedOrderScreen({Key? key}) : super(key: key);

  @override
  State<AdminAcceptedOrderScreen> createState() =>
      _AdminAcceptedOrderScreenState();
}

class _AdminAcceptedOrderScreenState extends State<AdminAcceptedOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<OrderDetailModel>(
            future: AdminAuthProvider.getAcceptedBookings(),
            builder: (context, snapshot) {
              return !snapshot.hasData || snapshot.data!.data!.data!.isEmpty
                  ? Center(
                      heightFactor: 9.h,
                      child: const Text(
                        textAlign: TextAlign.center,
                        'No bookings available\n Or\n wait for the process...',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.redAccent,
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
                              vertical: 45.h, horizontal: 12.w),
                          child: Column(
                            children: [
                              const CustomLogo(),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Vendor Accepted Bookings',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.sp,
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
                                    var orderId = snapshot.data!.data!.data!
                                        .elementAt(index)
                                        .id;
                                    var amount = snapshot.data!.data!.data!
                                        .elementAt(index)
                                        .amount;
                                    var totalAmount = snapshot.data!.data!.data!
                                        .elementAt(index)
                                        .total;
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
                                              status == '1'
                                                  ? const Text('')
                                                  : const Text('Accepted'),
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
                                              SizedBox(width: 5.h),
                                              TextButton(
                                                onPressed: () async {
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminSingleOrderDetail(
                                                        acceptedOrderId:
                                                            orderId,
                                                        acceptedOrderAmount:
                                                            amount,
                                                        totalAmount:
                                                            totalAmount,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                      'Order Status'),
                                                ),
                                              )
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
