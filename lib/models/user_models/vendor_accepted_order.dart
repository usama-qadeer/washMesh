class VendorAcceptedOrder {
  dynamic status;
  dynamic message;
  List<Data>? data;

  VendorAcceptedOrder({this.status, this.message, this.data});

  VendorAcceptedOrder.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  dynamic id;
  dynamic vendorId;
  dynamic status;
  dynamic orderId;
  Vendors? vendors;

  Data({this.id, this.vendorId, this.status, this.orderId, this.vendors});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorId = json['vendor_id'];
    status = json['status'];
    orderId = json['order_id'];
    vendors =
        json['vendors'] != null ? Vendors.fromJson(json['vendors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vendor_id'] = vendorId;
    data['status'] = status;
    data['order_id'] = orderId;
    if (vendors != null) {
      data['vendors'] = vendors!.toJson();
    }
    return data;
  }
}

class Vendors {
  dynamic id;
  dynamic userId;
  User? user;

  Vendors({this.id, this.userId, this.user});

  Vendors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic userName;
  dynamic image;
  dynamic status;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.userName,
      this.image,
      this.status});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userName = json['user_name'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['user_name'] = userName;
    data['image'] = image;
    data['status'] = status;
    return data;
  }
}
