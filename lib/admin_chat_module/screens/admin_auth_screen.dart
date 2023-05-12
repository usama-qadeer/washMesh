import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/admin_auth_form.dart';

class AdminAuthScreen extends StatefulWidget {
  const AdminAuthScreen({super.key});

  @override
  State<AdminAuthScreen> createState() => _AdminAuthScreenState();
}

class _AdminAuthScreenState extends State<AdminAuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  Future<void> _submitAuthForm(
    String username,
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) async {
    // ignore: unused_local_variable
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        // ignore: unused_local_variable
        final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'userId': userCredential.user!.uid,
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (err) {
      var message = 'No user data available, Please check your credentials';
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AdminAuthForm(_submitAuthForm, _isLoading),
    );
  }
}
