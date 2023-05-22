class VendorOrders {
  int? status;
  String? message;
  List<Data>? data;

  VendorOrders({this.status, this.message, this.data});

  VendorOrders.fromJson(Map<String, dynamic> json) {
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
  int? id;
  dynamic typeId;
  dynamic userId;
  dynamic vendorId;
  dynamic amount;
  dynamic status;
  dynamic description;
  dynamic serviceAt;
  dynamic createdAt;
  dynamic updatedAt;
  Customer? customer;

  Data({
    this.id,
    this.typeId,
    this.userId,
    this.vendorId,
    this.amount,
    this.status,
    this.description,
    this.serviceAt,
    this.createdAt,
    this.updatedAt,
    this.customer,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeId = json['type_id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    amount = json['amount'];
    status = json['status'];
    description = json['description'];
    serviceAt = json['service_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type_id'] = typeId;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['amount'] = amount;
    data['status'] = status;
    data['description'] = description;
    data['service_at'] = serviceAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Customer {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? gender;
  String? email;
  String? fcmToken;
  Null? userName;
  Null? referralCode;
  String? userType;
  String? image;
  String? status;
  Null? rating;
  int? integerRating;
  int? floatRating;

  Customer(
      {this.id,
      this.firstName,
      this.lastName,
      this.phone,
      this.address,
      this.gender,
      this.email,
      this.fcmToken,
      this.userName,
      this.referralCode,
      this.userType,
      this.image,
      this.status,
      this.rating,
      this.integerRating,
      this.floatRating});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    address = json['address'];
    gender = json['gender'];
    email = json['email'];
    fcmToken = json['fcm_token'];
    userName = json['user_name'];
    referralCode = json['referral_code'];
    userType = json['user_type'];
    image = json['image'];
    status = json['status'];
    rating = json['rating'];
    integerRating = json['integer_rating'];
    floatRating = json['float_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['fcm_token'] = this.fcmToken;
    data['user_name'] = this.userName;
    data['referral_code'] = this.referralCode;
    data['user_type'] = this.userType;
    data['image'] = this.image;
    data['status'] = this.status;
    data['rating'] = this.rating;
    data['integer_rating'] = this.integerRating;
    data['float_rating'] = this.floatRating;
    return data;
  }
}
