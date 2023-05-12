import 'package:firebase_database/firebase_database.dart';

class MapUserModel {
  String? id;
  String? name;
  String? email;
  String? phone;

  MapUserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  MapUserModel.fromSnapshot(DataSnapshot snapshot) {
    id = (snapshot.value as dynamic)['id'].toString();
    name = (snapshot.value as dynamic)['name'];
    email = (snapshot.value as dynamic)['email'];
    phone = (snapshot.value as dynamic)['phone'];
  }
}
