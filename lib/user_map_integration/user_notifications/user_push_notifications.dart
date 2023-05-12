import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserPushNotifications {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(context) async {
    //  1. Terminated
    messaging.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {}
    });

    //  2. Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {});

    //  3. Background
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage? remoteMessage) {});
  }

  Future generateToken() async {
    final fcmToken = await messaging.getToken();

    FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('fcmToken')
        .set(fcmToken);

    // subscribe to topic on each app start-up
    await messaging.subscribeToTopic('allVendors');
    await messaging.subscribeToTopic('allUsers');
  }
}
