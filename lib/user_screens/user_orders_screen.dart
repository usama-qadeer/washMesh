import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wash_mesh/user_screens/accepted_orders_screen.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

import '../models/user_models/orders_model.dart' as or;
import '../providers/user_provider/user_auth_provider.dart';

class UserOrdersScreen extends StatefulWidget {
  const UserOrdersScreen({Key? key}) : super(key: key);

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: StreamBuilder<or.OrdersModel>(
          stream: UserAuthProvider.getOrders().asStream(),
          builder: (context, snapshot) {
            return !snapshot.hasData || snapshot.data!.data == null
                ? const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Place your order\nOr\n Wait for the process to complete',
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
                                  'All User Orders',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              height: 530.h,
                              child: ListView.builder(
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: (context, index) {
                                  var status = snapshot.data!.data!
                                      .elementAt(index)
                                      .status;
                                  var orderId =
                                      snapshot.data!.data!.elementAt(index).id;
                                  var orderAmount = snapshot.data!.data!
                                      .elementAt(index)
                                      .amount;

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
                                      title: status.toString() == '1'
                                          ? const Text('Processing...')
                                          : const Text('Accepted'),
                                      subtitle: Text(
                                        "Description : ${snapshot.data!.data!.elementAt(index).description}",
                                      ),
                                      trailing: status.toString() == '1'
                                          ? TextButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AcceptedOrdersScreen(
                                                      acceptedOrderId: orderId,
                                                      acceptedOrderAmount:
                                                          orderAmount,
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
                                                child:
                                                    const Text('Order Status'),
                                              ),
                                            )
                                          : const Text(''),
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
