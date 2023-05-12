// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wash_mesh/models/user_models/vendor_accepted_order.dart';
import 'package:wash_mesh/user_map_integration/screens/main_screen.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

import '../providers/user_provider/user_auth_provider.dart';

class AcceptedOrdersScreen extends StatefulWidget {
  final dynamic acceptedOrderId;
  final dynamic acceptedOrderAmount;

  const AcceptedOrdersScreen(
      {super.key,
      required this.acceptedOrderId,
      required this.acceptedOrderAmount});

  @override
  State<AcceptedOrdersScreen> createState() => _AcceptedOrdersScreenState();
}

class _AcceptedOrdersScreenState extends State<AcceptedOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    // var userAuthProvider =
    //     Provider.of<UserAuthProvider>(context, listen: false);

    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: FutureBuilder<VendorAcceptedOrder>(
          future:
              UserAuthProvider.getAcceptedVendorOrder(widget.acceptedOrderId),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data == null
                ? const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Processing please wait...',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                : snapshot.connectionState == ConnectionState.waiting
                    ? const Center(
                        child: CircularProgressIndicator(),
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
                                  'All Accepted Orders',
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
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: (context, index) {
                                  var status = snapshot.data!.status;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      minVerticalPadding: 10,
                                      leading: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Status:'),
                                          status == 2
                                              ? const Text('Accepted')
                                              : const Text(''),
                                        ],
                                      ),
                                      title: const Text('Vendor Name: '),
                                      subtitle: Text(
                                        '${snapshot.data!.data!.elementAt(index).vendors!.user!.userName}',
                                      ),
                                      trailing: TextButton(
                                        onPressed: () async {
                                          var vendorId = snapshot.data!.data!
                                              .elementAt(index)
                                              .vendorId;
                                          var orderId = snapshot.data!.data!
                                              .elementAt(index)
                                              .orderId;

                                          // await userAuthProvider
                                          //     .userAcceptOrder(
                                          //   orderId: orderId,
                                          //   vendorId: vendorId,
                                          //   context: context,
                                          // );
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => MainScreen(
                                                orderId: orderId,
                                                vendorId: vendorId,
                                                orderAmount:
                                                    widget.acceptedOrderAmount,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
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
    );
  }
}

// return snapshot.data!.message ==
// 'There is no Record of Accepted Service Providers against this Order' ||
// snapshot.data!.message ==
// 'This Customer Choose Service Provider against this Order'
