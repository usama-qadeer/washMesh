class PlaceOrderModel {
  dynamic categoryId;
  dynamic amount;
  dynamic serviceAt;
  dynamic description;
  List<OrderAttribute>? orderAttribute;
  List<String>? picture;

  PlaceOrderModel(
      {this.categoryId,
      this.amount,
      this.serviceAt,
      this.description,
      this.orderAttribute,
      this.picture});

  PlaceOrderModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    amount = json['amount'];
    serviceAt = json['service_at'];
    description = json['description'];
    if (json['order_attribute'] != null) {
      orderAttribute = <OrderAttribute>[];
      json['order_attribute'].forEach((v) {
        orderAttribute!.add(OrderAttribute.fromJson(v));
      });
    }
    picture = json['picture'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['amount'] = amount;
    data['service_at'] = serviceAt;
    data['description'] = description;
    if (orderAttribute != null) {
      data['order_attribute'] = orderAttribute!.map((v) => v.toJson()).toList();
    }
    data['picture'] = picture;
    return data;
  }
}

class OrderAttribute {
  dynamic attributeId;
  dynamic attributeValue;

  OrderAttribute({this.attributeId, this.attributeValue});

  OrderAttribute.fromJson(Map<String, dynamic> json) {
    attributeId = json['attribute_id'];
    attributeValue = json['attribute_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attribute_id'] = attributeId;
    data['attribute_value'] = attributeValue;
    return data;
  }
}
