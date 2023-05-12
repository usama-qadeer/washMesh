import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wash_mesh/user_chat_module/screens/user_auth_screen.dart';
import 'package:wash_mesh/user_chat_module/screens/user_chat_screen.dart';

class UserChatApp extends StatelessWidget {
  const UserChatApp({super.key});

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
            return const UserChatScreen();
          }
          return const UserAuthScreen();
        },
      ),
    );
  }
}
