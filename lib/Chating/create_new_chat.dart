import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../providers/chat_provider.dart';
import '../providers/chat_provider/chat_provider.dart';
import 'chat_room.dart';

class CreateNewChat extends StatefulWidget {
  // String? uId;
  CreateNewChat({Key? key}) : super(key: key);

  @override
  State<CreateNewChat> createState() => _CreateNewChatState();
}

class _CreateNewChatState extends State<CreateNewChat> {
  ChatsProvider chatsProvider = ChatsProvider();

  String chatRoomId(String user1Uid, String user2Uid) {
    if (user1Uid[0].toLowerCase().codeUnits[0] >
        user2Uid[0].toLowerCase().codeUnits[0]) {
      return '${user1Uid.toString().substring(0, 10)}${user2Uid.toString().substring(0, 10)}';
    } else {
      return '${user2Uid.toString().substring(0, 10)}${user1Uid.toString().substring(0, 10)}';
    }
  }

  @override
  void initState() {
    ChatsProvider chatsProvider = Provider.of(context, listen: false);
    chatsProvider.getCreateNewChatsData();
    super.initState();
  }

  final _auth = FirebaseAuth.instance.currentUser;
  final _fireStoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    chatsProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Chat'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 5),
        child: ListView.builder(
          itemCount: chatsProvider.getCreateNewChatsDataList.length,
          itemBuilder: (BuildContext context, int index) {
            var data = chatsProvider.getCreateNewChatsDataList[index];
            return Column(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                  tileColor: Colors.grey.shade400,
                  textColor: Colors.black,
                  iconColor: Colors.black,
                  splashColor: Colors.blue.shade100,
                  leading: data.adminPhoto == ''
                      ? Icon(
                          Icons.person_3_rounded,
                          size: 33,
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                            data.userPhoto.toString(),
                          ),
                          radius: 25,
                        ),
                  // Image.network(data.adminPhoto.toString()),
                  title: Text(data.userName.toString()),
                  subtitle: Text(data.userEmail.toString()),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ChatRoom(
                    //             chatRoomId: data.roomUid,
                    //             buyerEmail: data.userEmail,
                    //             buyerUid: data.userUid,
                    //             buyerPhoto: data.userPhoto,
                    //             buyerName: data.userName)));
                    String roomId =
                        chatRoomId(_auth!.uid, data.userUid.toString());
                    _fireStoreInstance
                        .collection('users')
                        .doc(_auth!.uid)
                        .collection('ChatUsers')
                        .doc(roomId)
                        .set({
                      // 'buyerName': _auth?.displayName.toString(),
                      'adminName': data.userName,
                      'adminUid': data.userUid,
                      'userUid': _auth?.uid,
                      'userPhoto': _auth?.photoURL,
                      // 'sellerPhoto': '${widget.profileImage}',
                      'roomUId': roomId,
                      'userEmail': _auth?.email,
                      'adminEmail': data.userEmail
                    });

                    _fireStoreInstance
                        .collection('users')
                        .doc(data.userUid)
                        .collection('ChatUsers')
                        .doc(roomId)
                        .set({
                      // 'sellerName': _firebaseAuth.currentUser?.displayName.toString(),
                      'adminName': _auth?.displayName,
                      'adminUid': _auth?.uid,
                      'userUid': data.userUid,
                      'userPhoto': _auth?.photoURL,
                      // 'sellerPhoto': '${widget.profileImage}',
                      'roomUId': roomId,
                      'userEmail': data.userEmail,
                      'adminEmail': _auth?.email,
                      'seenMessage': true,
                      'lastMessage': '',
                      // 'sellerEmail': _firebaseAuth.currentUser?.email
                    });

                    _fireStoreInstance.collection('ChatRoom').doc(roomId).set({
                      'userName': _auth?.displayName.toString(),
                      'adminName': data.userName,
                      'adminUid': data.userUid,
                      'userUid': _auth?.uid,
                      'userPhoto': _auth?.photoURL,
                      'roomUId': roomId,
                      'userEmail': _auth?.email,
                      'adminEmail': data.userEmail,
                      'seenMessage': true,
                      'lastMessage': '',
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChatRoom(
                                chatRoomId: roomId,
                                receiverEmail: data.userEmail,
                                receiverUid: data.userUid,
                                receiverPhoto: '',
                                receiverName: data.userName,
                              )),
                    );
                  },
                ),
                Divider(
                  thickness: 5,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
