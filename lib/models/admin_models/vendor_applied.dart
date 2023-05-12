class VendorApplied {
  int? status;
  String? message;
  Data? data;

  VendorApplied({this.status, this.message, this.data});

  VendorApplied.fromJson(Map<String, dynamic> json) {
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
  List<Wash>? wash;
  List<Mesh>? mesh;

  Data({this.wash, this.mesh});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['wash'] != null) {
      wash = <Wash>[];
      json['wash'].forEach((v) {
        wash!.add(Wash.fromJson(v));
      });
    }
    if (json['mesh'] != null) {
      mesh = <Mesh>[];
      json['mesh'].forEach((v) {
        mesh!.add(Mesh.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (wash != null) {
      data['wash'] = wash!.map((v) => v.toJson()).toList();
    }
    if (mesh != null) {
      data['mesh'] = mesh!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wash {
  String? categoryId;
  Category? category;

  Wash({this.categoryId, this.category});

  Wash.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Mesh {
  String? categoryId;
  Category? category;

  Mesh({this.categoryId, this.category});

  Mesh.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
