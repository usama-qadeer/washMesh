import 'package:flutter/material.dart';
import 'package:wash_mesh/user_map_integration/models/user_direction_model.dart';

class UserInfoProvider extends ChangeNotifier {
  UserDirectionModel? userPickUpLocation, userDropOffLocation;

  void updatePickUpLocation(UserDirectionModel userPickupAddress) {
    userPickUpLocation = userPickupAddress;
    notifyListeners();
  }

  void updateDropOffLocation(UserDirectionModel userDropOffAddress) {
    userDropOffLocation = userDropOffAddress;
    notifyListeners();
  }
}
