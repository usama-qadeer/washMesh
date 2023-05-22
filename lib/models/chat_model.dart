class ChatsModel {
  String? userName;
  String? adminName;
  String? userUid;
  String? adminUid;
  String? roomUid;
  String? adminPhoto;
  String? userPhoto;
  String? userEmail;
  String? adminEmail;
  String? lastMessage;
  int? lastMessageTime;
  bool? seenMessage;

  ChatsModel({
    this.lastMessageTime,
    this.lastMessage,
    this.seenMessage,
    this.userEmail,
    this.adminEmail,
    this.adminPhoto,
    this.adminUid,
    this.adminName,
    this.userUid,
    this.userName,
    this.userPhoto,
    this.roomUid,
  });
}
