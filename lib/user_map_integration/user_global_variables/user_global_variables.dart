import 'package:firebase_auth/firebase_auth.dart';

import '../models/direction_details_model.dart';
import '../models/map_user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
UserCredential? activeUser;
MapUserModel? userModel;
List dList = [];

DirectionDetailsModel? tripDirectionDetails;
String? selectedDriverId;
String cloudeMessageServerToken =
    'key=AAAAI4hP7cE:APA91bEfUv9g_TJ7oWSChLpEQkbNbuc7D8gkyOrnNveiwwTnQziDB8_Za7iScv9V5Y5x5zs3HzcLdMfa89qyu8ufBwUlOKjHdTL4pf9CJ82H6IAVOB790R4uFN0178n1yAJNfpnG89NE';
String userDropOffAddress = '';
String driverName = '';
String driverPhone = '';
String? userToken;
