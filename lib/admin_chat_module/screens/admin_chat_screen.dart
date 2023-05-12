import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/admin_messages.dart';
import '../widgets/chat/admin_new_messages.dart';

class AdminChatScreen extends StatefulWidget {
  const AdminChatScreen({Key? key}) : super(key: key);

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  Future<void> deleteAll() async {
    final collection =
        await FirebaseFirestore.instance.collection("chat").get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in collection.docs) {
      batch.delete(doc.reference);
    }

    return batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        actions: [
          DropdownButton(
            elevation: 0,
            underline: Container(),
            borderRadius: BorderRadius.circular(16),
            dropdownColor: Colors.pinkAccent,
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'clear',
                child: Row(
                  children: const [
                    Icon(
                      Icons.clear_all,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Clear Chat',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value == 'clear') {
                deleteAll();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: AdminMessages()),
          const AdminNewMessages(),
        ],
      ),
    );
  }
}
