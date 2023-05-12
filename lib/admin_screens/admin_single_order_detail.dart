// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wash_mesh/models/single_order_detail_model.dart';
import 'package:wash_mesh/providers/admin_provider/admin_auth_provider.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

dynamic acceptedOrderAmount;
dynamic acceptedOrderId;
dynamic totalAmount;

class AdminSingleOrderDetail extends StatefulWidget {
  final dynamic acceptedOrderId;
  final dynamic acceptedOrderAmount;
  final dynamic totalAmount;

  const AdminSingleOrderDetail({
    super.key,
    required this.acceptedOrderId,
    required this.acceptedOrderAmount,
    required this.totalAmount,
  });

  @override
  State<AdminSingleOrderDetail> createState() => _AdminSingleOrderDetailState();
}

class _AdminSingleOrderDetailState extends State<AdminSingleOrderDetail> {
  @override
  Widget build(BuildContext context) {
    acceptedOrderId = widget.acceptedOrderId;
    acceptedOrderAmount = widget.acceptedOrderAmount;
    totalAmount = widget.totalAmount;

    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder<SingleOrderDetailModel>(
            future: AdminAuthProvider.getSingleOrderDetail(
                orderId: widget.acceptedOrderId),
            builder: (context, snapshot) {
              return !snapshot.hasData || snapshot.data?.data == null
                  ? Center(
                      heightFactor: 9.h,
                      child: const Text(
                        textAlign: TextAlign.center,
                        'No orders accepted\n Or\n wait for the process...',
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
                                    'All Accepted Orders',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              ListView(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                children: [
                                  Container(
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
                                            "${widget.acceptedOrderAmount}",
                                          ),
                                        ],
                                      ),
                                      title: snapshot.data!.data!.status == '2'
                                          ? const Text('Accepted')
                                          : const Text(''),
                                      subtitle: Text(
                                        "Description : ${snapshot.data!.data!.description}",
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Total Amount :"),
                                          SizedBox(height: 6.h),
                                          Text(
                                            "${widget.totalAmount}",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
