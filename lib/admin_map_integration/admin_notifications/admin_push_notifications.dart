import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../admin_global_variables/admin_global_variables.dart';
import '../models/admin_ride_request_model.dart';
import 'admin_notification_dialog_box.dart';

class AdminPushNotifications {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(context) async {
    //  1. Terminated
    messaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        readRideRequestInfo(remoteMessage.data['rideRequestId'], context);
      }
    });

    //  2. Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      readRideRequestInfo(remoteMessage!.data['rideRequestId'], context);
    });

    //  3. Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readRideRequestInfo(remoteMessage!.data['rideRequestId'], context);
    });
  }

  readRideRequestInfo(String requestId, context) {
    FirebaseDatabase.instance
        .ref()
        .child('All Order Requests')
        .child(requestId)
        .once()
        .then((rideData) {
      if (rideData.snapshot.value != null) {
        assetsAudioPlayer.open(
          Audio('assets/notifications/music_notification.mp3'),
        );
        assetsAudioPlayer.play();

        double originLat = double.parse(
            (rideData.snapshot.value as Map)['origin']['latitude'].toString());
        double originLng = double.parse(
            (rideData.snapshot.value as Map)['origin']['longitude'].toString());
        String originAddress =
            (rideData.snapshot.value as Map)['originAddress'];

        String userName = (rideData.snapshot.value as Map)['userName'];
        String userPhone = (rideData.snapshot.value as Map)['userPhone'];
        String userId = rideData.snapshot.key!;

        AdminRideRequestModel rideRequestModel = AdminRideRequestModel();

        rideRequestModel.originLatLng = LatLng(originLat, originLng);
        rideRequestModel.originAddress = originAddress;

        rideRequestModel.userName = userName;
        rideRequestModel.userPhone = userPhone;
        rideRequestModel.rideRequestId = userId;

        showDialog(
          context: context,
          builder: (context) => AdminNotificationDialogBox(
            rideRequestModel: rideRequestModel,
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Invalid Request Id');
      }
    });
  }

  Future generateToken() async {
    final fcmToken = await messaging.getToken();

    FirebaseDatabase.instance
        .ref()
        .child('vendor')
        .child(firebaseAuth.currentUser!.uid)
        .child('fcmToken')
        .set(fcmToken);

    // subscribe to topic on each app start-up
    await messaging.subscribeToTopic('allVendors');
    await messaging.subscribeToTopic('allUsers');
  }
}
