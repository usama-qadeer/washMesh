// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/models/admin_models/vendor_orders.dart';
import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';
import 'package:wash_mesh/widgets/custom_navigation_bar_admin.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    var vendorAuthProvider =
        Provider.of<AdminAuthProvider>(context, listen: false);

    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<VendorOrders>(
            future: AdminAuthProvider.getVendorOrders(),
            builder: (context, snapshot) {
              return !snapshot.hasData || snapshot.data!.data!.isEmpty
                  ? Center(
                      heightFactor: 9.h,
                      child: const Text(
                        textAlign: TextAlign.center,
                        'No orders available\n Or\n wait for the process...',
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
                                    'All Vendor Orders',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: (context, index) {
                                  var status = snapshot.data!.data!
                                      .elementAt(index)
                                      .status;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      minVerticalPadding: 10,
                                      leading: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Amount :"),
                                          SizedBox(height: 6.h),
                                          Text(
                                            "${snapshot.data!.data!.elementAt(index).amount}",
                                          ),
                                        ],
                                      ),
                                      title: status == '1'
                                          ? const Text('Pending')
                                          : const Text(''),
                                      subtitle: Text(
                                        "Description : ${snapshot.data!.data!.elementAt(index).description}",
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              var id = snapshot.data!.data!
                                                  .elementAt(index)
                                                  .id;
                                              await vendorAuthProvider
                                                  .vendorRejectOrder(
                                                      id: id, context: context);
                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CustomNavigationBarAdmin(),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                            child: const Text(
                                              'Reject',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          InkWell(
                                            onTap: () async {
                                              var id = snapshot.data!.data!
                                                  .elementAt(index)
                                                  .id;
                                              await vendorAuthProvider
                                                  .vendorAcceptOrder(
                                                      id: id, context: context);

                                              Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CustomNavigationBarAdmin(),
                                                ),
                                                (route) => false,
                                              );
                                            },
                                            child: const Text(
                                              'Accept',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
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
