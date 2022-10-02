// To parse this JSON data, do
//
//     final myCar = myCarFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:get/get.dart';

class MyCar {
  MyCar({
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
    required this.company,
    required this.brand,
    required this.model,
  }){
    if(avilable == 1){
      availableSwitch = true.obs;
    }else if(avilable == 0){
      availableSwitch = false.obs;
    }
  }

  int id;
  String title;
  String search;
  String image;
  int avilable;
  int companyId;
  int brandId;
  int pricPerDay;
  int doors;
  int passengers;
  String location;
  String color;
  int modelId;
  int year;
  int pricePerMonth;
  String company;
  String brand;
  String model;
  RxBool availableSwitch = false.obs;
  RxBool editLoading = false.obs;

  factory MyCar.fromJson(String str) => MyCar.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MyCar.fromMap(Map<String, dynamic> json) => MyCar(
    id: json["id"],
    title: json["title"],
    search: json["search"],
    image: json["image"],
    avilable: json["avilable"],
    companyId: json["company_id"],
    brandId: json["brand_id"],
    pricPerDay: int.parse(json["pric_per_day"].toString()),
    doors: json["doors"],
    passengers: json["passengers"],
    location: json["location"],
    color: json["color"],
    modelId: json["model_id"],
    year: json["year"],
    pricePerMonth: json["price_per_month"] == null ? 0 : json["price_per_month"],
    company: json["company"],
    brand: json["brand"],
    model: json["model"],
  );

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
    "price_per_month": pricePerMonth == null ? null : pricePerMonth,
    "company": company,
    "brand": brand,
    "model": model,
  };
}
