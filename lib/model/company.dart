// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Company> companyFromJson(String str) => List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyToJson(List<Company> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  Company({
    required this.id,
    required this.username,
    required this.password,
    required this.profileImage,
    required this.coverImage,
    required this.title,
    required this.myOrders,
    required this.customerOrders,
  });

  int id;
  String username;
  String password;
  String profileImage;
  dynamic coverImage;
  String title;
  Orders myOrders;
  Orders customerOrders;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
    id: json["id"] ?? -1,
    username: json["username"] ?? "",
    password: json["password"] ?? "",
    profileImage: json["profile_image"]  ?? "",
    coverImage: json["cover_image"]?? "",
    title: json["title"] ?? "",
    myOrders: Orders.fromJson(json["my_orders"]),
    customerOrders: Orders.fromJson(json["customer_orders"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
    "profile_image": profileImage,
    "cover_image": coverImage,
    "title": title,
    "my_orders": myOrders.toJson(),
    "customer_orders": customerOrders.toJson(),
  };
}

class Orders {
  Orders({
    required this.rejected,
    required this.pending,
    required this.accepted,
  });

  List<Accepted> rejected;
  List<Accepted> pending;
  List<Accepted> accepted;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    rejected: List<Accepted>.from(json["rejected"].map((x) => Accepted.fromJson(x))),
    pending: List<Accepted>.from(json["pending"].map((x) => Accepted.fromJson(x))),
    accepted: List<Accepted>.from(json["accepted"].map((x) => Accepted.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "rejected": List<dynamic>.from(rejected.map((x) => x.toJson())),
    "pending": List<dynamic>.from(pending.map((x) => x.toJson())),
    "accepted": List<dynamic>.from(accepted.map((x) => x.toJson())),
  };
}

class Accepted {
  Accepted({
    required this.id,
    required this.placedAt,
    required this.from,
    required this.to,
    required this.fromCompnay,
    required this.toCompany,
    required this.carId,
    required this.state,
    required this.total,
    required this.title,
    required this.image,
    required this.fromCompnayTitle,
    required this.toCompnayTitle,
  });

  int id;
  DateTime placedAt;
  DateTime from;
  DateTime to;
  int fromCompnay;
  int toCompany;
  int carId;
  int state;
  int total;
  String title;
  String image;
  String fromCompnayTitle;
  String toCompnayTitle;

  factory Accepted.fromJson(Map<String, dynamic> json) => Accepted(
    id: json["id"] ?? -1,
    placedAt: DateTime.parse(json["placed_at"]),
    from: DateTime.parse(json["_from"]),
    to: DateTime.parse(json["_to"]),
    fromCompnay: json["from_compnay"],
    toCompany: json["to_company"],
    carId: json["car_id"],
    state: json["state"],
    total: json["total"],
    title: json["title"],
    image: json["image"],
    fromCompnayTitle: json["from_compnay_title"],
    toCompnayTitle: json["to_compnay_title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "placed_at": placedAt.toIso8601String(),
    "_from": from.toIso8601String(),
    "_to": to.toIso8601String(),
    "from_compnay": fromCompnay,
    "to_company": toCompany,
    "car_id": carId,
    "state": state,
    "total": total,
    "title": title,
    "image": image,
    "from_compnay_title": fromCompnayTitle,
    "to_compnay_title": toCompnayTitle,
  };
}





// // To parse this JSON data, do
// //
// //     final company = companyFromMap(jsonString);
//
// import 'dart:convert';
//
// class Company {
//   Company({
//     required this.id,
//     required this.username,
//     required this.password,
//     required this.profileImage,
//     required this.coverImage,
//     required this.title,
//   });
//
//   int id;
//   String username;
//   String password;
//   dynamic profileImage;
//   dynamic coverImage;
//   String title;
//
//   factory Company.fromJson(String str) => Company.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory Company.fromMap(Map<String, dynamic> json) => Company(
//     id: json["id"],
//     username: json["username"],
//     password: json["password"],
//     profileImage: json["profile_image"],
//     coverImage: json["cover_image"],
//     title: json["title"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "id": id,
//     "username": username,
//     "password": password,
//     "profile_image": profileImage,
//     "cover_image": coverImage,
//     "title": title,
//   };
// }
