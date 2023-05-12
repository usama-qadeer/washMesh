class UserModel {
  dynamic status;
  dynamic message;
  Data? data;

  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? token;
  User? user;

  Data({this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    return data;
  }
}

class User {
  dynamic firstName;
  dynamic lastName;
  dynamic email;
  dynamic phone;
  dynamic password;
  dynamic confirmPassword;
  dynamic address;
  dynamic gender;
  dynamic image;
  dynamic userType;
  dynamic id;

  User(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.password,
      this.confirmPassword,
      this.address,
      this.gender,
      this.image,
      this.userType,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
    address = json['address'];
    image = json['image'];
    gender = json['gender'];
    userType = json['user_type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['confirm_password'] = confirmPassword;
    data['address'] = address;
    data['image'] = address;
    data['gender'] = gender;
    data['user_type'] = userType;
    data['id'] = id;
    return data;
  }
}
