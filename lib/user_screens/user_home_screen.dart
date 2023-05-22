// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/global_variables/global_variables.dart';
import 'package:wash_mesh/models/user_models/slider_model.dart';
import 'package:wash_mesh/providers/user_provider/user_info_provider.dart';
import 'package:wash_mesh/user_screens/wash_book_screen.dart';
import 'package:wash_mesh/user_screens/wash_category_screen.dart';
import 'package:wash_mesh/widgets/custom_background.dart';
import 'package:wash_mesh/widgets/custom_colors.dart';
import 'package:wash_mesh/widgets/custom_logo.dart';

import '../models/user_models/mesh_categories_model.dart' as mc;
import '../models/user_models/user_model.dart';
import '../models/user_models/wash_categories_model.dart' as um;
import '../providers/user_provider/user_auth_provider.dart';
import '../user_map_integration/assistants/user_assistant_methods.dart';
import 'mesh_book_screen.dart';
import 'mesh_category_screen.dart';

String? firstName;

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  User user = User();

  bool isLoading = false;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('userToken');
    final url = Uri.parse(
        'https://washmesh.stackbuffers.com/api/user/customer/profile');
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;
      var firstN = json['data']['User']['first_name'];

      void setState(fn) {
        if (mounted) {
          firstName = firstN;
          super.setState(fn);
        }
      }

      // setState(() {
      //   firstName = firstN;
      // });
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  final Completer<GoogleMapController> _googleMapController =
      Completer<GoogleMapController>();

  GoogleMapController? newGoogleMapController;

  Position? userCurrentPosition;
  // LocationPermission? _locationPermission;

  // allowLocationPermission() async {
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;
  //   _locationPermission = await Geolocator.requestPermission();
  //   if (_locationPermission == LocationPermission.denied) {
  //     _locationPermission = await Geolocator.requestPermission();
  //   }
  // }

  userLocation() async {
    setState(() {
      isLoading = true;
    });
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    userCurrentPosition = currentPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(
      target: latLngPosition,
      zoom: 14,
    );

    newGoogleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        cameraPosition,
      ),
    );

    await UserAssistantMethods.reverseGeocoding(userCurrentPosition!, context);
    setState(() {
      isLoading = false;
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    GoogleMap(
      initialCameraPosition: _kGooglePlex,
    );
    super.initState();
    getUserData();
    // allowLocationPermission();
    _handleLocationPermission();
    userLocation();
  }

  @override
  Widget build(BuildContext context) {
    var locationData = Provider.of<UserInfoProvider>(context, listen: false)
        .userPickUpLocation;

    return CustomBackground(
      ch: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 27.h, horizontal: 10.w),
            child: Column(
              children: [
                const CustomLogo(),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        firstName == null
                            ? Container(
                                // child: Text("null value"),
                                )
                            : Text(
                                '${'hello'.tr()}, ${firstName.toString().toCapitalized()}',
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
                SizedBox(height: 8.h),
                Image.asset(
                  'assets/images/home-cover.png',
                  fit: BoxFit.cover,
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
                      'category'.tr(),
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
                            builder: (context) => const WashCategory(),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svg/wash_one.svg',
                        width: 140.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const MeshCategory(),
                          ),
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/svg/mesh_one.svg',
                        width: 140.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'used'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 30.sp,
                      ),
                    ),
                  ],
                ),
                //   SizedBox(height: 8.h),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: FutureBuilder<um.WashCategoryModel>(
                    future: UserAuthProvider.getWashCategories(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    // .attribute!
                                    // .attributeValue!
                                    // .elementAt(index)
                                    // .id);
                                    List<um.Data> data = snapshot.data!.data!;
                                    var washCategory = snapshot.data!.data!
                                        .elementAt(index)
                                        .catAttribute;

                                    if (washCategory!.isNotEmpty) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => WashBookScreen(
                                            data,
                                            snapshot.data!.data!
                                                .elementAt(index)
                                                .name,
                                            snapshot.data!.data!
                                                .elementAt(index)
                                                .id,
                                            snapshot.data!.data!
                                                .elementAt(index)
                                                .fixedPrice,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Something went wrong!!!');
                                    }
                                  },
                                  child: Container(
                                    height: 20.h,
                                    decoration: const BoxDecoration(
                                        //border: Border.all(width: 2),
                                        ),
                                    child: Column(
                                      children: [
                                        Image.network(
                                          snapshot.data!.data!
                                              .elementAt(index)
                                              .image,
                                          fit: BoxFit.contain,
                                          width: 80.w,
                                          height: 80.h,
                                        ),
                                        //  SizedBox(height: 10.h),
                                        Flexible(
                                          child: Text(
                                            "${snapshot.data!.data!.elementAt(index).name}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
                // SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: FutureBuilder<mc.MeshCategoryModel>(
                    future: UserAuthProvider.getMeshCategories(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    // .attribute!
                                    // .attributeValue!
                                    // .elementAt(index)
                                    // .id);
                                    List<mc.Data> data = snapshot.data!.data!;
                                    var meshCategory = snapshot.data!.data!
                                        .elementAt(index)
                                        .catAttribute;

                                    if (meshCategory!.isNotEmpty) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MeshBookScreen(
                                            data,
                                            snapshot.data!.data!
                                                .elementAt(index)
                                                .name,
                                            snapshot.data!.data!
                                                .elementAt(index)
                                                .id,
                                            snapshot.data!.data!
                                                .elementAt(index)
                                                .fixedPrice,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Something went wrong!!!');
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Image.network(
                                        snapshot.data!.data!
                                            .elementAt(index)
                                            .image,
                                        fit: BoxFit.contain,
                                        width: 80.w,
                                        height: 80.h,
                                      ),
                                      SizedBox(height: 10.h),
                                      Flexible(
                                        child: Text(
                                          "${snapshot.data!.data!.elementAt(index).name}",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      op: 0.1,
    );
  }
}
