// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../admin_screens/admin_single_order_detail.dart';
import '../providers/admin_provider/admin_auth_provider.dart';

class AdminExtraChargesDialog extends StatefulWidget {
  final String orderAmount;

  const AdminExtraChargesDialog({super.key, required this.orderAmount});

  @override
  State<AdminExtraChargesDialog> createState() =>
      _AdminExtraChargesDialogState();
}

class _AdminExtraChargesDialogState extends State<AdminExtraChargesDialog> {
  String? extraCharges;

  @override
  Widget build(BuildContext context) {
    var vendorAuthProvider =
        Provider.of<AdminAuthProvider>(context, listen: false);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
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
              child: TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter extra charges',
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
                  await vendorAuthProvider.extraCharges(
                    context: context,
                    id: acceptedOrderId,
                    charges: extraCharges,
                  );

                  Navigator.pop(context, 'done');
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
    );
  }
}
