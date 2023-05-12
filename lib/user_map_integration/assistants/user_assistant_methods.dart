import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wash_mesh/providers/user_provider/user_info_provider.dart';
import 'package:wash_mesh/user_map_integration/assistants/user_request_assistant.dart';

import '../../global_variables/map_keys.dart';
import '../models/direction_details_model.dart';
import '../models/map_user_model.dart';
import '../models/user_direction_model.dart';
import '../user_global_variables/user_global_variables.dart';

class UserAssistantMethods {
  static Future<String> reverseGeocoding(Position position, context) async {
    String apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    String readableAddress = '';
    var requestResponse = await UserRequestAssistant.receiveRequest(apiUrl);
    if (requestResponse != 'Error Occurred') {
      readableAddress = requestResponse['results'][0]['formatted_address'];

      UserDirectionModel userPickUpAddress = UserDirectionModel();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = readableAddress;

      Provider.of<UserInfoProvider>(context, listen: false)
          .updatePickUpLocation(userPickUpAddress);
    }
    return readableAddress;
  }

  static void readCurrentOnlineUserInfo() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(firebaseAuth.currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModel = MapUserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<DirectionDetailsModel?> getDirectionDetail(
      LatLng origin, LatLng destination) async {
    String directionUrl =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$mapKey';

    var directionResponse =
        await UserRequestAssistant.receiveRequest(directionUrl);

    if (directionResponse == 'Error Occurred') {
      return null;
    }

    DirectionDetailsModel directionDetailsModel = DirectionDetailsModel();

    directionDetailsModel.points =
        directionResponse['routes'][0]['overview_polyline']['points'];

    directionDetailsModel.distanceText =
        directionResponse['routes'][0]['legs'][0]['distance']['text'];

    directionDetailsModel.distanceValue =
        directionResponse['routes'][0]['legs'][0]['distance']['value'];

    directionDetailsModel.durationText =
        directionResponse['routes'][0]['legs'][0]['duration']['text'];

    directionDetailsModel.durationValue =
        directionResponse['routes'][0]['legs'][0]['duration']['value'];

    return directionDetailsModel;
  }

  static double calculateTripFee(DirectionDetailsModel directionDetailsModel) {
    double amountPerMin = (directionDetailsModel.durationValue! / 60) * 0.1;
    double amountPerKM = (directionDetailsModel.distanceValue! / 1000) * 0.1;

    double totalAmount = amountPerMin + amountPerKM;

    double totalInPKR = totalAmount * 120;

    return double.parse(totalInPKR.toStringAsFixed(0));
  }

  static sendNotificationToDriver(String fcmToken, String rideRequestId) {
    String destinationAddress = userDropOffAddress;

    Map<String, String> header = {
      'Content-Type': 'application/json',
      'Authorization': cloudeMessageServerToken,
    };

    Map notificationBody = {
      "body": "Destination Address: \n$destinationAddress",
      "title": "Trip Request"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": rideRequestId
    };

    Map notificationFormat = {
      "notification": notificationBody,
      "priority": "high",
      "data": dataMap,
      "to": fcmToken
    };

    var response = http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: header,
      body: jsonEncode(notificationFormat),
    );
  }
}
