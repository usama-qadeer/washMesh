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

  Data(
      {this.id,
      this.typeId,
      this.userId,
      this.vendorId,
      this.amount,
      this.status,
      this.description,
      this.serviceAt,
      this.createdAt,
      this.updatedAt});

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
