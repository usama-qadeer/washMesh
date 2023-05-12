class SliderIMg {
  int? status;
  String? message;
  Carousel? data;

  SliderIMg(String body, {this.status, this.message, this.data});

  SliderIMg.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Carousel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Carousel {
  List<SliderImages>? sliderImages;

  Carousel({this.sliderImages});

  Carousel.fromJson(Map<String, dynamic> json) {
    if (json['slider_images'] != null) {
      sliderImages = <SliderImages>[];
      json['slider_images'].forEach((v) {
        sliderImages!.add(new SliderImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sliderImages != null) {
      data['slider_images'] =
          this.sliderImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SliderImages {
  int? id;
  String? image;

  SliderImages({this.id, this.image});

  SliderImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}
