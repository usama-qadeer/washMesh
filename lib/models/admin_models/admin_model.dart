class AdminModel {
  dynamic status;
  dynamic message;
  Data? data;

  AdminModel({this.status, this.message, this.data});

  AdminModel.fromJson(Map<String, dynamic> json) {
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
  Vendor? vendor;

  Data({this.token, this.vendor});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    vendor = json['Vendor'] != null ? Vendor.fromJson(json['Vendor']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (vendor != null) {
      data['Vendor'] = vendor!.toJson();
    }
    return data;
  }
}

class Vendor {
  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic phone;
  dynamic address;
  dynamic email;
  dynamic password;
  dynamic confirmPassword;
  dynamic userName;
  dynamic referralCode;
  dynamic userType;
  dynamic image;
  dynamic status;
  VendorDetails? vendorDetails;

  Vendor({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.email,
    this.password,
    this.confirmPassword,
    this.userName,
    this.referralCode,
    this.userType,
    this.image,
    this.status,
    this.vendorDetails,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    address = json['address'];
    email = json['email'];
    password = json['password'];
    confirmPassword = json['confirm_password'];
    userName = json['user_name'];
    referralCode = json['referral_code'];
    userType = json['user_type'];
    image = json['image'];
    status = json['status'];
    vendorDetails = json['vendor_details'] != null
        ? VendorDetails.fromJson(json['vendor_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['address'] = address;
    data['email'] = email;
    data['password'] = password;
    data['confirm_password'] = confirmPassword;
    data['user_name'] = userName;
    data['referral_code'] = referralCode;
    data['user_type'] = userType;
    data['image'] = image;
    data['status'] = status;
    if (vendorDetails != null) {
      data['vendor_details'] = vendorDetails!.toJson();
    }
    return data;
  }
}

class VendorDetails {
  dynamic id;
  dynamic userId;
  dynamic cnic;
  dynamic experience;
  dynamic experienceCertImg;
  dynamic cnicFrontImg;
  dynamic cnicBackImg;
  dynamic availability;
  dynamic gender;

  VendorDetails(
      {this.id,
      this.userId,
      this.cnic,
      this.experience,
      this.experienceCertImg,
      this.cnicFrontImg,
      this.cnicBackImg,
      this.availability,
      this.gender});

  VendorDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    cnic = json['cnic'];
    experience = json['experience'];
    experienceCertImg = json['experience_cert_img'];
    cnicFrontImg = json['cnic_front_img'];
    cnicBackImg = json['cnic_back_img'];
    availability = json['availability'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['cnic'] = cnic;
    data['experience'] = experience;
    data['experience_cert_img'] = experienceCertImg;
    data['cnic_front_img'] = cnicFrontImg;
    data['cnic_back_img'] = cnicBackImg;
    data['availability'] = availability;
    data['gender'] = gender;
    return data;
  }
}
