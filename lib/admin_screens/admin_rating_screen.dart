// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../admin_screens/admin_single_order_detail.dart';
import '../providers/admin_provider/admin_auth_provider.dart';

class AdminRatingScreen extends StatefulWidget {
  final String orderAmount;

  const AdminRatingScreen({super.key, required this.orderAmount});

  @override
  State<AdminRatingScreen> createState() => _AdminRatingScreenState();
}

class _AdminRatingScreenState extends State<AdminRatingScreen> {
  String? extraCharges;
  TextEditingController additionalChargesC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var vendorAuthProvider =
        Provider.of<AdminAuthProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Form(
        key: formKey,
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
              const Text(
                'Total Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                thickness: 1,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              Text(
                widget.orderAmount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(22),
                ),
                width: 200.w,
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter Additional Charges";
                    }
                    return null;
                  },
                  controller: additionalChargesC,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Enter Additional charges',
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                    ),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    extraCharges = value;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(18),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await vendorAuthProvider.extraCharges(
                        context: context,
                        id: acceptedOrderId,
                        charges: extraCharges! + widget.orderAmount,
                      );

                      Navigator.pop(context, 'done');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
