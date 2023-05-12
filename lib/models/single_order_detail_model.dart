class SingleOrderDetailModel {
  int? status;
  String? message;
  Data? data;

  SingleOrderDetailModel({this.status, this.message, this.data});

  SingleOrderDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? typeId;
  String? userId;
  String? vendorId;
  String? amount;
  String? extraCharges;
  String? total;
  String? status;
  String? description;
  String? serviceAt;
  String? createdAt;
  String? updatedAt;
  Vendors? vendors;
  Customer? customer;

  Data(
      {this.id,
      this.typeId,
      this.userId,
      this.vendorId,
      this.amount,
      this.extraCharges,
      this.total,
      this.status,
      this.description,
      this.serviceAt,
      this.createdAt,
      this.updatedAt,
      this.vendors,
      this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    amount = json['amount'];
    extraCharges = json['extra_charges'];
    total = json['total'];
    status = json['status'];
    description = json['description'];
    serviceAt = json['service_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vendors =
        json['vendors'] != null ? Vendors.fromJson(json['vendors']) : null;
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type_id'] = typeId;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['amount'] = amount;
    data['extra_charges'] = extraCharges;
    data['total'] = total;
    data['status'] = status;
    data['description'] = description;
    data['service_at'] = serviceAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (vendors != null) {
      data['vendors'] = vendors!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class Vendors {
  int? id;
  int? userId;
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
  int? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? image;
  String? phone;
  String? address;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.userName,
      this.image,
      this.phone,
      this.address});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userName = json['user_name'];
    image = json['image'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['user_name'] = userName;
    data['image'] = image;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  Null? userName;
  String? image;
  String? phone;
  String? address;

  Customer(
      {this.id,
      this.firstName,
      this.lastName,
      this.userName,
      this.image,
      this.phone,
      this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userName = json['user_name'];
    image = json['image'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['user_name'] = userName;
    data['image'] = image;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}
