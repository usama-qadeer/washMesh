// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/admin_screens/admin_update_services.dart';
import 'package:wash_mesh/admin_screens/today_services.dart';
import 'package:wash_mesh/admin_screens/total_bookings.dart';
import 'package:wash_mesh/admin_screens/total_earnings.dart';
import 'package:wash_mesh/admin_screens/upcoming_services.dart';
import 'package:wash_mesh/global_variables/global_variables.dart';
import 'package:wash_mesh/widgets/custom_background.dart';

import '../admin_map_integration/admin_global_variables/admin_global_variables.dart';
import '../admin_map_integration/admin_notifications/admin_push_notifications.dart';
import '../admin_map_integration/assistants/admin_assistant_methods.dart';
import '../models/admin_models/admin_model.dart';
import '../providers/admin_provider/admin_auth_provider.dart';
import '../providers/admin_provider/admin_info_provider.dart';
import '../widgets/custom_colors.dart';
import '../widgets/custom_logo.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  Position? userCurrentPosition;
  LocationPermission? _locationPermission;
  bool isLoading = false;
  // dynamic userName;
  // dynamic availability;
  //
  // getAdminData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var token = prefs.getString('token');
  //   final url =
  //       Uri.parse('https://washmesh.stackbuffers.com/api/user/vendor/profile');
  //   var response = await http.get(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     var json = jsonDecode(response.body) as Map<String, dynamic>;
  //     var userN = json['data']['Vendor']['user_name'];
  //     var available = json['data']['Vendor']['vendor_details']['availability'];
  //     setState(() {
  //       userName = userN;
  //       availability = available;
  //     });
  //   }
  // }

  allowLocationPermission() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  userLocation() async {
    setState(() {
      isLoading = true;
    });
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = currentPosition;

    LatLng latLng = LatLng(
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 14);

    newGoogleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );

    await AdminAssistantMethods.reverseGeocoding(
        driverCurrentPosition!, context);
    setState(() {
      isLoading = false;
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  driverOnline() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    driverCurrentPosition = position;

    Geofire.initialize('activeDrivers');

    Geofire.setLocation(
      FirebaseAuth.instance.currentUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('vendor')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('vendorStatus');

    ref.set('idle');
    ref.onValue.listen((event) {});
  }

  getStreamLocation() {
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;

      if (isDriverActive == true) {
        Geofire.setLocation(
          FirebaseAuth.instance.currentUser!.uid,
          driverCurrentPosition!.latitude,
          driverCurrentPosition!.longitude,
        );

        LatLng latLng = LatLng(
          driverCurrentPosition!.latitude,
          driverCurrentPosition!.longitude,
        );

        newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
      }
    });
  }

  driverOffline() async {
    await Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);
    await Geofire.stopListener();

    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child('vendor')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child('vendorStatus');
    ref.remove();
    ref.onDisconnect();
    ref = null;
  }

  readDriverInfo() async {
    currentAdminUser = FirebaseAuth.instance.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child('vendor')
        .child(currentAdminUser!.uid)
        .once()
        .then((driverData) {
      if (driverData.snapshot.value != null) {
        driverDataModel!.id = (driverData.snapshot.value as Map)['id'];
        driverDataModel!.name = (driverData.snapshot.value as Map)['name'];
        driverDataModel!.email = (driverData.snapshot.value as Map)['email'];
        driverDataModel!.phone = (driverData.snapshot.value as Map)['phone'];
      }
    });

    AdminPushNotifications pushNotifications = AdminPushNotifications();
    pushNotifications.initializeCloudMessaging(context);
    pushNotifications.generateToken();
  }

  @override
  void initState() {
    super.initState();
    readDriverInfo();
    allowLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var adminData = Provider.of<AdminAuthProvider>(context, listen: false);
    var locationData = Provider.of<AdminInfoProvider>(context, listen: false)
        .adminPickUpLocation;

    return CustomBackground(
      op: 0.1,
      ch: SafeArea(
        child: FutureBuilder<AdminModel>(
          future: adminData.getAdminData(),
          builder: (context, snapshot) {
            return !snapshot.hasData && snapshot.data == null
                ? const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Processing...',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.redAccent,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 27.h, horizontal: 10.w),
                      child: Column(
                        children: [
                          const CustomLogo(),
                          SizedBox(height: 8.h),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 25.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${'hello'.tr()}, ${snapshot.data!.data!.vendor!.firstName.toString().toCapitalized()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 26.sp,
                                    ),
                                  ),
                                  Text(
                                    'welcome'.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateTime.now().toString().substring(0, 11),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                  Text(
                                    DateTime.now().toString().substring(11, 16),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18.sp,
                                      color: Colors.blueGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: CustomColor().mainColor,
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  snapshot.data!.data!.vendor!.vendorDetails!
                                              .availability ==
                                          '1'
                                      ? 'available'.tr()
                                      : 'notAvailable'.tr(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 100.w),
                                Switch(
                                  activeColor: Colors.white,
                                  activeTrackColor: Colors.greenAccent,
                                  value: snapshot.data!.data!.vendor!
                                              .vendorDetails!.availability ==
                                          '1'
                                      ? true
                                      : false,
                                  onChanged: (bool value) async {
                                    var availability = snapshot.data!.data!
                                        .vendor!.vendorDetails!.availability;

                                    await adminData.updateAvailability(
                                      availability: availability,
                                      context: context,
                                    );

                                    if (isDriverActive != true &&
                                        availability == '2') {
                                      driverOnline();
                                      getStreamLocation();

                                      setState(() {
                                        isDriverActive = true;
                                      });

                                      Fluttertoast.showToast(
                                          msg: 'You are online now');
                                    } else {
                                      driverOffline();
                                      setState(() {
                                        isDriverActive = false;
                                      });

                                      Fluttertoast.showToast(
                                          msg: 'You are offline now');
                                    }

                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: double.infinity,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: CustomColor().mainColor,
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'commission'.tr(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 60.w),
                                  Icon(
                                    Icons.percent_rounded,
                                    size: 28.sp,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            height: 200.h,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              zoomGesturesEnabled: false,
                              zoomControlsEnabled: false,
                              initialCameraPosition: _kGooglePlex,
                              onMapCreated: (controller) {
                                _googleMapController.complete(controller);
                                newGoogleMapController = controller;

                                userLocation();
                              },
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 50.h,
                            color: CustomColor().mainColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 10.w),
                                Flexible(
                                  child: isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          overflow: TextOverflow.ellipsis,
                                          locationData != null
                                              ? locationData.locationName!
                                              : 'Current Location',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                ),
                                SizedBox(width: 10.w),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text(
                                'editService'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AdminUpdateServices(),
                                    ),
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/svg/group.svg',
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 22.h),
                          Row(
                            children: [
                              Text(
                                'quickTab'.tr(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 30.sp,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TotalEarningsScreen(),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40.sp,
                                      child: Icon(
                                        Icons.camera,
                                        size: 43.sp,
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'total'.tr(),
                                      style: TextStyle(
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                    Text(
                                      'earning'.tr(),
                                      style: TextStyle(
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TotalBookingScreen(),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40.sp,
                                      child: Icon(
                                        Icons.edit_calendar_outlined,
                                        size: 43.sp,
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'total'.tr(),
                                      style: TextStyle(
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                    Text(
                                      'booking'.tr(),
                                      style: TextStyle(
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UpcomingServiceScreen(),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40.sp,
                                      child: Icon(
                                        Icons.list_alt_outlined,
                                        size: 43.sp,
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      'upcoming'.tr(),
                                      style: TextStyle(
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                    Text(
                                      'service'.tr(),
                                      style: TextStyle(
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TodayServicesScreen(),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 40.sp,
                                      child: Icon(
                                        Icons.design_services_outlined,
                                        size: 43.sp,
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      "today".tr(),
                                      style: TextStyle(
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                    Text(
                                      'service'.tr(),
                                      style: TextStyle(
                                        color: CustomColor().mainColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
