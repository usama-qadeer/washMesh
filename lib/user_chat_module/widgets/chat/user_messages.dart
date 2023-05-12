import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'user_message_bubble.dart';

class UserMessages extends StatelessWidget {
  UserMessages({Key? key}) : super(key: key);

  final userId = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) => UserMessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['userId'] == userId!.uid,
            ValueKey(chatDocs[index].id),
            chatDocs[index]['username'],
          ),
        );
      },
    );
  }
}
