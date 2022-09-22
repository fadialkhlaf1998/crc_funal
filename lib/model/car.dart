// To parse this JSON data, do
//
//     final car = carFromMap(jsonString);

import 'package:get/get.dart';
import 'dart:convert';

class Car {
  Car({
    required this.id,
    required this.title,
    required this.search,
    required this.image,
    required this.avilable,
    required this.companyId,
    required this.brandId,
    required this.pricPerDay,
    required this.doors,
    required this.passengers,
    required this.location,
    required this.color,
    required this.modelId,
    required this.year,
    required this.pricePerMonth,
    required this.brand,
    required this.model,
    required this.company,
    required this.companyImage,
    required this.images,
    required this.pricPerHr,
  });

  int id;
  String title;
  String search;
  String image;
  int avilable;
  int companyId;
  int brandId;
  double pricPerDay;
  double pricPerHr;

  int doors;
  int passengers;
  String location;
  String color;
  int modelId;
  int year;
  dynamic pricePerMonth;
  String brand;
  String model;
  String company;
  String companyImage;
  List<myImage> images;
  RxBool bookOption = false.obs;

  factory Car.fromJson(String str) => Car.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Car.fromMap(Map<String, dynamic> json) {

    var car = Car(
      id: json["id"],
      title: json["title"],
      search: json["search"],
      image: json["image"],
      avilable: json["avilable"],
      companyId: json["company_id"],
      brandId: json["brand_id"],
      pricPerDay: json["pric_per_day"]== null?0.0:double.parse(json["pric_per_day"].toString()),
      pricPerHr: json["price_per_hour"]== null?0.0:double.parse(json["price_per_hour"].toString()),
      doors: json["doors"],
      passengers: json["passengers"],
      location: json["location"],
      color: json["color"],
      modelId: json["model_id"],
      year: json["year"],
      pricePerMonth: json["price_per_month"],
      brand:json["brand"]==null?"": json["brand"],
      model:json["model"]==null?"": json["model"],
      company:json["company"]==null?"": json["company"],
      companyImage:json["company_image"]==null?"":json["company_image"],
      images: List<myImage>.from(json["images"].map((x) => myImage.fromMap(x))),
    );
    car.images.add(myImage(id: -1, link: car.image, carId: -1));
    return car;
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "search": search,
    "image": image,
    "avilable": avilable,
    "company_id": companyId,
    "brand_id": brandId,
    "pric_per_day": pricPerDay,
    "doors": doors,
    "passengers": passengers,
    "location": location,
    "color": color,
    "model_id": modelId,
    "year": year,
    "price_per_month": pricePerMonth,
    "brand": brand,
    "model": model,
    "company": company,
    "company_image": companyImage,
    "images": List<dynamic>.from(images.map((x) => x.toMap())),
  };
}

class myImage {
  myImage({
    required this.id,
    required this.link,
    required this.carId,
  });

  int id;
  String link;
  int carId;

  factory myImage.fromJson(String str) => myImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory myImage.fromMap(Map<String, dynamic> json) => myImage(
    id: json["id"],
    link: json["link"],
    carId: json["car_id"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "link": link,
    "car_id": carId,
  };
}
