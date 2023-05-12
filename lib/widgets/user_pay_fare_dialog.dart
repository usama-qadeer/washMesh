import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/providers/user_provider/user_auth_provider.dart';
import 'package:wash_mesh/user_map_integration/user_global_variables/user_global_variables.dart';

class UserPayFareDialog extends StatefulWidget {
  final double fareAmount;
  final String orderId;

  const UserPayFareDialog(
      {super.key, required this.fareAmount, required this.orderId});

  @override
  State<UserPayFareDialog> createState() => _UserPayFareDialogState();
}

class _UserPayFareDialogState extends State<UserPayFareDialog> {
  @override
  Widget build(BuildContext context) {
    var userData = Provider.of<UserAuthProvider>(context, listen: false);

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
              widget.fareAmount.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Please pay your fee',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(18),
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
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
