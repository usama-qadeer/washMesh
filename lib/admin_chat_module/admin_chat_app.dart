import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wash_mesh/admin_chat_module/screens/admin_auth_screen.dart';
import 'package:wash_mesh/admin_chat_module/screens/admin_chat_screen.dart';

class AdminChatApp extends StatelessWidget {
  const AdminChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return const AdminChatScreen();
          }
          return const AdminAuthScreen();
        },
      ),
    );
  }
}
