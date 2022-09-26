import 'dart:convert';

class SearchSuggestion {
  SearchSuggestion({
    required this.title,
    required this.company,
    required this.brand,
    required this.model,
    required this.image,
  });

  String title;
  String company;
  String brand;
  String model;
  String image;

  factory SearchSuggestion.fromJson(String str) => SearchSuggestion.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchSuggestion.fromMap(Map<String, dynamic> json) => SearchSuggestion(
    title: json["title"],
    company: json["company"],
    brand: json["brand"],
    model: json["model"],
    image: json["image"],
  );

  Map<String, dynamic> toMap() => {
    "title": title,
    "company": company,
    "brand": brand,
    "model": model,
  };
}