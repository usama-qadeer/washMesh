import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class ChatRoom extends StatefulWidget {
  // late Map<String, dynamic> userMap;
  String? chatRoomId;
  String? receiverName;
  String? receiverEmail;
  String? receiverUid;
  String? receiverPhoto;
  ChatRoom(
      {required this.chatRoomId,
      required this.receiverEmail,
      required this.receiverUid,
      required this.receiverPhoto,
      required this.receiverName,
      Key? key})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFireStore = FirebaseFirestore.instance;

  final TextEditingController _message = TextEditingController();
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      var singleMessageUid = DateTime.now().millisecondsSinceEpoch;
      int todayTime = singleMessageUid;
      String message = _message.text.toString();
      _message.clear();
      debugPrint(message);

      await _firebaseFireStore
          .collection('ChatRoom')
          .doc(widget.chatRoomId.toString())
          .collection('chats')
          .doc(singleMessageUid.toString())
          .set({
        'sendBy': _firebaseAuth.currentUser?.displayName.toString(),
        'sendByEmail': _firebaseAuth.currentUser?.email.toString(),
        'message': message,
        'time': FieldValue.serverTimestamp(),
        'singleMessageUid': singleMessageUid,
      });

      // update in my end
      _firebaseFireStore
          .collection('users')
          .doc(_firebaseAuth.currentUser?.uid)
          .collection('ChatUsers')
          .doc(widget.chatRoomId)
          .update({
        'seenMessage': true,
        'lastMessage': message,
        'lastMessageTime': todayTime,

        // 'userName': _firebaseAuth.currentUser?.displayName.toString(),
      });

      // update in receiver end
      _firebaseFireStore
          .collection('users')
          .doc(widget.receiverUid)
          .collection('ChatUsers')
          .doc(widget.chatRoomId)
          .update({
        'seenMessage': false,
        'lastMessage': message,
        'lastMessageTime': todayTime,

        // 'userName': _firebaseAuth.currentUser?.displayName.toString(),
      });
      debugPrint(message);
      debugPrint(todayTime.toString());
    } else {
      debugPrint('Message is empty');
    }
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    // });

    _firebaseFireStore
        .collection('users')
        .doc(_firebaseAuth.currentUser?.uid)
        .collection('ChatUsers')
        .doc(widget.chatRoomId)
        .update({
      'seenMessage': true,
      // 'userName': _firebaseAuth.currentUser?.displayName.toString(),
    });

    // _firebaseFireStore
    //     .collection('ChatRoom')
    //     .doc(widget.chatRoomId.toString())
    //     .update({
    //   // 'buyerName': widget.buyerName,
    //   // 'userName': _firebaseAuth.currentUser?.displayName.toString(),
    //   // 'sellerUid': _firebaseAuth.currentUser?.uid,
    //   // 'buyerUid': widget.buyerUid,
    //   // 'buyerPhoto': widget.buyerPhoto,
    //   // 'userEmail':  widget.buyerEmail,
    //   // 'sellerEmail': _firebaseAuth.currentUser?.email
    //   // 'sellerPhoto': '',
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.receiverName.toString()}'),
      ),
      // MyAppbar().mySimpleAppBar(context,
      //     title: widget.buyerName.toString(), showCart: false),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firebaseFireStore
                  .collection('ChatRoom')
                  .doc(widget.chatRoomId.toString())
                  .collection('chats')
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                String displayName =
                    '${_firebaseAuth.currentUser?.displayName.toString()}';
                if (snapshot.data != null) {
                  return ListView.builder(
                    // physics: AlwaysScrollableScrollPhysics(),
                    // controller: _scrollController,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageBubble(
                          message: snapshot.data?.docs[index]['message'],
                          username: displayName,
                          sellerName: widget.receiverName.toString(),
                          isMe: snapshot.data?.docs[index]['sendByEmail']
                                      .toString() ==
                                  _firebaseAuth.currentUser?.email
                              ? true
                              : false);
                      // Text(snapshot.data?.docs[index]['message']);
                    },
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: TextField(
                    controller: _message,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        contentPadding: const EdgeInsets.only(top: 4, left: 6),
                        hintText: 'Enter a message'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: 11,
                ),
                IconButton(
                    onPressed: () {
                      // print(widget.receiverUid);
                      // print(widget.receiverName);
                      // print(_firebaseAuth.currentUser?.uid);
                      onSendMessage();
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
