import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(msg: 'Signed out Successfully!');
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!);
    }
  }
}
