import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/admin_screens/admin_single_order_detail.dart';
import 'package:wash_mesh/providers/user_provider/user_auth_provider.dart';
import 'package:wash_mesh/user_map_integration/user_global_variables/user_global_variables.dart';
import 'package:wash_mesh/widgets/admin_extra_charges_dialog.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

import '../providers/admin_provider/admin_auth_provider.dart';

class UserPayFareDialog extends StatefulWidget {
  final double fareAmount;
  final String orderId;
  var extraCharges;

  UserPayFareDialog({
    super.key,
    required this.fareAmount,
    required this.orderId,
    required this.extraCharges,
  });
  @override
  State<UserPayFareDialog> createState() => _UserPayFareDialogState();
}

class _UserPayFareDialogState extends State<UserPayFareDialog> {
  final formKey = GlobalKey<FormState>();
  // var a = extraCharges;
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserAuthProvider>(context, listen: false);

    var vendorAuthProvider =
        Provider.of<AdminAuthProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Form(
        child: Container(
          margin: const EdgeInsets.all(6),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              // const Text(
              //   'Total Amount',
              //   style: TextStyle(
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.blue,
              //   ),
              // ),
              CustomLogo(),
              const SizedBox(height: 20),
              const Divider(
                thickness: 1,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    'Booking Charges: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    widget.fareAmount.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    'Additional Charges: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    widget.extraCharges.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    'Total Charges: ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    widget.fareAmount.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.blue,
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
              // Text(
              //   widget.fareAmount.toString(),
              //   style: const TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 50,
              //     color: Colors.blue,
              //   ),
              // ),
              const SizedBox(height: 10),
              // const Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: Text(
              //     'Please pay your fee',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       color: Colors.blue,
              //     ),
              //   ),
              // ),
              //const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pop(context, 'cashPaid');
                      userData.completeOrder(id: widget.orderId);
                      dList.clear();
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Pay Cash',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Rs: ${widget.fareAmount}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //  const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Spacer(
                      flex: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await vendorAuthProvider.extraCharges(
                            context: context,
                            id: acceptedOrderId,
                            charges: widget.extraCharges,
                          );
                          // debugPrint(
                          //     "121212121 total amount with extra charges is  ${additionalChargesC.text + widget.orderAmount}");

                          Navigator.pop(context, 'working');
                        }
                        //   Navigator.pop(context);
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => AdminExtraChargesDialog(
                        //           orderAmount: widget.fareAmount.toString()),
                        //     ));

                        print("object");
                      },
                      child: Text(
                        'Click Here ',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    Text(
                      "If amount is not valid.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.blue,
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
