import 'package:flutter/material.dart';
import 'package:wash_mesh/admin_map_integration/models/admin_direction_model.dart';

class AdminInfoProvider extends ChangeNotifier {
  AdminDirectionModel? adminPickUpLocation, adminDropOffLocation;

  void updatePickUpLocation(AdminDirectionModel adminPickupAddress) {
    adminPickUpLocation = adminPickupAddress;
    notifyListeners();
  }

  void updateDropOffLocation(AdminDirectionModel adminDropOffAddress) {
    adminDropOffLocation = adminDropOffAddress;
    notifyListeners();
  }
}
