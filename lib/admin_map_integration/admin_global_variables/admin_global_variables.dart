import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../models/admin_driver_data_model.dart';
import '../models/admin_driver_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
UserCredential? currentAdmin;
User? currentAdminUser;
AdminDriverModel? driverModel;

StreamSubscription<Position>? streamSubscription;
StreamSubscription<Position>? driverStreamSubscription;
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
Position? driverCurrentPosition;
bool isDriverActive = false;

AdminDriverDataModel? driverDataModel = AdminDriverDataModel();
String? driverCarType = '';
String? adminToken;
