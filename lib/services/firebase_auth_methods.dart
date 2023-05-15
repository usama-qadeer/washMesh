import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(msg: 'Signed out Successfully!');
    } on FirebaseAuthException catch (e) {
      print("444 ${e.message}");
      Fluttertoast.showToast(msg: e.message!);
    }
  }
}
