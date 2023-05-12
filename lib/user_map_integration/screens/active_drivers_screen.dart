import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../assistants/user_assistant_methods.dart';
import '../user_global_variables/user_global_variables.dart';

class ActiveDriversScreen extends StatefulWidget {
  final DatabaseReference? rideRef;

  const ActiveDriversScreen({super.key, this.rideRef});

  @override
  State<ActiveDriversScreen> createState() => _ActiveDriversScreenState();
}

class _ActiveDriversScreenState extends State<ActiveDriversScreen> {
  String totalFee = '';

  typeFeeAmount(int index) {
    var totalFeeByType =
        UserAssistantMethods.calculateTripFee(tripDirectionDetails!);

    if (tripDirectionDetails != null) {
      totalFee = (totalFeeByType / 2).toStringAsFixed(0);
    }
    return totalFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nearest Online Vendors',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            widget.rideRef!.remove();

            Fluttertoast.showToast(
              msg: 'You cancelled the order',
            );
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDriverId = dList[index]['id'].toString();
              });
              Navigator.pop(context, 'selectedDriver');
            },
            child: Card(
              color: Colors.blue,
              elevation: 3,
              shadowColor: Colors.white,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                title: Text(
                  dList[index]['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  dList[index]['phone'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
