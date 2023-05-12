import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/admin_map_integration/assistants/admin_request_assistant.dart';
import 'package:wash_mesh/admin_map_integration/models/admin_direction_model.dart';
import 'package:wash_mesh/providers/admin_provider/admin_info_provider.dart';

import '../../global_variables/map_keys.dart';
import '../admin_global_variables/admin_global_variables.dart';
import '../models/admin_direction_details_model.dart';
import '../models/admin_driver_model.dart';

class AdminAssistantMethods {
  static void readCurrentOnlineDriverInfo() async {
    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child('vendor')
        .child(firebaseAuth.currentUser!.uid);

    driverRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        driverModel = AdminDriverModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> reverseGeocoding(Position position, context) async {
    String apiUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey';
    String readableAddress = '';
    var requestResponse = await AdminRequestAssistant.receiveRequest(apiUrl);
    if (requestResponse != 'Error Occurred') {
      readableAddress = requestResponse['results'][0]['formatted_address'];

      AdminDirectionModel adminPickUpAddress = AdminDirectionModel();
      adminPickUpAddress.locationLatitude = position.latitude;
      adminPickUpAddress.locationLongitude = position.longitude;
      adminPickUpAddress.locationName = readableAddress;

      Provider.of<AdminInfoProvider>(context, listen: false)
          .updatePickUpLocation(adminPickUpAddress);
    }
    return readableAddress;
  }

  static Future<AdminDirectionDetailsModel?> getDirectionDetail(
      LatLng origin, LatLng destination) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$mapKey';
    var directionResponse = await AdminRequestAssistant.receiveRequest(url);

    if (directionResponse == 'Error Occurred') {
      return null;
    }
    AdminDirectionDetailsModel directionDetailsModel =
        AdminDirectionDetailsModel();

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

  static pauseLiveLocationUpdates() {
    streamSubscription!.pause();

    Geofire.removeLocation(currentAdminUser!.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscription!.resume();
    Geofire.setLocation(
      currentAdminUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );
  }

  static double calculateTripFee(
      AdminDirectionDetailsModel directionDetailsModel) {
    double amountPerMin = (directionDetailsModel.durationValue! / 60) * 0.1;
    double amountPerKM = (directionDetailsModel.distanceValue! / 1000) * 0.1;

    double totalAmount = amountPerMin + amountPerKM;

    double totalInPKR = totalAmount * 120;

    return totalInPKR.truncateToDouble();
  }
}
