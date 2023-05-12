import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wash_mesh/admin_map_integration/assistants/admin_assistant_methods.dart';

import '../../admin_screens/admin_new_trip_screen.dart';
import '../admin_global_variables/admin_global_variables.dart';
import '../models/admin_ride_request_model.dart';

class AdminNotificationDialogBox extends StatefulWidget {
  final AdminRideRequestModel rideRequestModel;

  const AdminNotificationDialogBox({super.key, required this.rideRequestModel});

  @override
  State<AdminNotificationDialogBox> createState() =>
      _AdminNotificationDialogBoxState();
}

class _AdminNotificationDialogBoxState
    extends State<AdminNotificationDialogBox> {
  acceptRideRequest(context) {
    String? getRequestId;

    FirebaseDatabase.instance
        .ref()
        .child('vendor')
        .child(currentAdminUser!.uid)
        .child('vendorStatus')
        .once()
        .then((snapshot) {
      if (snapshot.snapshot.value != null) {
        getRequestId = snapshot.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: 'This request do not exists.');
      }

      if (getRequestId == widget.rideRequestModel.rideRequestId) {
        FirebaseDatabase.instance
            .ref()
            .child('vendor')
            .child(currentAdminUser!.uid)
            .child('vendorStatus')
            .set('accepted');

        AdminAssistantMethods.pauseLiveLocationUpdates();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminNewTripScreen(
              rideRequestModel: widget.rideRequestModel,
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Invalid Request.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 2,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Image.asset(
              'assets/images/group.png',
              width: 160,
            ),
            const SizedBox(height: 2),
            const Text(
              'New Order',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/origin.png',
                        width: 40,
                      ),
                      const SizedBox(width: 14),
                      Flexible(
                        child: Text(
                          widget.rideRequestModel.originAddress!,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    assetsAudioPlayer.pause();
                    assetsAudioPlayer.stop();
                    assetsAudioPlayer = AssetsAudioPlayer();

                    FirebaseDatabase.instance
                        .ref()
                        .child('All Order Requests')
                        .child(widget.rideRequestModel.rideRequestId!)
                        .remove()
                        .then((rideData) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('vendor')
                          .child(currentAdminUser!.uid)
                          .child('vendorStatus')
                          .set('idle');
                    }).then((driver) {
                      FirebaseDatabase.instance
                          .ref()
                          .child('vendor')
                          .child(currentAdminUser!.uid)
                          .child('tripsHistory')
                          .child(widget.rideRequestModel.rideRequestId!)
                          .remove();
                    }).then((message) {
                      Fluttertoast.showToast(
                          msg: 'You cancelled the order request.');
                    });
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  onPressed: () {
                    assetsAudioPlayer.pause();
                    assetsAudioPlayer.stop();
                    assetsAudioPlayer = AssetsAudioPlayer();
                    acceptRideRequest(context);
                  },
                  child: const Text('Accept'),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
