import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wash_mesh/admin_screens/admin_login_form.dart';
import 'package:wash_mesh/admin_screens/admin_registration_form.dart';
import 'package:wash_mesh/admin_screens/admin_services.dart';
import 'package:wash_mesh/models/admin_models/order_detail_model.dart';
import 'package:wash_mesh/models/admin_models/vendor_applied.dart';
import 'package:wash_mesh/models/admin_models/vendor_orders.dart';
import 'package:wash_mesh/models/admin_models/wash_category_model.dart';
import 'package:wash_mesh/models/single_order_detail_model.dart';

import '../../admin_map_integration/admin_global_variables/admin_global_variables.dart';
import '../../models/admin_models/admin_model.dart';

class AdminAuthProvider extends ChangeNotifier {
  static const baseURL = 'https://washmesh.stackbuffers.com/api';

// Admin Authentication Code:

  registerAdmin(Vendor adminData, context) async {
    final url = Uri.parse('$baseURL/user/vendor/register');

    final response = await http.post(
      url,
      body: jsonEncode(<String, dynamic>{
        'first_name': adminData.firstName,
        'last_name': adminData.lastName,
        'phone': adminData.phone,
        'address': adminData.address,
        'password': adminData.password,
        'confirm_password': adminData.confirmPassword,
        'user_name': adminData.userName,
        'referral_code': adminData.referralCode,
        'image': adminData.image,
        'cnic': adminData.vendorDetails!.cnic,
        'experience': adminData.vendorDetails!.experience,
        'gender': adminData.vendorDetails!.gender,
        'experience_cert_img': adminData.vendorDetails!.experienceCertImg,
        'cnic_front_img': adminData.vendorDetails!.cnicFrontImg,
        'cnic_back_img': adminData.vendorDetails!.cnicBackImg,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      dynamic token = jsonDecode(response.body)['data']['token'];
      dynamic email =
          await jsonDecode(response.body)['data']['Vendor']['email'];
      dynamic vendorId =
          await jsonDecode(response.body)['data']['Vendor']['id'];
      dynamic result = jsonDecode(response.body)['message'];

      // Service Provider Registered Successfully

      saveFormData(
        vendorId: vendorId,
        email: email,
        password: adminData.password,
        name: adminData.firstName,
        phone: adminData.phone,
      );

      Fluttertoast.showToast(msg: result);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              AdminServices(token: token, phone: adminData.phone),
        ),
      );
      print("111111${response.body}");
      print("2222222${response.statusCode}");
    } else {
      String? email = jsonDecode(response.body)['error'];

      Fluttertoast.showToast(msg: email!);
      print("333333${response.body}");
      print("44444${response.statusCode}");
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AdminRegisterScreen(),
        ),
      );
    }
    print(jsonDecode(response.body));
    notifyListeners();
    return Vendor.fromJson(jsonDecode(response.body));
  }

  saveFormData({
    required dynamic vendorId,
    required dynamic email,
    required dynamic password,
    required dynamic name,
    required dynamic phone,
  }) async {
    try {
      final UserCredential admin =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (admin.user != null) {
        Map adminData = {
          'id': admin.user!.uid,
          'vendorId': vendorId.toString(),
          'name': name,
          'email': email,
          'phone': phone,
        };

        DatabaseReference adminRef =
            FirebaseDatabase.instance.ref().child('vendor');
        adminRef.child(admin.user!.uid).set(adminData);
        currentAdmin = admin;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(admin.user!.uid)
            .set({
          'userId': admin.user!.uid,
          'username': name,
          'email': email,
        });

        Fluttertoast.showToast(msg: 'Account has been created successfully.');
      } else {
        Fluttertoast.showToast(msg: 'Account has not been Created.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  loginAdmin({
    var input,
    var password,
    var fcmToken,
  }) async {
    final url = Uri.parse(
        '$baseURL/user/vendor/login?input=$input&password=$password&fcm_token=$fcmToken');
    final response = await http.post(url);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['message'] ==
          'Service Provider Logged in Successfully!') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('Vendor', response.body);
        prefs.setString('token', jsonDecode(response.body)['data']['token']);
        prefs.setString('email',
            jsonDecode(response.body)['data']['Vendor']['email'].toString());
        prefs.setBool('adminLoggedIn', true);
        prefs.setString('adminPersonalInfo', response.body);
      }
      print("rrrrrrrr ${response.body}");
      print("ssssss${response.statusCode}");
      print(fcmToken);
      return jsonDecode(response.body)['message'];
    } else {
      print(fcmToken);
      print("eeeeeeeeeee ${response.body}");
    }
    notifyListeners();
  }

  updateAdminPassword({var newPassword, var ntoken}) async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    // var token = pref.getString('token');
    var url =
        Uri.parse('$baseURL/user/vendor/update/password?password=$newPassword');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $ntoken',
      },
    );
    notifyListeners();
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    } else {
      return 'Registration Failed';
    }
  }

  recreateAdminPassword(
    BuildContext context, {
    var input,
    var newPassword,
  }) async {
    print("hhhhhh${input}");
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var url = Uri.parse(
        '$baseURL/user/vendor/forget/password?input=$input&password=$newPassword');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        'secret-key':
            'a8sd78j%\$#a^&Hfaf**566\$##hwe!\\/\\]55adad\\4A@#PLDH dfu59 2033 3y58fsd6gf21ea2"}{@#:#\$23452asd d[',
      },
    );
    notifyListeners();

    if (response.statusCode == 200) {
      // print("llllllllllll${response.body}");
      var decode = jsonDecode(response.body)['data'];
      print("00000 ${decode['token']}");

      updateAdminPassword(
        newPassword: newPassword,
        ntoken: "${decode['token']}",
      );
      Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminLoginForm(),
              ))
          .whenComplete(() =>
              FirebaseAuth.instance.currentUser?.updatePassword(newPassword));

      // print("rrrrrrrrrrrrr ${response.statusCode}");
      return jsonDecode(response.body)['message'];
    } else {
      print("hhhhh ${response.statusCode}");
      return 'Registration Failed';
    }
  }

  adminLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');

    var url = Uri.parse('$baseURL/user/vendor/logout');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['message']);
      return jsonDecode(response.body)['message'];
    } else {
      print(jsonDecode(response.body)['message']);
    }
    notifyListeners();
  }

  updateAdminData(
      {var firstName, var lastName, var address, String? image}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var jsonObject = {
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
    };
    var jsonString = jsonEncode(jsonObject);

    var url = Uri.parse('$baseURL/user/vendor/update/profile');
    var response = await http.post(
      url,
      body: jsonString,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    }
    notifyListeners();
  }

  updateAdminImage({dynamic image}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var jsonObject = {
      'image': image,
    };
    var jsonString = jsonEncode(jsonObject);

    var url = Uri.parse('$baseURL/user/vendor/update/image');
    var response = await http.post(
      url,
      body: jsonString,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['message'];
    }
    notifyListeners();
  }

  updateAvailability({dynamic availability, context}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var jsonObject = {
      'availability': availability,
    };
    var jsonString = jsonEncode(jsonObject);

    var url = Uri.parse('$baseURL/user/vendor/availability/update');
    var response = await http.post(
      url,
      body: jsonString,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(jsonDecode(response.body)['message']),
      //   ),
      // );
      return jsonDecode(response.body)['message'];
    } else {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    }
    notifyListeners();
  }

  vendorAcceptOrder({dynamic id, context}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');

    var url = Uri.parse('$baseURL/user/vendor/accept/order?order_id=$id');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);

      return jsonDecode(response.body)['message'];
    } else {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    }
    notifyListeners();
  }

  vendorRejectOrder({dynamic id, context}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');

    var url = Uri.parse('$baseURL/user/vendor/reject/order?order_id=$id');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);

      return jsonDecode(response.body)['message'];
    } else {
      Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    }
    notifyListeners();
  }

  extraCharges({dynamic id, dynamic charges, context}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');

    var url = Uri.parse(
        '$baseURL/user/vendor/order/status/deliverd?order_id=$id&extra_charges=$charges');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      // Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);

      return jsonDecode(response.body)['message'];
    } else {
      // Fluttertoast.showToast(msg: jsonDecode(response.body)['message']);
    }
    notifyListeners();
  }

  Future<List<WashCategoryModel>> getInfo() async {
    final url = Uri.parse('$baseURL/wash/categories');
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.body);
        return list.map((e) => WashCategoryModel.fromJson(e)).toList();
      } else {
        return <WashCategoryModel>[];
      }
    } catch (e) {
      return <WashCategoryModel>[];
    }
  }

  static Future<VendorApplied> getVendorApplied() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url = Uri.parse('$baseURL/user/vendor/category/applied');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return VendorApplied?.fromJson(jsonDecode(response.body));
    } else {
      return VendorApplied();
    }
  }

  static Future<VendorOrders> getVendorOrders() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url = Uri.parse('$baseURL/user/vendor/orders/all');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return VendorOrders.fromJson(jsonDecode(response.body));
    } else {
      return VendorOrders();
    }
  }

  static Future<SingleOrderDetailModel> getSingleOrderDetail(
      {var orderId}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url = Uri.parse('$baseURL/user/order/single_order?order_id=$orderId');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return SingleOrderDetailModel.fromJson(jsonDecode(response.body));
    } else {
      return SingleOrderDetailModel();
    }
  }

  static Future<VendorOrders> getResponseOrders() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url = Uri.parse('$baseURL/user/vendor/orders/responsed');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return VendorOrders.fromJson(jsonDecode(response.body));
    } else {
      return VendorOrders();
    }
  }

  static Future<OrderDetailModel> getVendorEarnings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url = Uri.parse('$baseURL/user/order/vendor?status=10');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return OrderDetailModel.fromJson(jsonDecode(response.body));
    } else {
      return OrderDetailModel();
    }
  }

  static Future<OrderDetailModel> getVendorBookings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url = Uri.parse('$baseURL/user/order/vendor?status=all');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return OrderDetailModel.fromJson(jsonDecode(response.body));
    } else {
      return OrderDetailModel();
    }
  }

  static Future<OrderDetailModel> getAcceptedBookings() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url = Uri.parse('$baseURL/user/order/vendor?status=2');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return OrderDetailModel.fromJson(jsonDecode(response.body));
    } else {
      return OrderDetailModel();
    }
  }

  static Future<OrderDetailModel> getVendorUpcomingServices() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url =
        Uri.parse('$baseURL/user/order/vendor?status=all&sortBy=upcoming');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return OrderDetailModel.fromJson(jsonDecode(response.body));
    } else {
      return OrderDetailModel();
    }
  }

  static Future<OrderDetailModel> getVendorTodayServices() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    final url = Uri.parse('$baseURL/user/order/vendor?status=all&sortBy=today');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      return OrderDetailModel.fromJson(jsonDecode(response.body));
    } else {
      return OrderDetailModel();
    }
  }

  Future<AdminModel> getAdminData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var url = Uri.parse('$baseURL/user/vendor/profile');
    var response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    notifyListeners();

    if (response.statusCode == 200) {
      return AdminModel?.fromJson(jsonDecode(response.body));
    } else {
      return AdminModel();
    }
  }
}
