import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminRideRequestModel {
  LatLng? originLatLng;
  String? originAddress;
  String? rideRequestId;
  String? userName;
  String? userPhone;

  AdminRideRequestModel({
    this.originLatLng,
    this.originAddress,
    this.rideRequestId,
    this.userName,
    this.userPhone,
  });
}
