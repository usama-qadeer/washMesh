import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wash_mesh/Chating/create_new_chat.dart';

// import '../providers/chat_provider.dart';
import '../providers/chat_provider/chat_provider.dart';
import 'chat_room.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  ChatsProvider chatsProvider = ChatsProvider();
  @override
  void initState() {
    ChatsProvider chatsProvider = Provider.of(context, listen: false);
    chatsProvider.getChatsData();
    super.initState();
  }

  final _auth = FirebaseAuth.instance.currentUser;

  String timestampToDate(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    // var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    var formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    chatsProvider = Provider.of<ChatsProvider>(context, listen: false);
    // chatsProvider.getChatsData();
    print('*********************');
    print(chatsProvider.getChatsDataList.length);
    print('*********************');
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),

      // appBar: MyAppbar().mySimpleAppBar(context, title: 'Chats'),
      body: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28, top: 28),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateNewChat()));
              },
              title: Text(
                'Creat new chat',
                style: TextStyle(color: Colors.blue),
              ),
              leading: Icon(
                Icons.edit_note,
                color: Colors.blue,
              ),
            ),
            Divider(
              thickness: 2,
              height: 0,
              color: Colors.grey,
            ),
            SizedBox(
              height: 15,
            ),
            Consumer<ChatsProvider>(
              builder: (BuildContext context, value, Widget? child) {
                value.getChatsData();

                return chatsProvider.getChatsDataList.isEmpty
                    ? Center(heightFactor: 5, child: Text('No Chats'))
                    : Expanded(
                        // height: MediaQuery.of(context).size.height / 1.65,
                        child: ListView.builder(
                          itemCount: chatsProvider.getChatsDataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            var data = chatsProvider.getChatsDataList[index];
                            return Column(
                              children: [
                                ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22)),
                                  tileColor: data.seenMessage == true
                                      ? Colors.grey.shade200
                                      : Colors.blue.shade700,
                                  textColor: data.seenMessage == true
                                      ? Colors.black
                                      : Colors.white,
                                  iconColor: data.seenMessage == true
                                      ? Colors.black
                                      : Colors.white,
                                  splashColor: Colors.blue.shade100,
                                  leading:
                                      // data.adminPhoto == ''
                                      //     ?
                                      Icon(
                                    Icons.person_3_rounded,
                                    size: 33,
                                  )
                                  // : CircleAvatar(
                                  //     backgroundImage: NetworkImage(
                                  //       data.userPhoto.toString(),
                                  //     ),
                                  //     radius: 25,
                                  //   )
                                  ,
                                  // Image.network(data.adminPhoto.toString()),
                                  title: Text(data.adminName.toString()),
                                  subtitle: Text(data.lastMessage.toString()),
                                  trailing: Text(timestampToDate(
                                          data.lastMessageTime!.toInt())
                                      .toString()),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatRoom(
                                                chatRoomId: data.roomUid,
                                                receiverEmail: data.userEmail,
                                                receiverUid: data.adminUid,
                                                receiverPhoto: data.userPhoto,
                                                receiverName: data.adminName)));
                                  },
                                ),
                                // Container(
                                //   color: Colors.red,
                                //   height: 33,
                                //   width: 44,
                                // ),
                                SizedBox(
                                  height: 5,
                                ),

                                // ElevatedButton(
                                //     onPressed: () {
                                //       debugPrint(_auth?.uid);
                                //       debugPrint(timestampToDate(
                                //           data.lastMessageTime!.toInt()));
                                //     },
                                //     child: Text('Testing'))
                              ],
                            );
                          },
                        ),
                      );
              },
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       debugPrint(_auth?.uid);
            //       debugPrint(timestampToDate(1681286858571).toString());
            //     },
            //     child: Text('Testing'))
          ],
        ),
      ),
    );
  }
}
