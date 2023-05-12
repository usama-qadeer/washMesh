import 'package:firebase_database/firebase_database.dart';

class AdminDriverModel {
  String? id;
  String? name;
  String? email;
  String? phone;

  AdminDriverModel({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  AdminDriverModel.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    name = (snapshot.value as dynamic)['name'];
    email = (snapshot.value as dynamic)['email'];
    phone = (snapshot.value as dynamic)['phone'];
  }
}
