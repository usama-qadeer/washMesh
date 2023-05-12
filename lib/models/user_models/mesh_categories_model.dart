class MeshCategoryModel {
  dynamic status;
  dynamic message;
  List<Data>? data;

  MeshCategoryModel({this.status, this.message, this.data});

  MeshCategoryModel.fromJson(Map<String, dynamic> json) {
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
  dynamic name;
  dynamic image;
  dynamic fixedPrice;
  List<CatAttribute>? catAttribute;

  Data({this.id, this.name, this.image, this.catAttribute});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    fixedPrice = json['fixed_price'];
    if (json['cat_attribute'] != null) {
      catAttribute = <CatAttribute>[];
      json['cat_attribute'].forEach((v) {
        catAttribute!.add(CatAttribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['fixed_price'] = fixedPrice;
    if (catAttribute != null) {
      data['cat_attribute'] = catAttribute!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CatAttribute {
  dynamic id;
  dynamic attributeId;
  dynamic categoryId;
  Attribute? attribute;

  CatAttribute({this.id, this.attributeId, this.categoryId, this.attribute});

  CatAttribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeId = json['attribute_id'];
    categoryId = json['category_id'];
    attribute = json['attribute'] != null
        ? Attribute.fromJson(json['attribute'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attribute_id'] = attributeId;
    data['category_id'] = categoryId;
    if (attribute != null) {
      data['attribute'] = attribute!.toJson();
    }
    return data;
  }
}

class Attribute {
  dynamic id;
  dynamic name;
  dynamic type;
  dynamic rate;
  List<AttributeValue>? attributeValue;

  Attribute({this.id, this.name, this.type, this.attributeValue});

  Attribute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    rate = json['rate'];
    if (json['attribute_value'] != null) {
      attributeValue = <AttributeValue>[];
      json['attribute_value'].forEach((v) {
        attributeValue!.add(AttributeValue.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['rate'] = rate;
    if (attributeValue != null) {
      data['attribute_value'] = attributeValue!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttributeValue {
  dynamic id;
  dynamic attributeId;
  dynamic name;
  dynamic order;

  AttributeValue({this.id, this.attributeId, this.name, this.order});

  AttributeValue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attributeId = json['attribute_id'];
    name = json['name'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['attribute_id'] = attributeId;
    data['name'] = name;
    data['order'] = order;
    return data;
  }
}
